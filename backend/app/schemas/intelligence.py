from datetime import datetime
from typing import Optional, List, Dict, Any
from pydantic import BaseModel, Field


class SubmitReportRequest(BaseModel):
    submission_id: Optional[str] = None
    selected_category: str
    description: str
    latitude: float
    longitude: float
    address: Optional[str] = None
    image_url: Optional[str] = None
    gps_accuracy: Optional[float] = 10.0
    urgency: Optional[str] = "normal"
    title: Optional[str] = None
    voice_transcript: Optional[str] = None
    original_language: Optional[str] = "en"
    citizen_duplicate_choice: Optional[str] = None  # "same_problem" | "different_problem"


class DuplicatePreviewRequest(BaseModel):
    latitude: float
    longitude: float
    category: str
    description: Optional[str] = None
    radius_meters: Optional[float] = None


class DuplicatePreviewCandidate(BaseModel):
    issue_id: int
    display_id: Optional[str] = None
    title: str
    category: str
    distance_meters: float
    address: Optional[str] = None
    total_reports: int = 1
    unique_citizens: int = 1
    status: str
    similarity_score: float
    image_url: Optional[str] = None


class DuplicatePreviewResponse(BaseModel):
    has_possible_duplicates: bool
    candidate_count: int
    top_candidate: Optional[DuplicatePreviewCandidate] = None
    candidates: List[DuplicatePreviewCandidate] = []
    message: Optional[str] = None


class ReportOut(BaseModel):
    id: int
    report_tracking_id: str
    issue_id: Optional[int] = None
    suggested_issue_id: Optional[int] = None
    reporter_id: int
    reporter_name: str
    description: Optional[str] = None
    selected_category: str
    urgency: str
    latitude: float
    longitude: float
    gps_accuracy: float
    address: Optional[str] = None
    status: str
    counted: bool
    link_method: str
    repeat_reporter: bool
    created_at: datetime
    images: List[str] = []

    class Config:
        from_attributes = True


class ConfirmDuplicateRequest(BaseModel):
    notes: Optional[str] = None


class RejectDuplicateRequest(BaseModel):
    reason: Optional[str] = None


class MoveReportRequest(BaseModel):
    target_issue_id: int
    notes: Optional[str] = None


class InvalidateReportRequest(BaseModel):
    reason: str


class OverrideSeverityRequest(BaseModel):
    severity_score: float = Field(ge=0, le=100)
    severity_level: str
    priority_score: Optional[float] = Field(None, ge=0, le=100)
    reason: str


class DedupConfigUpdate(BaseModel):
    auto_link_threshold: Optional[float] = Field(None, ge=0, le=1)
    manual_review_threshold: Optional[float] = Field(None, ge=0, le=1)
    category_radii: Optional[Dict[str, float]] = None
    weights: Optional[Dict[str, float]] = None
    ai_enabled: Optional[bool] = None
    reopening_window_hours: Optional[float] = None
    max_candidates: Optional[int] = None


class SeverityConfigUpdate(BaseModel):
    low_max: Optional[float] = None
    medium_max: Optional[float] = None
    high_max: Optional[float] = None
    critical_max: Optional[float] = None
    confidence_threshold: Optional[float] = None
    auto_update_threshold: Optional[float] = None


class PriorityConfigUpdate(BaseModel):
    weight_severity: Optional[float] = None
    weight_safety_risk: Optional[float] = None
    weight_affected_population: Optional[float] = None
    weight_duration: Optional[float] = None
    weight_unique_citizens: Optional[float] = None
    weight_escalation_trend: Optional[float] = None
