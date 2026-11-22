import json
import uuid
import logging
from datetime import datetime, timedelta
from typing import Dict, Any, Optional, Tuple
from sqlalchemy.orm import Session
from fastapi import HTTPException

from app.models.user import User
from app.models.issue import Issue, IssueStatus, IssueType, SeverityLevel
from app.models.image import IssueImage
from app.models.history import IssueStatusHistory
from app.models.intelligence import (
    Report, ReportMedia, ReportMatch, SeverityAssessment, IssueActivityLog
)
from app.services.image_similarity_service import calculate_sha256, calculate_dhash
from app.services.dedup_engine import (
    get_dedup_config, retrieve_candidate_issues, evaluate_duplicate_matches
)
from app.services.ai_intelligence_service import assess_severity_with_ai
from app.services.dynamic_priority_service import calculate_dynamic_priority
from app.services.counter_management_service import (
    recompute_and_update_issue_counters, check_is_repeat_reporter
)
from app.services.routing_service import route_issue_to_department
from app.services.priority_service import get_sla_hours_from_priority

logger = logging.getLogger("nagarsetu.pipeline")


def execute_submission_pipeline(
    db: Session,
    current_user: User,
    submission_id: str,
    selected_category: str,
    description: str,
    latitude: float,
    longitude: float,
    address: Optional[str] = None,
    image_url: Optional[str] = None,
    image_path: Optional[str] = None,
    gps_accuracy: float = 10.0,
    urgency: str = "normal",
    title: Optional[str] = None,
    voice_transcript: Optional[str] = None,
    original_language: Optional[str] = "en",
    citizen_duplicate_choice: Optional[str] = None  # "same_problem" | "different_problem"
) -> Dict[str, Any]:
    """
    Executes the comprehensive 10-step NagarSetu report submission workflow.
    Guarantees idempotency, atomic counter updates, evidence-based severity assessment,
    dynamic priority calculation, and complete activity logging.
    """
    # -------------------------------------------------------------------------
    # STEP 1: Validate Input
    # -------------------------------------------------------------------------
    if not selected_category:
        raise HTTPException(400, "Civic problem category is required.")
    if not (-90.0 <= latitude <= 90.0) or not (-180.0 <= longitude <= 180.0):
        raise HTTPException(400, "Invalid GPS latitude/longitude coordinates.")
    if not submission_id:
        submission_id = str(uuid.uuid4())

    # -------------------------------------------------------------------------
    # STEP 2: Idempotency Check
    # -------------------------------------------------------------------------
    existing_rep = db.query(Report).filter(Report.submission_id == submission_id).first()
    if existing_rep:
        # Return exact original response without incrementing counters or creating duplicates
        parent_issue = db.query(Issue).filter(Issue.id == existing_rep.issue_id).first() if existing_rep.issue_id else None
        return _build_response_payload(
            report=existing_rep,
            issue=parent_issue,
            decision="IDEMPOTENT_RETRY",
            message=f"Duplicate submission detected. Original report {existing_rep.report_tracking_id} retrieved successfully."
        )

    # -------------------------------------------------------------------------
    # STEP 3: Image Processing (SHA-256 and pHash)
    # -------------------------------------------------------------------------
    img_sha = None
    img_phash = None
    if image_path:
        img_sha = calculate_sha256(image_path)
        img_phash = calculate_dhash(image_path)

    report_tracking_id = f"REP-{datetime.utcnow().year}-{uuid.uuid4().hex[:8].upper()}"

    # -------------------------------------------------------------------------
    # STEP 4: Candidate Retrieval
    # -------------------------------------------------------------------------
    config = get_dedup_config(db)
    candidates = retrieve_candidate_issues(
        db=db,
        latitude=latitude,
        longitude=longitude,
        category=selected_category,
        gps_accuracy=gps_accuracy,
        config=config
    )

    # -------------------------------------------------------------------------
    # STEP 5: Duplicate Detection & Similarity Scoring
    # -------------------------------------------------------------------------
    new_report_data = {
        "selected_category": selected_category,
        "description": description or title or "Reported defect",
        "latitude": latitude,
        "longitude": longitude,
        "address": address or "Reported location",
        "image_path": image_path,
        "image_hash": img_sha,
        "perceptual_hash": img_phash,
        "reporter_id": current_user.id
    }
    
    evaluated_matches = evaluate_duplicate_matches(
        db=db,
        new_report_data=new_report_data,
        candidate_issues=candidates,
        config=config
    )

    # -------------------------------------------------------------------------
    # STEP 6: Duplicate Decision
    # -------------------------------------------------------------------------
    top_match = evaluated_matches[0] if evaluated_matches else None
    decision = top_match["decision"] if top_match else "LOW"

    # Non-binding citizen choice consideration: if citizen explicitly confirmed same problem,
    # and match score is >= 0.45, elevate to HIGH or MEDIUM
    if citizen_duplicate_choice == "same_problem" and top_match:
        if top_match["final_score"] >= 0.50:
            decision = "HIGH"
    elif citizen_duplicate_choice == "different_problem" and top_match:
        # Citizen says different problem: require higher confidence before auto-linking
        if top_match["final_score"] < 0.90:
            decision = "MEDIUM"

    target_issue = None
    suggested_issue = None
    link_method = "direct_creation"
    report_status = "accepted"
    counted = False
    repeat_reporter = False

    # -------------------------------------------------------------------------
    # STEP 7: Severity Assessment (Pre-transaction AI evaluation)
    # -------------------------------------------------------------------------
    if decision == "HIGH" and top_match:
        # Matching existing issue with high confidence
        target_issue = db.query(Issue).filter(Issue.id == top_match["issue_id"]).first()
        link_method = "auto_ai"
        report_status = "accepted"
        counted = True
        repeat_reporter = check_is_repeat_reporter(db, target_issue.id, current_user.id)

        # Evidence-based severity reassessment
        sev_result = assess_severity_with_ai(
            report_data=new_report_data,
            existing_issue={
                "id": target_issue.id,
                "title": target_issue.title,
                "category": selected_category,
                "description": target_issue.description or ""
            },
            current_severity_score=target_issue.severity_score or 50.0
        )
    elif decision == "MEDIUM" and top_match:
        # Medium confidence duplicate candidate: send for admin review
        suggested_issue = db.query(Issue).filter(Issue.id == top_match["issue_id"]).first()
        link_method = "pending_admin_review"
        report_status = "pending_review"
        counted = False  # DO NOT count until approved!

        sev_result = assess_severity_with_ai(report_data=new_report_data)
    else:
        # Low confidence or no matches: create new civic issue
        decision = "LOW"
        link_method = "direct_creation"
        report_status = "accepted"
        counted = True

        sev_result = assess_severity_with_ai(report_data=new_report_data)

    # -------------------------------------------------------------------------
    # STEP 8 & 9: Atomic Database Updates & Priority Calculation
    # -------------------------------------------------------------------------
    # Create the Report Record
    report = Report(
        report_tracking_id=report_tracking_id,
        issue_id=target_issue.id if target_issue else None,
        suggested_issue_id=suggested_issue.id if suggested_issue else None,
        submission_id=submission_id,
        reporter_id=current_user.id,
        reporter_name=current_user.full_name or "Citizen Reporter",
        description=description,
        selected_category=selected_category,
        urgency=urgency,
        latitude=latitude,
        longitude=longitude,
        gps_accuracy=gps_accuracy,
        location_source="gps",
        address=address,
        status=report_status,
        counted=counted,
        link_method=link_method,
        repeat_reporter=repeat_reporter,
        created_at=datetime.utcnow()
    )
    db.add(report)
    db.flush()

    # Save Media Evidence
    if image_url or image_path:
        db.add(ReportMedia(
            report_id=report.id,
            image_url=image_url or f"/uploads/original/{uuid.uuid4().hex}.jpg",
            image_hash=img_sha,
            perceptual_hash=img_phash,
            media_type="image/jpeg",
            uploaded_at=datetime.utcnow()
        ))

    # Save Report Matches for trace/audit
    if top_match:
        db.add(ReportMatch(
            report_id=report.id,
            issue_id=top_match["issue_id"],
            geo_similarity=top_match["geo_similarity"],
            text_similarity=top_match["text_similarity"],
            visual_similarity=top_match["visual_similarity"],
            context_similarity=top_match["context_similarity"],
            final_score=top_match["final_score"],
            confidence=top_match["ai_confidence"],
            ai_reasoning=top_match["ai_reasoning"],
            model_name=top_match["ai_model"],
            raw_ai_response=top_match["raw_ai_response"],
            decision=top_match["decision"],
            created_at=datetime.utcnow()
        ))

    # Branch A: Linked to Existing Issue (HIGH Confidence)
    if decision == "HIGH" and target_issue:
        # Atomic counter recomputation
        counters = recompute_and_update_issue_counters(db, target_issue.id)

        # Apply Severity Assessment if supported
        old_sev_score = target_issue.severity_score or 50.0
        new_sev_score = sev_result["severity_score"]
        sev_changed = abs(new_sev_score - old_sev_score) >= 1.0

        target_issue.severity_score = new_sev_score
        target_issue.severity_level = sev_result["severity_level"]
        target_issue.severity = getattr(SeverityLevel, sev_result["severity_level"], target_issue.severity)

        # Save Severity Assessment History
        db.add(SeverityAssessment(
            issue_id=target_issue.id,
            report_id=report.id,
            severity_score=new_sev_score,
            severity_level=sev_result["severity_level"],
            confidence=sev_result["confidence"],
            risk_factors=json.dumps(sev_result["risk_factors"]),
            explanation=sev_result["explanation"],
            supporting_evidence=json.dumps(sev_result["supporting_evidence"]),
            raw_ai_response=sev_result.get("raw_ai_response"),
            model_name=sev_result.get("model_name", "nagarsetu-severity-v1"),
            is_escalation=sev_result["is_escalation"],
            is_deescalation=sev_result["is_deescalation"],
            created_at=datetime.utcnow()
        ))

        # Recalculate Dynamic Priority
        p_score, p_level, p_breakdown, p_expl = calculate_dynamic_priority(
            severity_score=new_sev_score,
            category=selected_category,
            unique_citizens=counters["unique_citizens"],
            first_reported_at=target_issue.first_reported_at or target_issue.created_at,
            is_escalated=sev_result["is_escalation"] or target_issue.is_escalated,
            is_arterial_or_market=bool(target_issue.address and any(w in target_issue.address.lower() for w in ["market", "ring road", "chowk", "highway"]))
        )
        old_priority = target_issue.priority_score or 50.0
        target_issue.priority_score = p_score
        target_issue.priority_level = p_level
        target_issue.priority_breakdown = json.dumps(p_breakdown)
        target_issue.priority_explanation = p_expl
        target_issue.last_reported_at = datetime.utcnow()

        # Update SLA deadline if priority escalated
        sla_hours = get_sla_hours_from_priority(p_score)
        target_issue.sla_hours = sla_hours
        if target_issue.first_reported_at:
            target_issue.deadline = target_issue.first_reported_at + timedelta(hours=sla_hours)

        # Log Activity History
        db.add(IssueActivityLog(
            issue_id=target_issue.id,
            report_id=report.id,
            actor_id=current_user.id,
            actor_name=current_user.full_name,
            actor_role=getattr(current_user.role, 'value', str(current_user.role)),
            action="REPORT_LINKED",
            before_state=json.dumps({
                "total_reports": counters["total_reports"] - 1,
                "severity_score": old_sev_score,
                "priority_score": old_priority
            }),
            after_state=json.dumps({
                "total_reports": counters["total_reports"],
                "unique_citizens": counters["unique_citizens"],
                "severity_score": new_sev_score,
                "priority_score": p_score,
                "link_method": "auto_ai"
            }),
            notes=f"Report {report.report_tracking_id} automatically linked to existing issue {target_issue.display_id} by AI deduplication engine.",
            created_at=datetime.utcnow()
        ))

        # Also add lifecycle history note for backward compatibility
        db.add(IssueStatusHistory(
            issue_id=target_issue.id,
            previous_status=target_issue.status,
            new_status=target_issue.status,
            changed_by_user_id=current_user.id,
            notes=f"New citizen report {report_tracking_id} linked (Total: {counters['total_reports']}, Unique: {counters['unique_citizens']}). Priority updated to {p_score}/100.",
            progress_percentage=target_issue.progress_percentage
        ))

        db.commit()
        db.refresh(target_issue)
        db.refresh(report)

        msg = (
            f"Your report has been successfully added to existing civic issue {target_issue.display_id}. "
            f"This problem has now received {counters['total_reports']} reports from {counters['unique_citizens']} unique citizens. "
            f"{'AI assessment detected an increase in defect conditions. Severity has been updated to ' + target_issue.severity_level + ' and priority recalculated.' if sev_changed else 'Severity maintained at ' + str(target_issue.severity_level) + ' and priority recalculated to ' + str(p_score) + '/100.'}"
        )
        return _build_response_payload(report, target_issue, decision, msg)

    # Branch B: Medium Confidence (Pending Admin Review)
    elif decision == "MEDIUM" and suggested_issue:
        db.add(IssueActivityLog(
            issue_id=suggested_issue.id,
            report_id=report.id,
            actor_id=current_user.id,
            actor_name=current_user.full_name,
            actor_role=getattr(current_user.role, 'value', str(current_user.role)),
            action="DUPLICATE_DETECTED",
            before_state=json.dumps({"status": "pending_review"}),
            after_state=json.dumps({
                "suggested_issue_id": suggested_issue.id,
                "suggested_display_id": suggested_issue.display_id,
                "match_score": top_match["final_score"]
            }),
            notes=f"Possible duplicate of {suggested_issue.display_id} routed to administrator Duplicate Review queue.",
            created_at=datetime.utcnow()
        ))
        db.commit()
        db.refresh(report)

        msg = (
            f"Your report has been submitted for review. It may be related to existing issue {suggested_issue.display_id}. "
            f"Municipal administrators will inspect the evidence and consolidate records."
        )
        return _build_response_payload(report, suggested_issue, decision, msg)

    # Branch C: New Civic Issue Creation (LOW Confidence)
    else:
        # Route to Department
        dept = route_issue_to_department(db, selected_category)

        # Calculate Initial Priority Score
        p_score, p_level, p_breakdown, p_expl = calculate_dynamic_priority(
            severity_score=sev_result["severity_score"],
            category=selected_category,
            unique_citizens=1,
            first_reported_at=datetime.utcnow(),
            is_escalated=False,
            is_arterial_or_market=bool(address and any(w in address.lower() for w in ["market", "ring road", "chowk", "highway"]))
        )
        sla_hours = get_sla_hours_from_priority(p_score)
        deadline = datetime.utcnow() + timedelta(hours=sla_hours)

        # Generate Display ID
        last_issue = db.query(Issue).order_by(Issue.id.desc()).first()
        next_num = (last_issue.id + 101) if last_issue else 101
        display_id = f"NG-{next_num}"

        issue_title = title or f"{selected_category} at {address.split(',')[0] if address else 'Reported Area'}"

        new_issue = Issue(
            display_id=display_id,
            title=issue_title,
            summary=description[:200] if description else issue_title,
            description=description,
            issue_type=getattr(IssueType, selected_category.upper().replace(' ', '_'), selected_category),
            latitude=latitude,
            longitude=longitude,
            address=address,
            area=address.split(",")[-1].strip() if address and "," in address else None,
            ai_confidence=sev_result.get("confidence", 0.88),
            severity=getattr(SeverityLevel, sev_result["severity_level"], SeverityLevel.MEDIUM),
            severity_score=sev_result["severity_score"],
            severity_level=sev_result["severity_level"],
            priority_score=p_score,
            priority_level=p_level,
            priority_breakdown=json.dumps(p_breakdown),
            priority_explanation=p_expl,
            total_reports=1,
            unique_citizens=1,
            first_reported_at=datetime.utcnow(),
            last_reported_at=datetime.utcnow(),
            status=IssueStatus.AI_ANALYZED,
            progress_percentage=0,
            latest_update="New civic issue established. Initial AI severity & priority calculated.",
            reporter_id=current_user.id,
            department_id=dept.id if dept else None,
            assigned_department=dept.name if dept else None,
            sla_hours=sla_hours,
            sla_deadline=deadline,
            deadline=deadline,
            support_count=1,
            original_language=original_language or "en",
            voice_transcript=voice_transcript,
            created_at=datetime.utcnow()
        )
        db.add(new_issue)
        db.flush()

        # Link report to newly created issue
        report.issue_id = new_issue.id
        report.counted = True
        report.link_method = "direct_creation"

        # Save Image to IssueImage for legacy compatibility
        if image_url:
            db.add(IssueImage(
                issue_id=new_issue.id,
                original_image_path=image_url
            ))

        # Save Initial Severity Assessment
        db.add(SeverityAssessment(
            issue_id=new_issue.id,
            report_id=report.id,
            severity_score=sev_result["severity_score"],
            severity_level=sev_result["severity_level"],
            confidence=sev_result["confidence"],
            risk_factors=json.dumps(sev_result["risk_factors"]),
            explanation=sev_result["explanation"],
            supporting_evidence=json.dumps(sev_result["supporting_evidence"]),
            raw_ai_response=sev_result.get("raw_ai_response"),
            model_name=sev_result.get("model_name", "nagarsetu-severity-v1"),
            created_at=datetime.utcnow()
        ))

        # Log Issue Creation
        db.add(IssueActivityLog(
            issue_id=new_issue.id,
            report_id=report.id,
            actor_id=current_user.id,
            actor_name=current_user.full_name,
            actor_role=getattr(current_user.role, 'value', str(current_user.role)),
            action="ISSUE_CREATED",
            before_state=None,
            after_state=json.dumps({
                "display_id": display_id,
                "severity_score": sev_result["severity_score"],
                "priority_score": p_score,
                "total_reports": 1
            }),
            notes=f"New civic issue {display_id} created from initial citizen report {report.report_tracking_id}.",
            created_at=datetime.utcnow()
        ))

        # Lifecycle Status History
        db.add(IssueStatusHistory(
            issue_id=new_issue.id,
            previous_status=None,
            new_status=IssueStatus.SUBMITTED,
            changed_by_user_id=current_user.id,
            notes="Citizen complaint lodged on NagarSetu platform.",
            progress_percentage=0
        ))
        db.add(IssueStatusHistory(
            issue_id=new_issue.id,
            previous_status=IssueStatus.SUBMITTED,
            new_status=IssueStatus.AI_ANALYZED,
            changed_by_user_id=current_user.id,
            notes=f"Initial AI severity assigned: {sev_result['severity_level']} ({sev_result['severity_score']}/100). Priority: {p_score}/100.",
            progress_percentage=0
        ))

        db.commit()
        db.refresh(new_issue)
        db.refresh(report)

        msg = (
            f"Your report has been successfully registered as a new civic issue ({new_issue.display_id}). "
            f"Initial AI severity evaluated as {new_issue.severity_level} ({new_issue.severity_score}/100) and priority as {new_issue.priority_level} ({new_issue.priority_score}/100)."
        )
        return _build_response_payload(report, new_issue, decision, msg)


