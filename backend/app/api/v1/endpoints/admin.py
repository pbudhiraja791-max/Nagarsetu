import json
import logging
from datetime import datetime, timedelta
from typing import List, Optional, Dict, Any
from fastapi import APIRouter, Depends, HTTPException, status, Query
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import func, distinct

from app.core.database import get_db
from app.api.v1.endpoints.auth import get_current_user, require_role
from app.models.user import User, UserRole
from app.models.issue import Issue, IssueStatus, IssueType, SeverityLevel
from app.models.history import IssueStatusHistory
from app.models.intelligence import (
    Report, ReportMedia, ReportMatch, SeverityAssessment,
    IssueActivityLog, DedupConfig, SeverityConfig, PriorityConfig, AdminReview
)
from app.schemas.intelligence import (
    ConfirmDuplicateRequest, RejectDuplicateRequest, MoveReportRequest,
    InvalidateReportRequest, OverrideSeverityRequest, DedupConfigUpdate,
    SeverityConfigUpdate, PriorityConfigUpdate
)
from app.services.counter_management_service import (
    recompute_and_update_issue_counters, reconcile_all_issues, reconcile_single_issue
)
from app.services.dynamic_priority_service import calculate_dynamic_priority
from app.services.routing_service import route_issue_to_department
from app.services.priority_service import get_sla_hours_from_priority

logger = logging.getLogger("nagarsetu.admin_api")
router = APIRouter()


# -------------------------------------------------------------------
# 1. DUPLICATE REVIEW QUEUE
# -------------------------------------------------------------------
@router.get("/duplicate-review")
def list_pending_duplicates(
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role(UserRole.ADMIN))
):
    """
    Returns pending citizen reports that matched an existing issue with medium confidence
    and require administrator review and consolidation decision.
    """
    pending_reports = db.query(Report).options(
        joinedload(Report.media),
        joinedload(Report.matches),
        joinedload(Report.suggested_issue)
    ).filter(
        Report.status == "pending_review"
    ).order_by(Report.created_at.desc()).all()

    results = []
    for rep in pending_reports:
        match_info = rep.matches[0] if rep.matches else None
        sugg = rep.suggested_issue
        results.append({
            "report_id": rep.id,
            "report_tracking_id": rep.report_tracking_id,
            "submission_id": rep.submission_id,
            "created_at": rep.created_at.isoformat(),
            "reporter_name": rep.reporter_name,
            "category": rep.selected_category,
            "description": rep.description,
            "address": rep.address,
            "latitude": rep.latitude,
            "longitude": rep.longitude,
            "image_url": rep.media[0].image_url if rep.media else None,
            "suggested_issue": {
                "id": sugg.id if sugg else None,
                "display_id": sugg.display_id if sugg else None,
                "title": sugg.title if sugg else None,
                "description": sugg.description if sugg else None,
                "category": getattr(sugg.issue_type, 'value', str(sugg.issue_type)) if sugg else None,
                "address": sugg.address if sugg else None,
                "total_reports": sugg.total_reports if sugg else 1,
                "unique_citizens": sugg.unique_citizens if sugg else 1,
                "severity_level": sugg.severity_level if sugg else "MEDIUM",
                "priority_score": sugg.priority_score if sugg else 50.0,
                "status": getattr(sugg.status, 'value', str(sugg.status)) if sugg else None,
                "image_url": sugg.images[0].original_image_path if (sugg and sugg.images) else None
            } if sugg else None,
            "match_metrics": {
                "final_score": match_info.final_score if match_info else 0.65,
                "geo_similarity": match_info.geo_similarity if match_info else 0.70,
                "visual_similarity": match_info.visual_similarity if match_info else 0.60,
                "text_similarity": match_info.text_similarity if match_info else 0.60,
                "context_similarity": match_info.context_similarity if match_info else 0.80,
                "ai_confidence": match_info.confidence if match_info else 0.80,
                "ai_reasoning": match_info.ai_reasoning if match_info else "Pending administrator inspection",
                "model_name": match_info.model_name if match_info else "nagarsetu-dedup-v1"
            } if match_info else None
        })

    return {
        "pending_count": len(results),
        "pending_duplicates": results
    }


