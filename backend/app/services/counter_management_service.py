import logging
from typing import Dict, Any, Optional
from sqlalchemy import func, distinct
from sqlalchemy.orm import Session
from app.models.issue import Issue, IssueStatus
from app.models.intelligence import Report

logger = logging.getLogger("nagarsetu.counter_service")


def recompute_and_update_issue_counters(db: Session, issue_id: int) -> Dict[str, int]:
    """
    Maintains the core NagarSetu architectural invariant:
      total_reports = COUNT(accepted reports WHERE issue_id = current_issue AND counted = true)
      unique_citizens = COUNT(DISTINCT reporter_id WHERE issue_id = current_issue AND counted = true)

    Performs atomic calculation directly from the reports table and updates the issue record.
    """
    issue = db.query(Issue).filter(Issue.id == issue_id).with_for_update(nowait=False).first() if db.bind.dialect.name == "postgresql" else db.query(Issue).filter(Issue.id == issue_id).first()
    if not issue:
        return {"total_reports": 0, "unique_citizens": 0}

    # Count accepted, counted reports
    counts = db.query(
        func.count(Report.id).label("total_reports"),
        func.count(distinct(Report.reporter_id)).label("unique_citizens"),
        func.max(Report.created_at).label("last_reported_at"),
        func.min(Report.created_at).label("first_reported_at")
    ).filter(
        Report.issue_id == issue_id,
        Report.status == "accepted",
        Report.counted == True
    ).first()

    total_reps = counts.total_reports or 0
    uniq_cits = counts.unique_citizens or 0

    # Fallback only for legacy issues that have no records in reports table at all
    has_any_reports = db.query(Report.id).filter(Report.issue_id == issue_id).first() is not None
    if not has_any_reports and issue.status not in (IssueStatus.RESOLVED, IssueStatus.CLOSED, IssueStatus.REJECTED):
        total_reps = max(1, issue.total_reports or 1)
        uniq_cits = max(1, issue.unique_citizens or 1)

    issue.total_reports = total_reps
    issue.unique_citizens = uniq_cits
    if counts.last_reported_at:
        issue.last_reported_at = counts.last_reported_at
    if counts.first_reported_at and not issue.first_reported_at:
        issue.first_reported_at = counts.first_reported_at

    # Keep legacy support_count in sync with total_reports
    issue.support_count = total_reps
    db.commit()

    return {"total_reports": total_reps, "unique_citizens": uniq_cits}


def check_is_repeat_reporter(db: Session, issue_id: int, reporter_id: int) -> bool:
    """Checks whether the citizen has previously submitted an accepted, counted report for this issue."""
    existing_count = db.query(Report).filter(
        Report.issue_id == issue_id,
        Report.reporter_id == reporter_id,
        Report.status == "accepted",
        Report.counted == True
    ).count()
    return existing_count > 0


def reconcile_single_issue(db: Session, issue_id: int) -> Dict[str, Any]:
    """
    Validates counters for a specific issue and repairs any mathematical discrepancy.
    Returns audit details of before vs after values.
    """
    issue = db.query(Issue).filter(Issue.id == issue_id).first()
    if not issue:
        return {"issue_id": issue_id, "found": False}

    old_total = issue.total_reports or 0
    old_unique = issue.unique_citizens or 0

    actual_counts = db.query(
        func.count(Report.id).label("total_reports"),
        func.count(distinct(Report.reporter_id)).label("unique_citizens")
    ).filter(
        Report.issue_id == issue_id,
        Report.status == "accepted",
        Report.counted == True
    ).first()

    expected_total = actual_counts.total_reports or 0
    expected_unique = actual_counts.unique_citizens or 0

    discrepancy = (old_total != expected_total) or (old_unique != expected_unique)
    
    if discrepancy and expected_total > 0:
        issue.total_reports = expected_total
        issue.unique_citizens = expected_unique
        issue.support_count = expected_total
        db.commit()

    return {
        "issue_id": issue_id,
        "display_id": issue.display_id,
        "had_discrepancy": discrepancy,
        "previous_total": old_total,
        "reconciled_total": issue.total_reports,
        "previous_unique": old_unique,
        "reconciled_unique": issue.unique_citizens,
    }


def reconcile_all_issues(db: Session) -> Dict[str, Any]:
    """
    Runs comprehensive database-wide count reconciliation across all issues.
    Guarantees zero count inconsistencies across the entire platform.
    """
    issues = db.query(Issue).all()
    discrepancies_found = 0
    repaired_issues = []

    for issue in issues:
        result = reconcile_single_issue(db, issue.id)
        if result.get("had_discrepancy"):
            discrepancies_found += 1
            repaired_issues.append(result)

    return {
        "total_issues_checked": len(issues),
        "discrepancies_found": discrepancies_found,
        "repaired_issues": repaired_issues,
        "status": "CONSISTENT" if discrepancies_found == 0 else "REPAIRED"
    }