def _build_response_payload(
    report: Report,
    issue: Optional[Issue],
    decision: str,
    message: str
) -> Dict[str, Any]:
    """Formats standardized client response according to Part 10 Step 10."""
    return {
        "report_tracking_id": report.report_tracking_id,
        "submission_id": report.submission_id,
        "report_id": report.id,
        "report_status": report.status,
        "duplicate_decision": decision,
        "link_method": report.link_method,
        "repeat_reporter": report.repeat_reporter,
        "parent_issue": {
            "id": issue.id if issue else None,
            "display_id": issue.display_id if issue else None,
            "title": issue.title if issue else None,
            "category": getattr(issue.issue_type, 'value', str(issue.issue_type)) if issue else report.selected_category,
            "total_reports": issue.total_reports if issue else 0,
            "unique_citizens": issue.unique_citizens if issue else 0,
            "severity_level": issue.severity_level if issue else "MEDIUM",
            "severity_score": issue.severity_score if issue else 50.0,
            "priority_level": issue.priority_level if issue else "MEDIUM",
            "priority_score": issue.priority_score if issue else 50.0,
            "status": getattr(issue.status, 'value', str(issue.status)) if issue else "SUBMITTED",
            "assigned_department": issue.assigned_department if issue else None,
            "last_reported_at": issue.last_reported_at.isoformat() if issue and issue.last_reported_at else None
        } if issue else None,
        "message": message
    }
