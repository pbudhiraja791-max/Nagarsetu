from pydantic import BaseModel, Field
from typing import Optional, List, Dict, Any
from datetime import datetime
from app.models.issue import IssueStatus, IssueType, SeverityLevel

class UserSimple(BaseModel):
    id: int
    full_name: Optional[str] = None
    email: str
    class Config:
        from_attributes = True

class DepartmentSimple(BaseModel):
    id: int
    name: str
    code: Optional[str] = None
    contact_email: Optional[str] = None
    class Config:
        from_attributes = True

class IssueImageOut(BaseModel):
    id: int
    original_image_path: str
    annotated_image_path: Optional[str] = None
    bounding_box_json: Optional[str] = None
    created_at: datetime
    class Config:
        from_attributes = True

class IssueStatusHistoryOut(BaseModel):
    id: int
    previous_status: Optional[IssueStatus] = None
    new_status: IssueStatus
    notes: Optional[str] = None
    progress_percentage: Optional[int] = None
    created_at: datetime
    changed_by: Optional[UserSimple] = None
    class Config:
        from_attributes = True

class IssueDetailOut(BaseModel):
    id: int
    display_id: Optional[str] = None
    title: str
    summary: Optional[str] = None
    description: Optional[str] = None
    issue_type: IssueType
    ai_confidence: float
    severity: SeverityLevel
    severity_score: Optional[float] = 50.0
    severity_level: Optional[str] = "MEDIUM"
    priority_score: float
    priority_level: Optional[str] = "MEDIUM"
    priority_breakdown: Optional[str] = None
    priority_explanation: Optional[str] = None
    status: IssueStatus
    latitude: float
    longitude: float
    address: Optional[str] = None
    area: Optional[str] = None
    progress_percentage: int = 0
    latest_update: Optional[str] = None
    support_count: int = 1
    total_reports: Optional[int] = 1
    unique_citizens: Optional[int] = 1
    first_reported_at: Optional[datetime] = None
    last_reported_at: Optional[datetime] = None
    assigned_department: Optional[str] = None
    assigned_officer: Optional[str] = None
    deadline: Optional[datetime] = None
    
    # SLA Tracking
    sla_hours: Optional[int] = 48
    sla_deadline: Optional[datetime] = None
    is_escalated: Optional[bool] = False
    escalation_reason: Optional[str] = None

    # Resolution & Verification
    resolution_image_path: Optional[str] = None
    resolution_notes: Optional[str] = None
    resolution_ai_comparison: Optional[str] = None
    resolution_submitted_at: Optional[datetime] = None
    citizen_feedback: Optional[str] = None
    citizen_verified_at: Optional[datetime] = None

    # Voice & Language
    original_language: Optional[str] = "en"
    voice_audio_path: Optional[str] = None
    voice_transcript: Optional[str] = None

    estimated_completion_date: Optional[datetime] = None
    created_at: datetime
    updated_at: datetime
    assigned_at: Optional[datetime] = None
    resolved_at: Optional[datetime] = None
    closed_at: Optional[datetime] = None

    reporter: Optional[UserSimple] = None
    department: Optional[DepartmentSimple] = None
    assigned_officer: Optional[UserSimple] = None
    images: List[IssueImageOut] = []
    status_history: List[IssueStatusHistoryOut] = []

    class Config:
        from_attributes = True

class DashboardStats(BaseModel):
    total_issues: int
    under_review: int
    assigned: int
    in_progress: int
    resolved: int
    high_priority: int
    overdue_count: Optional[int] = 0
    awaiting_verification: Optional[int] = 0

class UpdateProgressSchema(BaseModel):
    progress_percentage: int = Field(ge=0, le=100)
    note: Optional[str] = None

class AssignOfficerSchema(BaseModel):
    officer_id: int

class RejectIssueSchema(BaseModel):
    reason: str = Field(min_length=3, max_length=2000)

class UpdateEstimateSchema(BaseModel):
    estimated_completion_date: datetime

class StatusUpdateSchema(BaseModel):
    status: IssueStatus
    notes: Optional[str] = None

class CreateIssueSchema(BaseModel):
    title: str
    description: Optional[str] = None
    issue_type: IssueType
    latitude: float
    longitude: float
    address: Optional[str] = None
    original_image_url: str
    annotated_image_url: Optional[str] = None
    ai_confidence: float = 0.85
    severity: SeverityLevel = SeverityLevel.MODERATE
    priority_score: float = 50.0
    priority_explanation: Optional[str] = None
    bounding_box_json: Optional[str] = None
    voice_audio_url: Optional[str] = None
    voice_transcript: Optional[str] = None
    original_language: Optional[str] = "en"

class ResolutionSubmitSchema(BaseModel):
    resolution_image_url: str
    notes: str = Field(min_length=5, max_length=2000)

class CitizenVerifySchema(BaseModel):
    confirmed_resolved: bool
    feedback: Optional[str] = None
    reopen_reason: Optional[str] = None

class PriorityOverrideSchema(BaseModel):
    new_priority_score: float = Field(ge=0.0, le=100.0)
    reason: str = Field(min_length=5, max_length=1000)

class DuplicateCheckRequest(BaseModel):
    latitude: float
    longitude: float
    issue_type: str
    title: Optional[str] = None
    description: Optional[str] = None
    radius_meters: Optional[float] = 50.0

class VoiceReportRequest(BaseModel):
    transcript: str
    language: Optional[str] = "en"