@router.post("/duplicate-review/{report_id}/confirm")
def confirm_duplicate(
    report_id: int,
    payload: ConfirmDuplicateRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role(UserRole.ADMIN))
):
    """
    Administrator confirms that the pending report IS a duplicate of suggested_issue.
    Links the report, sets status='accepted', counted=True, increments total_reports exactly once,
    updates unique_citizens if appropriate, recalculates priority, and logs audit entry.
    """
    report = db.query(Report).filter(Report.id == report_id).first()
    if not report:
        raise HTTPException(404, "Report not found")

    # Double-confirmation protection: if already accepted and counted for an issue, do not double-count
    if report.status == "accepted" and report.counted and report.issue_id:
        return {
            "status": "ALREADY_CONFIRMED",
            "report_id": report.id,
            "issue_id": report.issue_id,
            "message": "Report is already confirmed and counted for this issue."
        }

    if not report.suggested_issue_id:
        raise HTTPException(400, "Report does not have an associated candidate issue")

    target_issue = db.query(Issue).filter(Issue.id == report.suggested_issue_id).first()
    if not target_issue:
        raise HTTPException(404, "Candidate civic issue not found")

    old_total = target_issue.total_reports or 1
    old_unique = target_issue.unique_citizens or 1

    # Link and accept report
    report.issue_id = target_issue.id
    report.suggested_issue_id = None
    report.status = "accepted"
    report.counted = True
    report.link_method = "manual_admin"
    db.flush()

    # Atomic counter recomputation
    counters = recompute_and_update_issue_counters(db, target_issue.id)

    # Recalculate Dynamic Priority
    p_score, p_level, p_breakdown, p_expl = calculate_dynamic_priority(
        severity_score=target_issue.severity_score or 50.0,
        category=getattr(target_issue.issue_type, 'value', str(target_issue.issue_type)),
        unique_citizens=counters["unique_citizens"],
        first_reported_at=target_issue.first_reported_at or target_issue.created_at,
        is_escalated=target_issue.is_escalated
    )
    target_issue.priority_score = p_score
    target_issue.priority_level = p_level
    target_issue.priority_breakdown = json.dumps(p_breakdown)
    target_issue.priority_explanation = p_expl
    target_issue.last_reported_at = datetime.utcnow()

    # Record Admin Review Audit
    db.add(AdminReview(
        report_id=report.id,
        issue_id=target_issue.id,
        admin_id=current_user.id,
        review_type="DUPLICATE_REVIEW",
        decision="CONFIRMED_DUPLICATE",
        notes=payload.notes or "Administrator confirmed duplicate and consolidated report.",
        previous_values=json.dumps({"total_reports": old_total, "unique_citizens": old_unique}),
        new_values=json.dumps({"total_reports": counters["total_reports"], "unique_citizens": counters["unique_citizens"]})
    ))

    # Record Issue Activity Log
    db.add(IssueActivityLog(
        issue_id=target_issue.id,
        report_id=report.id,
        actor_id=current_user.id,
        actor_name=current_user.full_name,
        actor_role="ADMIN",
        action="REPORT_LINKED",
        before_state=json.dumps({"total_reports": old_total, "unique_citizens": old_unique}),
        after_state=json.dumps({"total_reports": counters["total_reports"], "unique_citizens": counters["unique_citizens"], "link_method": "manual_admin"}),
        notes=f"Administrator confirmed duplicate {report.report_tracking_id} linked to {target_issue.display_id}."
    ))

    db.commit()
    return {
        "status": "CONFIRMED",
        "report_id": report.id,
        "issue_id": target_issue.id,
        "display_id": target_issue.display_id,
        "total_reports": counters["total_reports"],
        "unique_citizens": counters["unique_citizens"],
        "priority_score": p_score,
        "priority_level": p_level,
        "message": f"Report {report.report_tracking_id} successfully linked to {target_issue.display_id}. Total reports updated to {counters['total_reports']}."
    }


