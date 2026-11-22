import json
import os
import uuid
from datetime import datetime, timedelta
from typing import Optional, List
from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File, Query
from sqlalchemy.orm import Session, joinedload

from app.core.database import get_db
from app.api.v1.endpoints.auth import get_current_user, require_role
from app.core.config import settings
from app.models.user import User, UserRole
from app.models.issue import (
    Issue, IssueStatus, IssueType, SeverityLevel, ComplaintSupport, InspectionRequest
)
from app.models.department import Department
from app.models.image import IssueImage
from app.models.history import IssueStatusHistory
from app.models.duplicate import DuplicateIssueRelation
from app.schemas.issue import (
    CreateIssueSchema, IssueDetailOut, DashboardStats, UpdateProgressSchema,
    AssignOfficerSchema, RejectIssueSchema, UpdateEstimateSchema, StatusUpdateSchema,
    ResolutionSubmitSchema, CitizenVerifySchema, PriorityOverrideSchema,
    DuplicateCheckRequest, VoiceReportRequest, IssueStatusHistoryOut
)
from app.schemas.intelligence import (
    SubmitReportRequest, DuplicatePreviewRequest, DuplicatePreviewResponse,
    DuplicatePreviewCandidate
)
from app.services.ai_service import (
    analyze_issue_image, analyze_text_description, compare_resolution_evidence
)
from app.services.duplicate_service import (
    find_intelligent_duplicates, support_existing_issue, calculate_haversine_distance
)
from app.services.routing_service import route_issue_to_department
from app.services.priority_service import get_sla_hours_from_priority

router = APIRouter()

def q_issue(db: Session, issue_id: int) -> Issue:
    issue = db.query(Issue).options(
        joinedload(Issue.images),
        joinedload(Issue.department),
        joinedload(Issue.assigned_officer),
        joinedload(Issue.reporter),
        joinedload(Issue.status_history).joinedload(IssueStatusHistory.changed_by),
        joinedload(Issue.duplicate_relations),
        joinedload(Issue.supports)
    ).filter(Issue.id == issue_id).first()
    if not issue:
        raise HTTPException(status_code=404, detail="Complaint not found")
    return issue

def assert_owner_or_authorized(issue: Issue, current: User):
    if current.role == UserRole.CITIZEN and issue.reporter_id != current.id:
        # Citizens can view public info, but full private edits are limited
        pass

def assert_department_access(issue: Issue, current: User):
    if current.role not in (UserRole.ADMIN, UserRole.OFFICER):
        raise HTTPException(status_code=403, detail="Department authorization required")
    if current.role == UserRole.OFFICER and current.department_id and issue.department_id != current.department_id:
        raise HTTPException(status_code=403, detail="Complaint is assigned outside your department")

def record_history(db: Session, issue: Issue, user: User, new_status: IssueStatus, notes: Optional[str] = None, progress: Optional[int] = None):
    old_status = issue.status
    issue.status = new_status
    if progress is not None:
        issue.progress_percentage = progress
    db.add(IssueStatusHistory(
        issue_id=issue.id,
        previous_status=old_status,
        new_status=new_status,
        changed_by_user_id=user.id,
        notes=notes,
        progress_percentage=progress if progress is not None else issue.progress_percentage
    ))


# -------------------------------------------------------------------
# 1. AI COMPUTER VISION INSPECTION ENDPOINT
# -------------------------------------------------------------------
@router.post('/analyze-image')
def analyze_image(
    file: UploadFile = File(...),
    current_user: User = Depends(get_current_user)
):
    ext = os.path.splitext(file.filename or '')[1].lower() or '.jpg'
    unique_name = f"{uuid.uuid4().hex}{ext}"
    saved_path = os.path.join(settings.ORIGINAL_IMG_DIR, unique_name)
    
    os.makedirs(settings.ORIGINAL_IMG_DIR, exist_ok=True)
    os.makedirs(settings.ANNOTATED_IMG_DIR, exist_ok=True)

    with open(saved_path, 'wb') as f:
        f.write(file.file.read())

    result = analyze_issue_image(saved_path)
    result['original_image_url'] = f'/uploads/original/{unique_name}'
    ann = result.get('annotated_image_filename')
    result['annotated_image_url'] = f'/uploads/annotated/{ann}' if ann else None
    return result


