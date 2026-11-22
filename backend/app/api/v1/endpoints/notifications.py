from fastapi import APIRouter, Depends, HTTPException, Query, Body
from sqlalchemy.orm import Session
from typing import List, Optional
from datetime import datetime

from app.core.database import get_db
from app.api.v1.endpoints.auth import get_current_user
from app.models.user import User
from app.models.issue import Issue, IssueStatus
from app.models.history import IssueStatusHistory
from app.models.notification import Notification, NotificationType, FollowUpStatus
from pydantic import BaseModel

router = APIRouter()

class FollowUpResponseSchema(BaseModel):
    notification_id: int
    response: str  # STILL_EXISTS, RESOLVED, RETURNED, NOT_SURE
    note: Optional[str] = None
    new_image_url: Optional[str] = None

class ResolutionFeedbackSchema(BaseModel):
    issue_id: int
    status: str  # YES, NO, PARTIALLY_RESOLVED
    feedback_notes: Optional[str] = None
    new_image_url: Optional[str] = None

@router.get("", summary="Get current user notifications")
def get_user_notifications(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    notifs = db.query(Notification).filter(Notification.user_id == current_user.id).order_by(Notification.created_at.desc()).all()
    
    # If no notifications exist for this user, seed default follow-up & status update notifications based on user's issues
    if not notifs:
        user_issues = db.query(Issue).filter(Issue.reporter_id == current_user.id).all()
        for idx, issue in enumerate(user_issues):
            if issue.status in [IssueStatus.RESOLVED, IssueStatus.CLOSED]:
                n = Notification(
                    user_id=current_user.id,
                    issue_id=issue.id,
                    title="Resolution Verification Required",
                    message=f"Your report '{issue.title}' ({issue.display_id}) was marked as resolved. Is the problem actually fixed?",
                    notification_type=NotificationType.RESOLUTION_VERIFICATION,
                    follow_up_status=FollowUpStatus.PENDING,
                    is_read=False
                )
                db.add(n)
            else:
                n = Notification(
                    user_id=current_user.id,
                    issue_id=issue.id,
                    title=f"Update: {issue.display_id}",
                    message=f"Your civic issue '{issue.title}' is currently {issue.status.value.replace('_', ' ')}. Priority score: {issue.priority_score}/100.",
                    notification_type=NotificationType.STATUS_UPDATE,
                    is_read=False
                )
                db.add(n)
        
        # Add a smart recurring issue follow-up sample
        demo_recurring = Notification(
            user_id=current_user.id,
            issue_id=user_issues[0].id if user_issues else None,
            title="Recurring Issue Follow-Up",
            message="Are you still facing the same civic problem in your neighbourhood? Help us verify if the fix has held up.",
            notification_type=NotificationType.RECURRING_FOLLOW_UP,
            follow_up_status=FollowUpStatus.PENDING,
            is_read=False
        )
        db.add(demo_recurring)
        db.commit()
        notifs = db.query(Notification).filter(Notification.user_id == current_user.id).order_by(Notification.created_at.desc()).all()

    unread_count = sum(1 for n in notifs if not n.is_read)
    
    return {
        "unread_count": unread_count,
        "notifications": [
            {
                "id": n.id,
                "issue_id": n.issue_id,
                "title": n.title,
                "message": n.message,
                "type": n.notification_type.value,
                "is_read": n.is_read,
                "follow_up_status": n.follow_up_status.value if n.follow_up_status else None,
                "follow_up_note": n.follow_up_note,
                "created_at": n.created_at.isoformat()
            }
            for n in notifs
        ]
    }

@router.patch("/{notification_id}/read", summary="Mark notification as read")
def mark_read(
    notification_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    notif = db.query(Notification).filter(Notification.id == notification_id, Notification.user_id == current_user.id).first()
    if not notif:
        raise HTTPException(404, "Notification not found")
    notif.is_read = True
    db.commit()
    return {"success": True}

@router.post("/follow-up-response", summary="Respond to recurring follow-up notification")
def respond_follow_up(
    payload: FollowUpResponseSchema,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    notif = db.query(Notification).filter(Notification.id == payload.notification_id, Notification.user_id == current_user.id).first()
    if not notif:
        raise HTTPException(404, "Notification not found")
    
    status_enum = {
        "STILL_EXISTS": FollowUpStatus.STILL_EXISTS,
        "RESOLVED": FollowUpStatus.RESOLVED,
        "RETURNED": FollowUpStatus.RETURNED,
        "NOT_SURE": FollowUpStatus.NOT_SURE
    }.get(payload.response.upper(), FollowUpStatus.NOT_SURE)

    notif.follow_up_status = status_enum
    notif.follow_up_note = payload.note
    notif.follow_up_response_at = datetime.utcnow()
    notif.is_read = True

    # If linked to an issue and issue still exists or returned, update issue
    if notif.issue_id:
        issue = db.query(Issue).filter(Issue.id == notif.issue_id).first()
        if issue:
            if status_enum in [FollowUpStatus.STILL_EXISTS, FollowUpStatus.RETURNED]:
                old_status = issue.status
                issue.status = IssueStatus.UNDER_REVIEW
                issue.latest_update = f"Citizen reported issue has returned/persists: {payload.note or 'Ground problem still active'}"
                db.add(IssueStatusHistory(
                    issue_id=issue.id,
                    previous_status=old_status,
                    new_status=IssueStatus.UNDER_REVIEW,
                    changed_by_user_id=current_user.id,
                    notes=f"Recurring follow-up: {payload.note or 'Problem returned'}"
                ))
            elif status_enum == FollowUpStatus.RESOLVED:
                issue.citizen_verified_at = datetime.utcnow()
                issue.latest_update = "Citizen confirmed problem remains permanently resolved."

    db.commit()

    if status_enum in [FollowUpStatus.STILL_EXISTS, FollowUpStatus.RETURNED]:
        msg = "Thank you for reporting this. We will notify the responsible department that the issue still persists."
    elif status_enum == FollowUpStatus.RESOLVED:
        msg = "Thank you for confirming! Your feedback helps us improve public services."
    else:
        msg = "Thank you for your response. Our municipal field team will conduct a spot check."

    return {
        "success": True,
        "message": msg,
        "status": status_enum.value
    }

@router.post("/verify-resolution", summary="Smart Feedback: Issue Resolution Verification")
def verify_issue_resolution(
    payload: ResolutionFeedbackSchema,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    issue = db.query(Issue).filter(Issue.id == payload.issue_id).first()
    if not issue:
        raise HTTPException(404, "Civic issue not found")

    status_choice = payload.status.upper()
    issue.citizen_verified_at = datetime.utcnow()

    if status_choice == "YES":
        issue.status = IssueStatus.RESOLVED
        issue.progress_percentage = 100
        issue.citizen_feedback = payload.feedback_notes or "Confirmed resolved on ground."
        issue.latest_update = "Citizen verified: Resolution confirmed successful."
        db.add(IssueStatusHistory(
            issue_id=issue.id,
            previous_status=issue.status,
            new_status=IssueStatus.RESOLVED,
            changed_by_user_id=current_user.id,
            notes=f"Citizen confirmation: {issue.citizen_feedback}"
        ))
        msg = "Thank you for confirming! Your feedback helps us improve public services."

    elif status_choice == "NO":
        old_status = issue.status
        issue.status = IssueStatus.UNDER_REVIEW
        issue.citizen_feedback = payload.feedback_notes or "Citizen reported issue is NOT resolved."
        issue.latest_update = f"Citizen rejected resolution: {issue.citizen_feedback}"
        db.add(IssueStatusHistory(
            issue_id=issue.id,
            previous_status=old_status,
            new_status=IssueStatus.UNDER_REVIEW,
            changed_by_user_id=current_user.id,
            notes=f"Resolution rejected by citizen. Reason: {issue.citizen_feedback}"
        ))
        msg = "Thank you for reporting this. We will notify the responsible department that the issue still persists."

    else:  # PARTIALLY_RESOLVED
        old_status = issue.status
        issue.status = IssueStatus.IN_PROGRESS
        issue.citizen_feedback = payload.feedback_notes or "Partially resolved, further repair needed."
        issue.latest_update = f"Citizen reported partial fix: {issue.citizen_feedback}"
        db.add(IssueStatusHistory(
            issue_id=issue.id,
            previous_status=old_status,
            new_status=IssueStatus.IN_PROGRESS,
            changed_by_user_id=current_user.id,
            notes=f"Partial resolution feedback: {issue.citizen_feedback}"
        ))
        msg = "Thank you for reporting this. We will notify the responsible department that further work is required."

    db.commit()
    return {
        "success": True,
        "message": msg,
        "current_status": issue.status.value
    }