@router.post("/duplicate-review/{report_id}/reject")
def reject_duplicate_and_create_issue(
    report_id: int,
    payload: RejectDuplicateRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role(UserRole.ADMIN))
):
    """
    Administrator rejects duplicate: establishes this report as a distinct new civic problem.
    Creates new issue with display_id, initializes total_reports=1, unique_citizens=1,
    links report as direct creation, and logs audit entry.
    """
    report = db.query(Report).filter(Report.id == report_id).first()
    if not report:
        raise HTTPException(404, "Report not found")

    old_sugg_id = report.suggested_issue_id
    dept = route_issue_to_department(db, report.selected_category)

    # Next display ID
    last_issue = db.query(Issue).order_by(Issue.id.desc()).first()
    next_num = (last_issue.id + 101) if last_issue else 101
    display_id = f"NG-{next_num}"

    # Calculate initial priority
    p_score, p_level, p_breakdown, p_expl = calculate_dynamic_priority(
        severity_score=50.0,
        category=report.selected_category,
        unique_citizens=1,
        first_reported_at=datetime.utcnow()
    )
    sla_hours = get_sla_hours_from_priority(p_score)
    deadline = datetime.utcnow() + timedelta(hours=sla_hours)

    new_issue = Issue(
        display_id=display_id,
        title=f"{report.selected_category} at {report.address.split(',')[0] if report.address else 'Reported Area'}",
        summary=report.description[:200] if report.description else report.selected_category,
        description=report.description,
        issue_type=getattr(IssueType, report.selected_category.upper().replace(' ', '_'), report.selected_category),
        latitude=report.latitude,
        longitude=report.longitude,
        address=report.address,
        area=report.address.split(",")[-1].strip() if report.address and "," in report.address else None,
        severity_score=50.0,
        severity_level="MEDIUM",
        severity=SeverityLevel.MEDIUM,
        priority_score=p_score,
        priority_level=p_level,
        priority_breakdown=json.dumps(p_breakdown),
        priority_explanation=p_expl,
        total_reports=1,
        unique_citizens=1,
        first_reported_at=report.created_at or datetime.utcnow(),
        last_reported_at=report.created_at or datetime.utcnow(),
        status=IssueStatus.AI_ANALYZED,
        reporter_id=report.reporter_id,
        department_id=dept.id if dept else None,
        assigned_department=dept.name if dept else None,
        sla_hours=sla_hours,
        sla_deadline=deadline,
        deadline=deadline,
        support_count=1
    )
    db.add(new_issue)
    db.flush()

    report.issue_id = new_issue.id
    report.suggested_issue_id = None
    report.status = "accepted"
    report.counted = True
    report.link_method = "manual_admin_rejected_duplicate"

    # Admin Review Audit
    db.add(AdminReview(
        report_id=report.id,
        issue_id=new_issue.id,
        admin_id=current_user.id,
        review_type="DUPLICATE_REVIEW",
        decision="REJECTED_DUPLICATE",
        notes=payload.reason or "Administrator rejected duplicate match; created distinct civic issue.",
        previous_values=json.dumps({"suggested_issue_id": old_sugg_id}),
        new_values=json.dumps({"new_issue_id": new_issue.id, "display_id": display_id})
    ))

    # Activity Log
    db.add(IssueActivityLog(
        issue_id=new_issue.id,
        report_id=report.id,
        actor_id=current_user.id,
        actor_name=current_user.full_name,
        actor_role="ADMIN",
        action="ISSUE_CREATED",
        before_state=None,
        after_state=json.dumps({"display_id": display_id, "total_reports": 1}),
        notes=f"New civic issue {display_id} created after administrator rejected duplicate candidate."
    ))

    db.commit()
    return {
        "status": "REJECTED_AND_CREATED",
        "new_issue_id": new_issue.id,
        "display_id": display_id,
        "total_reports": 1,
        "unique_citizens": 1,
        "message": f"Duplicate rejected. Created new independent civic problem {display_id}."
    }


