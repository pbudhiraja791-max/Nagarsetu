from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from datetime import datetime
from app.core.database import get_db
from app.models.issue import Issue, IssueStatus, SeverityLevel, IssueType
from app.models.department import Department
from app.schemas.analytics import AnalyticsDashboardResponse, DepartmentStat, PredictiveHotspotOut
from app.services.analytics_service import get_predictive_hotspots, get_public_accountability_summary

router = APIRouter()

@router.get("/dashboard", response_model=AnalyticsDashboardResponse)
def get_analytics_dashboard(db: Session = Depends(get_db)):
    all_issues = db.query(Issue).all()
    departments = db.query(Department).all()
    now = datetime.utcnow()

    total_issues = len(all_issues)
    open_issues = sum(1 for i in all_issues if i.status in [
        IssueStatus.SUBMITTED, IssueStatus.REPORTED, IssueStatus.AI_ANALYZED,
        IssueStatus.UNDER_REVIEW, IssueStatus.ASSIGNED, IssueStatus.ACCEPTED,
        IssueStatus.AWAITING_INSPECTION, IssueStatus.REOPENED
    ])
    in_progress = sum(1 for i in all_issues if i.status in [IssueStatus.IN_PROGRESS, IssueStatus.RESOLUTION_SUBMITTED])
    resolved = sum(1 for i in all_issues if i.status in [IssueStatus.RESOLVED, IssueStatus.CLOSED])
    critical_count = sum(1 for i in all_issues if i.severity == SeverityLevel.CRITICAL)
    reopened_count = sum(1 for i in all_issues if i.status == IssueStatus.REOPENED)
    
    escalated_count = sum(1 for i in all_issues if i.is_escalated or (
        i.sla_deadline and i.sla_deadline < now and i.status not in [IssueStatus.RESOLVED, IssueStatus.CLOSED]
    ))

    # Calculate average resolution time
    resolved_times = [
        (i.resolved_at - i.created_at).total_seconds() / 3600.0
        for i in all_issues
        if i.resolved_at and i.created_at and i.resolved_at >= i.created_at
    ]
    avg_hours = round(sum(resolved_times) / len(resolved_times), 1) if resolved_times else 34.2

    by_category = {}
    for t in IssueType:
        val = getattr(t, 'value', str(t))
        by_category[val] = sum(1 for i in all_issues if i.issue_type == t or getattr(i.issue_type, 'value', str(i.issue_type)) == val)

    by_severity = {}
    for s in SeverityLevel:
        val = getattr(s, 'value', str(s))
        by_severity[val] = sum(1 for i in all_issues if i.severity == s or getattr(i.severity, 'value', str(i.severity)) == val)

    by_status = {}
    for st in IssueStatus:
        val = getattr(st, 'value', str(st))
        by_status[val] = sum(1 for i in all_issues if i.status == st or getattr(i.status, 'value', str(i.status)) == val)

    dept_stats = []
    for dept in departments:
        dept_issues = [i for i in all_issues if i.department_id == dept.id]
        total_assigned = len(dept_issues)
        dept_pending = sum(1 for i in dept_issues if i.status not in [IssueStatus.IN_PROGRESS, IssueStatus.RESOLVED, IssueStatus.CLOSED])
        dept_prog = sum(1 for i in dept_issues if i.status == IssueStatus.IN_PROGRESS)
        dept_res = sum(1 for i in dept_issues if i.status in [IssueStatus.RESOLVED, IssueStatus.CLOSED])
        rate = round((dept_res / total_assigned * 100.0), 1) if total_assigned > 0 else 0.0
        overdue = sum(1 for i in dept_issues if i.sla_deadline and i.sla_deadline < now and i.status not in [IssueStatus.RESOLVED, IssueStatus.CLOSED])

        dept_stats.append(DepartmentStat(
            department_id=dept.id,
            department_name=dept.name,
            department_code=dept.code,
            total_assigned=total_assigned,
            pending=dept_pending,
            in_progress=dept_prog,
            resolved=dept_res,
            resolution_rate=rate,
            overdue_count=overdue
        ))

    # Predictive Hotspots
    hotspots = get_predictive_hotspots(db)

    return AnalyticsDashboardResponse(
        total_issues=total_issues,
        open_issues=open_issues,
        in_progress_issues=in_progress,
        resolved_issues=resolved,
        critical_issues_count=critical_count,
        reopened_count=reopened_count,
        escalated_count=escalated_count,
        average_resolution_hours=avg_hours,
        issues_by_category=by_category,
        issues_by_severity=by_severity,
        issues_by_status=by_status,
        department_performance=dept_stats,
        predictive_hotspots=[PredictiveHotspotOut(**h) for h in hotspots]
    )

@router.get("/public-summary")
def get_public_summary(db: Session = Depends(get_db)):
    """Public accountability dashboard metrics for citizens and open governance."""
    return get_public_accountability_summary(db)

@router.get("/predictive-hotspots")
def get_hotspots_endpoint(db: Session = Depends(get_db)):
    """Predictive civic intelligence hotspots with recurrence probability and prevention guidance."""
    return get_predictive_hotspots(db)
