from pydantic import BaseModel
from typing import Dict, List, Optional, Any

class DepartmentStat(BaseModel):
    department_id: int
    department_name: str
    department_code: Optional[str] = None
    total_assigned: int
    pending: int
    in_progress: int
    resolved: int
    resolution_rate: float
    overdue_count: Optional[int] = 0

class PredictiveHotspotOut(BaseModel):
    cluster_id: str
    latitude: float
    longitude: float
    address: str
    total_complaints: int
    unresolved_complaints: int
    critical_complaints: int
    reopened_complaints: int
    dominant_category: str
    risk_score: float
    risk_level: str
    risk_color: str
    recurrence_probability: str
    confidence: float
    forecast_period: str
    preventive_action: str
    methodology_note: str

class AnalyticsDashboardResponse(BaseModel):
    total_issues: int
    open_issues: int
    in_progress_issues: int
    resolved_issues: int
    critical_issues_count: int
    reopened_count: int = 0
    escalated_count: int = 0
    average_resolution_hours: float = 36.5
    issues_by_category: Dict[str, int]
    issues_by_severity: Dict[str, int]
    issues_by_status: Dict[str, int]
    department_performance: List[DepartmentStat]
    predictive_hotspots: List[PredictiveHotspotOut] = []