@router.post("/duplicate-review/{report_id}/move")
def move_report_to_issue(
    report_id: int,
    payload: MoveReportRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role(UserRole.ADMIN))
):
    """
    Moves a report to another existing civic issue.
    Decrements old issue counters atomically, increments target issue counters atomically,
    and recalculates priorities.
    """
    report = db.query(Report).filter(Report.id == report_id).first()
    if not report:
        raise HTTPException(404, "Report not found")
    
    target_issue = db.query(Issue).filter(Issue.id == payload.target_issue_id).first()
    if not target_issue:
        raise HTTPException(404, "Target issue not found")

    old_issue_id = report.issue_id
    report.issue_id = target_issue.id
    report.suggested_issue_id = None
    report.status = "accepted"
    report.counted = True
    report.link_method = "manual_admin_moved"
    db.flush()

    # Recompute old issue counters if it existed
    if old_issue_id and old_issue_id != target_issue.id:
        recompute_and_update_issue_counters(db, old_issue_id)

    # Recompute new issue counters
    new_counters = recompute_and_update_issue_counters(db, target_issue.id)

    # Recalculate target issue priority
    p_score, p_level, p_breakdown, p_expl = calculate_dynamic_priority(
        severity_score=target_issue.severity_score or 50.0,
        category=getattr(target_issue.issue_type, 'value', str(target_issue.issue_type)),
        unique_citizens=new_counters["unique_citizens"],
        first_reported_at=target_issue.first_reported_at or target_issue.created_at,
        is_escalated=target_issue.is_escalated
    )
    target_issue.priority_score = p_score
    target_issue.priority_level = p_level
    target_issue.priority_breakdown = json.dumps(p_breakdown)
    target_issue.priority_explanation = p_expl

    # Admin Review Audit
    db.add(AdminReview(
        report_id=report.id,
        issue_id=target_issue.id,
        admin_id=current_user.id,
        review_type="DUPLICATE_REVIEW",
        decision="MOVED_ISSUE",
        notes=payload.notes or f"Moved from issue {old_issue_id} to issue {target_issue.id}",
        previous_values=json.dumps({"old_issue_id": old_issue_id}),
        new_values=json.dumps({"new_issue_id": target_issue.id, "display_id": target_issue.display_id})
    ))

    db.commit()
    return {
        "status": "MOVED",
        "target_issue_id": target_issue.id,
        "display_id": target_issue.display_id,
        "total_reports": new_counters["total_reports"],
        "unique_citizens": new_counters["unique_citizens"]
    }


@router.post("/duplicate-review/{report_id}/invalidate")
def invalidate_report(
    report_id: int,
    payload: InvalidateReportRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role(UserRole.ADMIN))
):
    """
    Invalidates a citizen report (e.g. spam, incorrect submission, or abusive entry).
    Sets status='invalidated', counted=False.
    If previously counted, decrements parent issue counters exactly once and recalculates priority.
    """
    report = db.query(Report).filter(Report.id == report_id).first()
    if not report:
        raise HTTPException(404, "Report not found")

    parent_issue_id = report.issue_id
    was_counted = report.counted

    report.status = "invalidated"
    report.counted = False
    db.flush()

    new_counters = None
    if parent_issue_id and was_counted:
        new_counters = recompute_and_update_issue_counters(db, parent_issue_id)
        parent_issue = db.query(Issue).filter(Issue.id == parent_issue_id).first()
        if parent_issue:
            p_score, p_level, p_breakdown, p_expl = calculate_dynamic_priority(
                severity_score=parent_issue.severity_score or 50.0,
                category=getattr(parent_issue.issue_type, 'value', str(parent_issue.issue_type)),
                unique_citizens=new_counters["unique_citizens"],
                first_reported_at=parent_issue.first_reported_at or parent_issue.created_at,
                is_escalated=parent_issue.is_escalated
            )
            parent_issue.priority_score = p_score
            parent_issue.priority_level = p_level
            parent_issue.priority_breakdown = json.dumps(p_breakdown)
            parent_issue.priority_explanation = p_expl

            db.add(IssueActivityLog(
                issue_id=parent_issue.id,
                report_id=report.id,
                actor_id=current_user.id,
                actor_name=current_user.full_name,
                actor_role="ADMIN",
                action="REPORT_INVALIDATED",
                before_state=json.dumps({"total_reports": (new_counters["total_reports"] + 1)}),
                after_state=json.dumps({"total_reports": new_counters["total_reports"], "unique_citizens": new_counters["unique_citizens"]}),
                notes=f"Report {report.report_tracking_id} invalidated: {payload.reason}"
            ))

    db.add(AdminReview(
        report_id=report.id,
        issue_id=parent_issue_id,
        admin_id=current_user.id,
        review_type="REPORT_INVALIDATION",
        decision="INVALIDATED",
        notes=payload.reason
    ))

    db.commit()
    return {
        "status": "INVALIDATED",
        "report_id": report.id,
        "parent_issue_id": parent_issue_id,
        "new_counters": new_counters,
        "message": f"Report {report.report_tracking_id} successfully invalidated."
    }