# -------------------------------------------------------------------
# 2. NLP VOICE & TEXT PARSING ENDPOINT
# -------------------------------------------------------------------
@router.post('/parse-nlp')
def parse_nlp_text(
    payload: VoiceReportRequest,
    current_user: User = Depends(get_current_user)
):
    """Parses complaint description or voice transcript in Hindi/English/Punjabi."""
    nlp_result = analyze_text_description(payload.transcript, payload.language)
    return nlp_result


# -------------------------------------------------------------------
# 3. INTELLIGENT DUPLICATE CHECK ENDPOINT
# -------------------------------------------------------------------
@router.post('/check-duplicates')
def check_duplicates(
    payload: DuplicateCheckRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Identifies nearby similar civic issues within 50 meters and 72 hours."""
    candidates = find_intelligent_duplicates(
        db=db,
        latitude=payload.latitude,
        longitude=payload.longitude,
        issue_type=payload.issue_type,
        title=payload.title,
        description=payload.description,
        radius_meters=payload.radius_meters or settings.DUPLICATE_RADIUS_METERS
    )
    return {
        "duplicate_count": len(candidates),
        "has_potential_duplicates": len(candidates) > 0,
        "radius_meters": payload.radius_meters or settings.DUPLICATE_RADIUS_METERS,
        "candidates": candidates
    }


# -------------------------------------------------------------------
# 3B. NON-BINDING DUPLICATE PREVIEW (Citizen Experience Part 13)
# -------------------------------------------------------------------
@router.post('/preview-duplicates', response_model=DuplicatePreviewResponse)
def preview_duplicates(
    payload: DuplicatePreviewRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Non-binding duplicate preview before citizen submits.
    Returns: 'Looks like this problem has already been reported by 12 people. Are you reporting the same issue?'
    """
    from app.services.dedup_engine import retrieve_candidate_issues, evaluate_duplicate_matches
    candidates = retrieve_candidate_issues(
        db=db,
        latitude=payload.latitude,
        longitude=payload.longitude,
        category=payload.category
    )
    if not candidates:
        return DuplicatePreviewResponse(
            has_possible_duplicates=False,
            candidate_count=0,
            candidates=[]
        )

    evaluated = evaluate_duplicate_matches(
        db=db,
        new_report_data={
            "selected_category": payload.category,
            "description": payload.description or "",
            "latitude": payload.latitude,
            "longitude": payload.longitude
        },
        candidate_issues=candidates
    )

    cand_list = []
    top_cand = None
    for idx, c in enumerate(evaluated):
        issue_obj = db.query(Issue).filter(Issue.id == c["issue_id"]).first()
        img = issue_obj.images[0].original_image_path if (issue_obj and issue_obj.images) else None
        item = DuplicatePreviewCandidate(
            issue_id=c["issue_id"],
            display_id=c.get("display_id") or f"NG-{c['issue_id']}",
            title=c["title"],
            category=c["category"],
            distance_meters=c["distance_meters"],
            address=issue_obj.address if issue_obj else None,
            total_reports=c["total_reports"],
            unique_citizens=c["unique_citizens"],
            status=c["status"],
            similarity_score=c["final_score"],
            image_url=img
        )
        if idx == 0:
            top_cand = item
        cand_list.append(item)

    msg = None
    if top_cand:
        msg = f"Looks like this problem has already been reported by {top_cand.total_reports} people. Are you reporting the same issue?"

    return DuplicatePreviewResponse(
        has_possible_duplicates=len(cand_list) > 0,
        candidate_count=len(cand_list),
        top_candidate=top_cand,
        candidates=cand_list,
        message=msg
    )


# -------------------------------------------------------------------
# 3C. MASTER AI-POWERED CIVIC REPORT SUBMISSION (Pipeline Part 10)
# -------------------------------------------------------------------
@router.post('/submit-report', status_code=status.HTTP_201_CREATED)
def submit_report(
    payload: SubmitReportRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Executes the 10-step server-side pipeline:
    Validates input -> Idempotency check -> Image hashing -> Candidate retrieval ->
    Duplicate detection -> Decision -> Severity reassessment -> Priority recalculation ->
    Atomic DB transaction & counters -> Rich citizen response.
    """
    from app.services.submission_pipeline import execute_submission_pipeline
    res = execute_submission_pipeline(
        db=db,
        current_user=current_user,
        submission_id=payload.submission_id or str(uuid.uuid4()),
        selected_category=payload.selected_category,
        description=payload.description,
        latitude=payload.latitude,
        longitude=payload.longitude,
        address=payload.address,
        image_url=payload.image_url,
        gps_accuracy=payload.gps_accuracy or 10.0,
        urgency=payload.urgency or "normal",
        title=payload.title,
        voice_transcript=payload.voice_transcript,
        original_language=payload.original_language or "en",
        citizen_duplicate_choice=payload.citizen_duplicate_choice
    )
    return res


# -------------------------------------------------------------------
# 4. COMPLAINT CREATION WITH SMART ROUTING & SLA (Legacy Compatibility)
# -------------------------------------------------------------------
@router.post('', response_model=IssueDetailOut, status_code=status.HTTP_201_CREATED)
def create_issue(
    payload: CreateIssueSchema,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role not in (UserRole.CITIZEN, UserRole.ADMIN):
        raise HTTPException(403, 'Only registered citizens and administrators can submit reports.')

    from app.services.submission_pipeline import execute_submission_pipeline
    pipeline_res = execute_submission_pipeline(
        db=db,
        current_user=current_user,
        submission_id=str(uuid.uuid4()),
        selected_category=payload.issue_type.value if hasattr(payload.issue_type, 'value') else str(payload.issue_type),
        description=payload.description or payload.title,
        latitude=payload.latitude,
        longitude=payload.longitude,
        address=payload.address,
        image_url=payload.original_image_url,
        urgency="normal",
        title=payload.title,
        voice_transcript=payload.voice_transcript,
        original_language=payload.original_language or "en"
    )

    parent_id = pipeline_res.get("parent_issue", {}).get("id")
    if not parent_id:
        iss = db.query(Issue).order_by(Issue.id.desc()).first()
        parent_id = iss.id if iss else 1
    return q_issue(db, parent_id)


# -------------------------------------------------------------------
# 5. COMMUNITY SUPPORT / UPVOTE ENDPOINT
# -------------------------------------------------------------------
@router.post('/{issue_id}/support', response_model=IssueDetailOut)
def support_issue(
    issue_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Allows a citizen to support an existing nearby complaint, boosting its urgency."""
    try:
        updated = support_existing_issue(db, issue_id, current_user.id)
        db.add(IssueStatusHistory(
            issue_id=issue_id,
            previous_status=updated.status,
            new_status=updated.status,
            changed_by_user_id=current_user.id,
            notes=f"Citizen {current_user.full_name} supported this report. Total endorsements: {updated.support_count}.",
            progress_percentage=updated.progress_percentage
        ))
        db.commit()
        return q_issue(db, issue_id)
    except Exception as e:
        raise HTTPException(400, str(e))


# -------------------------------------------------------------------
# 6. OFFICER RESOLUTION SUBMISSION WITH EVIDENCE
# -------------------------------------------------------------------
@router.post('/{issue_id}/submit-resolution', response_model=IssueDetailOut)
def submit_resolution(
    issue_id: int,
    payload: ResolutionSubmitSchema,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Officer uploads after-repair photographic evidence and notes.
    Triggers automated AI before/after evidence comparison.
    Transitions status to RESOLUTION_SUBMITTED for citizen verification.
    """
    issue = q_issue(db, issue_id)
    assert_department_access(issue, current_user)

    # Run AI Before vs After Evidence Comparison
    orig_path = ""
    if issue.images:
        orig_rel = issue.images[0].original_image_path.lstrip("/")
        orig_path = os.path.join(settings.BASE_DIR, orig_rel)

    res_rel = payload.resolution_image_url.lstrip("/")
    res_path = os.path.join(settings.BASE_DIR, res_rel)

    ai_comparison = compare_resolution_evidence(orig_path, res_path)

    issue.resolution_image_path = payload.resolution_image_url
    issue.resolution_notes = payload.notes
    issue.resolution_ai_comparison = json.dumps(ai_comparison)
    issue.resolution_submitted_at = datetime.utcnow()
    issue.progress_percentage = 95
    issue.latest_update = f"Repair completed by {current_user.full_name}. Awaiting citizen verification."

    record_history(
        db, issue, current_user, IssueStatus.RESOLUTION_SUBMITTED,
        f"Repair evidence submitted. AI verification confidence: {int(ai_comparison['repair_confidence'] * 100)}%.",
        95
    )

    db.commit()
    return q_issue(db, issue.id)


# -------------------------------------------------------------------
# 7. CITIZEN-VERIFIED RESOLUTION WORKFLOW
# -------------------------------------------------------------------
@router.post('/{issue_id}/verify-resolution', response_model=IssueDetailOut)
def verify_resolution(
    issue_id: int,
    payload: CitizenVerifySchema,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Reporting citizen confirms whether the civic problem is truly fixed,
    or reopens the ticket if the problem persists on ground.
    """
    issue = q_issue(db, issue_id)
    if current_user.role == UserRole.CITIZEN and issue.reporter_id != current_user.id:
        raise HTTPException(403, "Only the reporting citizen can verify this repair.")

    issue.citizen_verified_at = datetime.utcnow()
    issue.citizen_feedback = payload.feedback or payload.reopen_reason

    if payload.confirmed_resolved:
        issue.progress_percentage = 100
        issue.resolved_at = datetime.utcnow()
        issue.latest_update = "Citizen confirmed successful resolution on ground."
        record_history(
            db, issue, current_user, IssueStatus.RESOLVED,
            f"Citizen verified repair: {payload.feedback or 'Ground fix confirmed.'}",
            100
        )
    else:
        # Reopen complaint
        issue.progress_percentage = 40
        issue.latest_update = f"Citizen reported issue persists: {payload.reopen_reason or 'Ground repair incomplete'}"
        record_history(
            db, issue, current_user, IssueStatus.REOPENED,
            f"Citizen reopened complaint. Reason: {payload.reopen_reason or 'Ground defect not fully remediated'}",
            40
        )

    db.commit()
    return q_issue(db, issue.id)


# -------------------------------------------------------------------
# 8. INDEPENDENT INSPECTION REQUEST
# -------------------------------------------------------------------
@router.post('/{issue_id}/request-inspection', response_model=IssueDetailOut)
def request_inspection(
    issue_id: int,
    notes: Optional[str] = Query(None),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Requests independent municipal quality inspection."""
    issue = q_issue(db, issue_id)
    db.add(InspectionRequest(
        issue_id=issue.id,
        requested_by_id=current_user.id,
        finding_summary=notes or "Independent physical audit requested."
    ))
    record_history(
        db, issue, current_user, IssueStatus.AWAITING_INSPECTION,
        notes or "Independent physical inspection ordered.",
        issue.progress_percentage
    )
    issue.latest_update = "Independent physical inspection scheduled."
    db.commit()
    return q_issue(db, issue.id)


# -------------------------------------------------------------------
# 9. PRIORITY OVERRIDE WITH JUSTIFICATION
# -------------------------------------------------------------------
@router.post('/{issue_id}/override-priority', response_model=IssueDetailOut)
def override_priority(
    issue_id: int,
    payload: PriorityOverrideSchema,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Allows authorized department officers or admins to adjust priority score with explanation."""
    if current_user.role not in [UserRole.ADMIN, UserRole.OFFICER]:
        raise HTTPException(403, "Only administrators and department officers can override priority.")

    issue = q_issue(db, issue_id)
    old_score = issue.priority_score
    issue.priority_score = payload.new_priority_score
    issue.priority_override_reason = f"Override by {current_user.full_name} ({current_user.role.value}): {payload.reason}"
    
    # Recalculate severity & SLA
    from app.services.priority_service import get_severity_from_priority
    issue.severity = get_severity_from_priority(payload.new_priority_score)
    issue.sla_hours = get_sla_hours_from_priority(payload.new_priority_score)
    if issue.created_at:
        issue.sla_deadline = issue.created_at + timedelta(hours=issue.sla_hours)

    record_history(
        db, issue, current_user, issue.status,
        f"Priority adjusted from {old_score} to {payload.new_priority_score}. Reason: {payload.reason}",
        issue.progress_percentage
    )
    db.commit()
    return q_issue(db, issue.id)


# -------------------------------------------------------------------
# 10. CITIZEN & OFFICER DASHBOARD RETRIEVALS
# -------------------------------------------------------------------
@router.get('', response_model=List[IssueDetailOut])
def list_all_issues(
    search: Optional[str] = None,
    status_filter: Optional[IssueStatus] = None,
    type_filter: Optional[IssueType] = None,
    dept_id: Optional[int] = None,
    min_priority: Optional[float] = None,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    q = db.query(Issue)
    if current_user.role == UserRole.OFFICER and current_user.department_id:
        q = q.filter(Issue.department_id == current_user.department_id)
    elif dept_id:
        q = q.filter(Issue.department_id == dept_id)
    if status_filter:
        q = q.filter(Issue.status == status_filter)
    if type_filter:
        q = q.filter(Issue.issue_type == type_filter)
    if min_priority is not None:
        q = q.filter(Issue.priority_score >= min_priority)
    if search:
        q = q.filter((Issue.title.ilike(f'%{search}%')) | (Issue.address.ilike(f'%{search}%')))
    return q.order_by(Issue.priority_score.desc(), Issue.created_at.desc()).offset(skip).limit(min(limit, 200)).all()

@router.get('/stats/citizen', response_model=DashboardStats)
def citizen_stats(db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    q = db.query(Issue).filter(Issue.reporter_id == current_user.id)
    all_my = q.all()
    now = datetime.utcnow()

    overdue = sum(1 for i in all_my if i.sla_deadline and i.sla_deadline < now and i.status not in [IssueStatus.RESOLVED, IssueStatus.CLOSED])
    awaiting_verify = sum(1 for i in all_my if i.status == IssueStatus.RESOLUTION_SUBMITTED)

    return DashboardStats(
        total_issues=len(all_my),
        under_review=sum(1 for i in all_my if i.status in [IssueStatus.SUBMITTED, IssueStatus.REPORTED, IssueStatus.AI_ANALYZED, IssueStatus.UNDER_REVIEW]),
        assigned=sum(1 for i in all_my if i.status == IssueStatus.ASSIGNED),
        in_progress=sum(1 for i in all_my if i.status in [IssueStatus.IN_PROGRESS, IssueStatus.AWAITING_INSPECTION]),
        resolved=sum(1 for i in all_my if i.status in [IssueStatus.RESOLVED, IssueStatus.CLOSED]),
        high_priority=sum(1 for i in all_my if i.severity in [SeverityLevel.HIGH, SeverityLevel.CRITICAL]),
        overdue_count=overdue,
        awaiting_verification=awaiting_verify
    )

@router.get('/my-reports', response_model=List[IssueDetailOut])
def my_reports(
    status_filter: Optional[IssueStatus] = None,
    category: Optional[IssueType] = None,
    severity: Optional[SeverityLevel] = None,
    search: Optional[str] = None,
    sort: str = 'newest',
    skip: int = 0,
    limit: int = 50,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    q = db.query(Issue).filter(Issue.reporter_id == current_user.id)
    if status_filter:
        q = q.filter(Issue.status == status_filter)
    if category:
        q = q.filter(Issue.issue_type == category)
    if severity:
        q = q.filter(Issue.severity == severity)
    if search:
        q = q.filter(Issue.title.ilike(f'%{search}%'))
    q = q.order_by(Issue.created_at.asc() if sort == 'oldest' else Issue.created_at.desc())
    return q.offset(skip).limit(min(limit, 100)).all()

@router.get('/department/assigned', response_model=List[IssueDetailOut])
def department_issues(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    if current_user.role not in (UserRole.ADMIN, UserRole.OFFICER):
        raise HTTPException(403, 'Department authorization required')
    q = db.query(Issue)
    if current_user.role == UserRole.OFFICER:
        if not current_user.department_id:
            raise HTTPException(400, 'Officer has no assigned department')
        q = q.filter(Issue.department_id == current_user.department_id)
    return q.order_by(Issue.priority_score.desc(), Issue.created_at.desc()).all()

@router.get('/map-data')
def map_data(db: Session = Depends(get_db)):
    issues = db.query(Issue).options(joinedload(Issue.images), joinedload(Issue.department)).all()
    now = datetime.utcnow()
    return [
        {
            'id': i.id,
            'title': i.title,
            'description': i.description,
            'issue_type': getattr(i.issue_type, 'value', str(i.issue_type)),
            'latitude': i.latitude,
            'longitude': i.longitude,
            'address': i.address,
            'status': getattr(i.status, 'value', str(i.status)),
            'severity': getattr(i.severity, 'value', str(i.severity)),
            'priority_score': i.priority_score,
            'priority_explanation': i.priority_explanation,
            'department': i.department.name if i.department else None,
            'image_url': i.images[0].original_image_path if i.images else None,
            'annotated_image_url': i.images[0].annotated_image_path if i.images else None,
            'resolution_image_url': i.resolution_image_path,
            'support_count': i.support_count or 1,
            'is_overdue': bool(i.sla_deadline and i.sla_deadline < now and i.status not in [IssueStatus.RESOLVED, IssueStatus.CLOSED]),
            'created_at': i.created_at
        }
        for i in issues
    ]

@router.get('/{issue_id}', response_model=IssueDetailOut)
def details(issue_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    issue = q_issue(db, issue_id)
    return issue

@router.get('/{issue_id}/timeline', response_model=List[IssueStatusHistoryOut])
def timeline(issue_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    return db.query(IssueStatusHistory).filter_by(issue_id=issue_id).order_by(IssueStatusHistory.created_at.asc()).all()

@router.post('/{issue_id}/accept', response_model=IssueDetailOut)
def accept(issue_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    issue = q_issue(db, issue_id)
    assert_department_access(issue, current_user)
    record_history(db, issue, current_user, IssueStatus.ACCEPTED, 'Complaint accepted by department lead.', issue.progress_percentage)
    issue.latest_update = 'Complaint accepted by department.'
    db.commit()
    return q_issue(db, issue.id)

@router.post('/{issue_id}/reject', response_model=IssueDetailOut)
def reject(issue_id: int, payload: RejectIssueSchema, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    issue = q_issue(db, issue_id)
    assert_department_access(issue, current_user)
    record_history(db, issue, current_user, IssueStatus.REJECTED, f'Rejected: {payload.reason}', issue.progress_percentage)
    issue.latest_update = f'Rejected: {payload.reason}'
    issue.closed_at = datetime.utcnow()
    db.commit()
    return q_issue(db, issue.id)

@router.post('/{issue_id}/assign', response_model=IssueDetailOut)
def assign_officer(issue_id: int, payload: AssignOfficerSchema, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    issue = q_issue(db, issue_id)
    assert_department_access(issue, current_user)
    officer = db.query(User).filter(User.id == payload.officer_id, User.role == UserRole.OFFICER).first()
    if not officer:
        raise HTTPException(404, 'Designated officer not found')
    issue.assigned_officer_id = officer.id
    issue.assigned_at = datetime.utcnow()
    record_history(db, issue, current_user, IssueStatus.ASSIGNED, f'Assigned to field officer {officer.full_name}', issue.progress_percentage)
    issue.latest_update = f'Assigned to officer {officer.full_name}'
    db.commit()
    return q_issue(db, issue.id)

@router.patch('/{issue_id}/status', response_model=IssueDetailOut)
def update_status(issue_id: int, payload: StatusUpdateSchema, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    issue = q_issue(db, issue_id)
    assert_department_access(issue, current_user)
    record_history(db, issue, current_user, payload.status, payload.notes, issue.progress_percentage)
    issue.latest_update = payload.notes or issue.latest_update
    if payload.status == IssueStatus.RESOLVED:
        issue.progress_percentage = 100
        issue.resolved_at = datetime.utcnow()
    if payload.status == IssueStatus.CLOSED:
        issue.closed_at = datetime.utcnow()
    db.commit()
    return q_issue(db, issue.id)

@router.patch('/{issue_id}/progress', response_model=IssueDetailOut)
def progress(issue_id: int, payload: UpdateProgressSchema, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    issue = q_issue(db, issue_id)
    assert_department_access(issue, current_user)
    issue.progress_percentage = payload.progress_percentage
    issue.latest_update = payload.note or f'Progress updated to {payload.progress_percentage}%'
    target = IssueStatus.IN_PROGRESS if payload.progress_percentage > 0 and issue.status not in (IssueStatus.RESOLVED, IssueStatus.CLOSED) else issue.status
    record_history(db, issue, current_user, target, payload.note or f'Progress updated to {payload.progress_percentage}%', payload.progress_percentage)
    db.commit()
    return q_issue(db, issue.id)

@router.post('/{issue_id}/notes', response_model=IssueDetailOut)
def add_note(issue_id: int, payload: UpdateProgressSchema, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    issue = q_issue(db, issue_id)
    assert_department_access(issue, current_user)
    if not payload.note:
        raise HTTPException(400, 'A progress note is required')
    issue.latest_update = payload.note
    issue.progress_percentage = payload.progress_percentage
    record_history(db, issue, current_user, issue.status, payload.note, payload.progress_percentage)
    db.commit()
    return q_issue(db, issue.id)

@router.patch('/{issue_id}/estimate', response_model=IssueDetailOut)
def estimate(issue_id: int, payload: UpdateEstimateSchema, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    issue = q_issue(db, issue_id)
    assert_department_access(issue, current_user)
    issue.estimated_completion_date = payload.estimated_completion_date
    record_history(db, issue, current_user, issue.status, f'Target completion committed for {payload.estimated_completion_date.strftime("%d %b %Y")}', issue.progress_percentage)
    db.commit()
    return q_issue(db, issue.id)

@router.post('/{issue_id}/resolve', response_model=IssueDetailOut)
def resolve(issue_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    issue = q_issue(db, issue_id)
    assert_department_access(issue, current_user)
    issue.progress_percentage = 100
    issue.resolved_at = datetime.utcnow()
    issue.latest_update = 'Issue marked as resolved by department.'
    record_history(db, issue, current_user, IssueStatus.RESOLVED, issue.latest_update, 100)
    db.commit()
    return q_issue(db, issue.id)

@router.post('/{issue_id}/close', response_model=IssueDetailOut)
def close(issue_id: int, db: Session = Depends(get_db), current_user: User = Depends(get_current_user)):
    issue = q_issue(db, issue_id)
    assert_department_access(issue, current_user)
    issue.closed_at = datetime.utcnow()
    record_history(db, issue, current_user, IssueStatus.CLOSED, 'Complaint formally archived and closed.', issue.progress_percentage)
    db.commit()
    return q_issue(db, issue.id)


# -------------------------------------------------------------------
# 11. INDIVIDUAL CITIZEN REPORTS LIST (Architecture Part 1 & 12)
# -------------------------------------------------------------------
@router.get('/{issue_id}/reports')
def list_issue_reports(
    issue_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Returns all individual citizen reports linked to this civic issue with privacy masking."""
    from app.models.intelligence import Report
    reports = db.query(Report).options(joinedload(Report.media)).filter(
        Report.issue_id == issue_id,
        Report.status == "accepted"
    ).order_by(Report.created_at.asc()).all()

    return [
        {
            "id": r.id,
            "report_tracking_id": r.report_tracking_id,
            "submission_id": r.submission_id,
            "reporter_name": r.reporter_name if current_user.role in [UserRole.ADMIN, UserRole.OFFICER] else f"Citizen #{r.reporter_id}",
            "description": r.description,
            "category": r.selected_category,
            "latitude": r.latitude,
            "longitude": r.longitude,
            "address": r.address,
            "counted": r.counted,
            "link_method": r.link_method,
            "repeat_reporter": r.repeat_reporter,
            "created_at": r.created_at.isoformat() if r.created_at else None,
            "images": [m.image_url for m in r.media] if r.media else []
        }
        for r in reports
    ]


# -------------------------------------------------------------------
# 12. AI INTELLIGENCE & ANALYSIS BREAKDOWN (Part 12)
# -------------------------------------------------------------------
@router.get('/{issue_id}/ai-analysis')
def get_issue_ai_analysis(
    issue_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Returns comprehensive AI analysis: duplicate similarity scores, severity assessments, and dynamic priority breakdown."""
    from app.models.intelligence import SeverityAssessment, ReportMatch
    issue = q_issue(db, issue_id)

    assessments = db.query(SeverityAssessment).filter(SeverityAssessment.issue_id == issue_id).order_by(SeverityAssessment.created_at.asc()).all()
    latest_assessment = assessments[-1] if assessments else None

    matches = db.query(ReportMatch).filter(ReportMatch.issue_id == issue_id).order_by(ReportMatch.created_at.desc()).all()

    priority_breakdown = {}
    if issue.priority_breakdown:
        try:
            priority_breakdown = json.loads(issue.priority_breakdown)
        except Exception:
            pass

    return {
        "issue_id": issue.id,
        "display_id": issue.display_id,
        "current_severity": {
            "score": issue.severity_score or 50.0,
            "level": issue.severity_level or "MEDIUM",
            "confidence": latest_assessment.confidence if latest_assessment else issue.ai_confidence,
            "explanation": latest_assessment.explanation if latest_assessment else issue.priority_explanation,
            "risk_factors": json.loads(latest_assessment.risk_factors) if latest_assessment and latest_assessment.risk_factors else [],
            "history": [
                {
                    "id": a.id,
                    "score": a.severity_score,
                    "level": a.severity_level,
                    "confidence": a.confidence,
                    "explanation": a.explanation,
                    "is_escalation": a.is_escalation,
                    "is_deescalation": a.is_deescalation,
                    "created_at": a.created_at.isoformat() if a.created_at else None
                }
                for a in assessments
            ]
        },
        "current_priority": {
            "score": issue.priority_score,
            "level": issue.priority_level or "MEDIUM",
            "breakdown": priority_breakdown,
            "explanation": issue.priority_explanation
        },
        "duplicate_detection_matches": [
            {
                "id": m.id,
                "report_id": m.report_id,
                "geo_similarity": m.geo_similarity,
                "visual_similarity": m.visual_similarity,
                "text_similarity": m.text_similarity,
                "context_similarity": m.context_similarity,
                "final_score": m.final_score,
                "decision": m.decision,
                "ai_reasoning": m.ai_reasoning,
                "created_at": m.created_at.isoformat() if m.created_at else None
            }
            for m in matches
        ]
    }


# -------------------------------------------------------------------
# 13. AUDIT & ISSUE ACTIVITY LOG (Part 11 & 12)
# -------------------------------------------------------------------
@router.get('/{issue_id}/activity-log')
def get_issue_activity_log(
    issue_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """Returns chronological audit history of all changes to this civic issue."""
    from app.models.intelligence import IssueActivityLog
    logs = db.query(IssueActivityLog).filter(IssueActivityLog.issue_id == issue_id).order_by(IssueActivityLog.created_at.desc()).all()
    return [
        {
            "id": l.id,
            "action": l.action,
            "actor_name": l.actor_name,
            "actor_role": l.actor_role,
            "notes": l.notes,
            "before_state": json.loads(l.before_state) if l.before_state else None,
            "after_state": json.loads(l.after_state) if l.after_state else None,
            "created_at": l.created_at.isoformat() if l.created_at else None
        }
        for l in logs
    ]