# -------------------------------------------------------------------
# 2. SEVERITY REVIEW QUEUE
# -------------------------------------------------------------------
@router.get("/severity-review")
def list_severity_reviews(
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role(UserRole.ADMIN))
):
    """
    Returns civic issues requiring manual severity review (e.g. low AI confidence,
    critical emergency flags, or disputed assessments).
    """
    # Query issues with low confidence or critical severity
    issues = db.query(Issue).options(
        joinedload(Issue.severity_assessments),
        joinedload(Issue.images),
        joinedload(Issue.reports)
    ).filter(
        (Issue.ai_confidence < 0.70) | (Issue.severity == SeverityLevel.CRITICAL) | (Issue.is_escalated == True)
    ).order_by(Issue.priority_score.desc()).all()

    results = []
    for iss in issues:
        latest_assessment = iss.severity_assessments[-1] if iss.severity_assessments else None
        results.append({
            "issue_id": iss.id,
            "display_id": iss.display_id,
            "title": iss.title,
            "category": getattr(iss.issue_type, 'value', str(iss.issue_type)),
            "address": iss.address,
            "current_severity": iss.severity_level,
            "current_severity_score": iss.severity_score or 50.0,
            "priority_score": iss.priority_score or 50.0,
            "total_reports": iss.total_reports or 1,
            "unique_citizens": iss.unique_citizens or 1,
            "ai_confidence": latest_assessment.confidence if latest_assessment else iss.ai_confidence,
            "risk_factors": json.loads(latest_assessment.risk_factors) if latest_assessment and latest_assessment.risk_factors else [],
            "ai_explanation": latest_assessment.explanation if latest_assessment else iss.priority_explanation,
            "image_url": iss.images[0].original_image_path if iss.images else None,
            "reports_count": len(iss.reports)
        })

    return {
        "review_count": len(results),
        "issues": results
    }


@router.post("/severity-review/{issue_id}/approve")
def approve_severity(
    issue_id: int,
    notes: Optional[str] = Query(None),
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role(UserRole.ADMIN))
):
    """Administrator approves AI severity assessment."""
    issue = db.query(Issue).filter(Issue.id == issue_id).first()
    if not issue:
        raise HTTPException(404, "Issue not found")

    db.add(AdminReview(
        issue_id=issue.id,
        admin_id=current_user.id,
        review_type="SEVERITY_REVIEW",
        decision="APPROVED_SEVERITY",
        notes=notes or "Administrator confirmed and approved AI severity assessment."
    ))
    db.commit()
    return {"status": "APPROVED", "issue_id": issue.id, "severity_level": issue.severity_level}


@router.post("/severity-review/{issue_id}/override")
def override_severity_and_priority(
    issue_id: int,
    payload: OverrideSeverityRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role(UserRole.ADMIN))
):
    """
    Administrator overrides severity and/or priority score with justification.
    Records full before/after audit log and preserves previous assessments in history.
    """
    issue = db.query(Issue).filter(Issue.id == issue_id).first()
    if not issue:
        raise HTTPException(404, "Issue not found")

    old_sev_score = issue.severity_score or 50.0
    old_sev_level = issue.severity_level or "MEDIUM"
    old_pri_score = issue.priority_score or 50.0

    issue.severity_score = payload.severity_score
    issue.severity_level = payload.severity_level
    issue.severity = getattr(SeverityLevel, payload.severity_level, issue.severity)

    # Recalculate priority if not manually provided
    if payload.priority_score is not None:
        new_pri_score = payload.priority_score
        p_level = "CRITICAL" if new_pri_score >= 75 else ("HIGH" if new_pri_score >= 50 else ("MEDIUM" if new_pri_score >= 25 else "LOW"))
        issue.priority_score = new_pri_score
        issue.priority_level = p_level
        issue.priority_override_reason = f"Admin override by {current_user.full_name}: {payload.reason}"
    else:
        new_pri_score, p_level, p_breakdown, p_expl = calculate_dynamic_priority(
            severity_score=payload.severity_score,
            category=getattr(issue.issue_type, 'value', str(issue.issue_type)),
            unique_citizens=issue.unique_citizens or 1,
            first_reported_at=issue.first_reported_at or issue.created_at,
            is_escalated=issue.is_escalated
        )
        issue.priority_score = new_pri_score
        issue.priority_level = p_level
        issue.priority_breakdown = json.dumps(p_breakdown)
        issue.priority_explanation = p_expl

    # Save new assessment record
    db.add(SeverityAssessment(
        issue_id=issue.id,
        severity_score=payload.severity_score,
        severity_level=payload.severity_level,
        confidence=1.0,
        risk_factors=json.dumps(["admin_manual_override"]),
        explanation=f"Administrator override: {payload.reason}",
        model_name="admin_manual_override",
        created_at=datetime.utcnow()
    ))

    # Save Admin Review Audit
    db.add(AdminReview(
        issue_id=issue.id,
        admin_id=current_user.id,
        review_type="SEVERITY_REVIEW",
        decision="MODIFIED",
        notes=payload.reason,
        previous_values=json.dumps({"severity_score": old_sev_score, "severity_level": old_sev_level, "priority_score": old_pri_score}),
        new_values=json.dumps({"severity_score": payload.severity_score, "severity_level": payload.severity_level, "priority_score": issue.priority_score})
    ))

    # Activity Log
    db.add(IssueActivityLog(
        issue_id=issue.id,
        actor_id=current_user.id,
        actor_name=current_user.full_name,
        actor_role="ADMIN",
        action="ADMIN_OVERRIDE",
        before_state=json.dumps({"severity_score": old_sev_score, "priority_score": old_pri_score}),
        after_state=json.dumps({"severity_score": payload.severity_score, "priority_score": issue.priority_score}),
        notes=f"Administrator manual override: {payload.reason}"
    ))

    db.commit()
    return {
        "status": "MODIFIED",
        "issue_id": issue.id,
        "display_id": issue.display_id,
        "severity_score": issue.severity_score,
        "severity_level": issue.severity_level,
        "priority_score": issue.priority_score,
        "priority_level": issue.priority_level
    }


# -------------------------------------------------------------------
# 3. RECONCILIATION ENDPOINT
# -------------------------------------------------------------------
@router.post("/reconcile")
def run_reconciliation(
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role(UserRole.ADMIN))
):
    """
    Performs comprehensive database-wide count verification and fixes any discrepancies.
    Guarantees:
      total_reports = COUNT(accepted reports WHERE issue_id = current_issue AND counted = true)
      unique_citizens = COUNT(DISTINCT reporter_id WHERE issue_id = current_issue AND counted = true)
    """
    audit = reconcile_all_issues(db)
    return audit


# -------------------------------------------------------------------
# 4. CONFIGURATION MANAGEMENT ENDPOINTS
# -------------------------------------------------------------------
@router.get("/config/dedup")
def get_dedup_settings(
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role(UserRole.ADMIN))
):
    cfg = db.query(DedupConfig).first()
    if not cfg:
        cfg = DedupConfig()
        db.add(cfg)
        db.commit()
        db.refresh(cfg)
    return {
        "auto_link_threshold": cfg.auto_link_threshold,
        "manual_review_threshold": cfg.manual_review_threshold,
        "category_radii": json.loads(cfg.category_radii_json) if cfg.category_radii_json else {},
        "weights": json.loads(cfg.weights_json) if cfg.weights_json else {},
        "ai_enabled": cfg.ai_enabled,
        "reopening_window_hours": cfg.reopening_window_hours,
        "max_candidates": cfg.max_candidates,
        "updated_at": cfg.updated_at.isoformat() if cfg.updated_at else None
    }


@router.put("/config/dedup")
def update_dedup_settings(
    payload: DedupConfigUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role(UserRole.ADMIN))
):
    cfg = db.query(DedupConfig).first()
    if not cfg:
        cfg = DedupConfig()
        db.add(cfg)

    if payload.auto_link_threshold is not None:
        cfg.auto_link_threshold = payload.auto_link_threshold
    if payload.manual_review_threshold is not None:
        cfg.manual_review_threshold = payload.manual_review_threshold
    if payload.category_radii is not None:
        cfg.category_radii_json = json.dumps(payload.category_radii)
    if payload.weights is not None:
        cfg.weights_json = json.dumps(payload.weights)
    if payload.ai_enabled is not None:
        cfg.ai_enabled = payload.ai_enabled
    if payload.reopening_window_hours is not None:
        cfg.reopening_window_hours = payload.reopening_window_hours
    if payload.max_candidates is not None:
        cfg.max_candidates = payload.max_candidates

    cfg.updated_at = datetime.utcnow()
    db.commit()
    return {"status": "UPDATED", "message": "Duplicate detection settings updated successfully."}


@router.get("/config/severity")
def get_severity_settings(
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role(UserRole.ADMIN))
):
    cfg = db.query(SeverityConfig).first()
    if not cfg:
        cfg = SeverityConfig()
        db.add(cfg)
        db.commit()
        db.refresh(cfg)
    return {
        "low_max": cfg.low_max,
        "medium_max": cfg.medium_max,
        "high_max": cfg.high_max,
        "critical_max": cfg.critical_max,
        "confidence_threshold": cfg.confidence_threshold,
        "auto_update_threshold": cfg.auto_update_threshold,
        "category_weights": json.loads(cfg.category_weights_json) if cfg.category_weights_json else {},
        "updated_at": cfg.updated_at.isoformat() if cfg.updated_at else None
    }


@router.put("/config/severity")
def update_severity_settings(
    payload: SeverityConfigUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role(UserRole.ADMIN))
):
    cfg = db.query(SeverityConfig).first()
    if not cfg:
        cfg = SeverityConfig()
        db.add(cfg)

    if payload.low_max is not None:
        cfg.low_max = payload.low_max
    if payload.medium_max is not None:
        cfg.medium_max = payload.medium_max
    if payload.high_max is not None:
        cfg.high_max = payload.high_max
    if payload.critical_max is not None:
        cfg.critical_max = payload.critical_max
    if payload.confidence_threshold is not None:
        cfg.confidence_threshold = payload.confidence_threshold
    if payload.auto_update_threshold is not None:
        cfg.auto_update_threshold = payload.auto_update_threshold

    cfg.updated_at = datetime.utcnow()
    db.commit()
    return {"status": "UPDATED", "message": "Severity evaluation settings updated successfully."}


@router.get("/config/priority")
def get_priority_settings(
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role(UserRole.ADMIN))
):
    cfg = db.query(PriorityConfig).first()
    if not cfg:
        cfg = PriorityConfig()
        db.add(cfg)
        db.commit()
        db.refresh(cfg)
    return {
        "weight_severity": cfg.weight_severity,
        "weight_safety_risk": cfg.weight_safety_risk,
        "weight_affected_population": cfg.weight_affected_population,
        "weight_duration": cfg.weight_duration,
        "weight_unique_citizens": cfg.weight_unique_citizens,
        "weight_escalation_trend": cfg.weight_escalation_trend,
        "normalization_rules": json.loads(cfg.normalization_rules_json) if cfg.normalization_rules_json else {},
        "updated_at": cfg.updated_at.isoformat() if cfg.updated_at else None
    }


@router.put("/config/priority")
def update_priority_settings(
    payload: PriorityConfigUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role(UserRole.ADMIN))
):
    cfg = db.query(PriorityConfig).first()
    if not cfg:
        cfg = PriorityConfig()
        db.add(cfg)

    if payload.weight_severity is not None:
        cfg.weight_severity = payload.weight_severity
    if payload.weight_safety_risk is not None:
        cfg.weight_safety_risk = payload.weight_safety_risk
    if payload.weight_affected_population is not None:
        cfg.weight_affected_population = payload.weight_affected_population
    if payload.weight_duration is not None:
        cfg.weight_duration = payload.weight_duration
    if payload.weight_unique_citizens is not None:
        cfg.weight_unique_citizens = payload.weight_unique_citizens
    if payload.weight_escalation_trend is not None:
        cfg.weight_escalation_trend = payload.weight_escalation_trend

    cfg.updated_at = datetime.utcnow()
    db.commit()
    return {"status": "UPDATED", "message": "Priority calculation weights updated successfully."}


# -------------------------------------------------------------------
# 5. INTELLIGENCE ANALYTICS ENDPOINT
# -------------------------------------------------------------------
@router.get("/intelligence/analytics")
def get_intelligence_analytics(
    db: Session = Depends(get_db),
    current_user: User = Depends(require_role(UserRole.ADMIN))
):
    """
    Returns visual intelligence metrics according to Part 12:
    - Total unique civic issues
    - Total citizen reports
    - Duplicate reports automatically linked
    - Duplicate reports awaiting review
    - Severity and priority distribution
    - Average reports per issue
    - AI vs deterministic heuristic processing
    """
    total_issues = db.query(func.count(Issue.id)).scalar() or 0
    total_reports = db.query(func.count(Report.id)).scalar() or 0
    auto_linked = db.query(func.count(Report.id)).filter(Report.link_method == "auto_ai").scalar() or 0
    pending_review = db.query(func.count(Report.id)).filter(Report.status == "pending_review").scalar() or 0
    direct_created = db.query(func.count(Report.id)).filter(Report.link_method == "direct_creation").scalar() or 0

    # Severity distribution
    sev_counts = {
        "LOW": db.query(func.count(Issue.id)).filter(Issue.severity_level == "LOW").scalar() or 0,
        "MEDIUM": db.query(func.count(Issue.id)).filter(Issue.severity_level == "MEDIUM").scalar() or 0,
        "HIGH": db.query(func.count(Issue.id)).filter(Issue.severity_level == "HIGH").scalar() or 0,
        "CRITICAL": db.query(func.count(Issue.id)).filter(Issue.severity_level == "CRITICAL").scalar() or 0,
    }

    # Priority distribution
    pri_counts = {
        "LOW": db.query(func.count(Issue.id)).filter(Issue.priority_level == "LOW").scalar() or 0,
        "MEDIUM": db.query(func.count(Issue.id)).filter(Issue.priority_level == "MEDIUM").scalar() or 0,
        "HIGH": db.query(func.count(Issue.id)).filter(Issue.priority_level == "HIGH").scalar() or 0,
        "CRITICAL": db.query(func.count(Issue.id)).filter(Issue.priority_level == "CRITICAL").scalar() or 0,
    }

    avg_reports = round(float(total_reports) / max(1, total_issues), 2)
    resolved_issues = db.query(func.count(Issue.id)).filter(Issue.status.in_([IssueStatus.RESOLVED, IssueStatus.CLOSED])).scalar() or 0

    # AI vs Heuristic breakdown from severity assessments
    total_assessments = db.query(func.count(SeverityAssessment.id)).scalar() or 0
    ai_assessments = db.query(func.count(SeverityAssessment.id)).filter(SeverityAssessment.model_name.like("%llm%")).scalar() or 0
    heuristic_assessments = total_assessments - ai_assessments

    return {
        "total_unique_issues": total_issues,
        "total_citizen_reports": total_reports,
        "duplicate_reports_auto_linked": auto_linked,
        "duplicate_reports_pending_review": pending_review,
        "new_issues_created": direct_created,
        "average_reports_per_issue": avg_reports,
        "resolved_issues": resolved_issues,
        "severity_distribution": sev_counts,
        "priority_distribution": pri_counts,
        "processing_breakdown": {
            "total_assessments": total_assessments,
            "external_ai_assessments": ai_assessments,
            "deterministic_heuristic_assessments": heuristic_assessments
        }
    }
