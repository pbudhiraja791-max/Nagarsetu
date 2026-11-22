from sqlalchemy import Column, Integer, String, Text, Float, DateTime, ForeignKey, Boolean, Enum as SQLEnum
from sqlalchemy.orm import relationship
from datetime import datetime
import enum
from app.core.database import Base

class IssueType(str, enum.Enum):
    POTHOLE = "Pothole"
    ROAD_DAMAGE = "Damaged Road"
    GARBAGE = "Garbage Accumulation"
    OVERFLOWING_DUSTBIN = "Overflowing Dustbin"
    WATER_LEAKAGE = "Water Leakage"
    DRAINAGE_BLOCKAGE = "Drainage Blockage"
    WATERLOGGING = "Waterlogging"
    STREETLIGHT = "Damaged Streetlight"
    ELECTRICAL_WIRE = "Exposed Electrical Wire"
    MANHOLE = "Open Manhole"
    INFRASTRUCTURE_DAMAGE = "Broken Public Infrastructure"
    OTHER = "Other Civic Problem"

class IssueStatus(str, enum.Enum):
    SUBMITTED = "SUBMITTED"
    REPORTED = "REPORTED"  # alias for backward compatibility
    AI_ANALYZED = "AI_ANALYZED"
    UNDER_REVIEW = "UNDER_REVIEW"
    ASSIGNED = "ASSIGNED"
    ACCEPTED = "ACCEPTED"
    IN_PROGRESS = "IN_PROGRESS"
    AWAITING_INSPECTION = "AWAITING_INSPECTION"
    RESOLUTION_SUBMITTED = "RESOLUTION_SUBMITTED"
    CITIZEN_VERIFICATION = "CITIZEN_VERIFICATION"
    RESOLVED = "RESOLVED"
    REOPENED = "REOPENED"
    REJECTED = "REJECTED"
    CLOSED = "CLOSED"

class SeverityLevel(str, enum.Enum):
    LOW = "LOW"
    MEDIUM = "MEDIUM"
    MODERATE = "MODERATE"
    HIGH = "HIGH"
    CRITICAL = "CRITICAL"

class Issue(Base):
    __tablename__ = "issues"

    id = Column(Integer, primary_key=True, index=True)
    display_id = Column(String(20), nullable=True, unique=True, index=True)
    title = Column(String(200), nullable=False)
    summary = Column(Text, nullable=True)
    description = Column(Text, nullable=True)
    issue_type = Column(SQLEnum(IssueType), nullable=False, index=True)
    
    # Location
    latitude = Column(Float, nullable=False, index=True)
    longitude = Column(Float, nullable=False, index=True)
    address = Column(String(255), nullable=True)
    area = Column(String(100), nullable=True)
    
    # AI Analysis & Priority
    ai_confidence = Column(Float, default=0.0)
    severity = Column(SQLEnum(SeverityLevel), default=SeverityLevel.MEDIUM, nullable=False)
    severity_score = Column(Float, default=50.0, nullable=True)
    severity_level = Column(String(20), default="MEDIUM", nullable=True)
    priority_score = Column(Float, default=0.0, index=True)
    priority_level = Column(String(20), default="MEDIUM", nullable=True)
    priority_breakdown = Column(Text, nullable=True)
    priority_explanation = Column(Text, nullable=True)
    priority_override_reason = Column(Text, nullable=True)
    
    # Multi-Report Metrics
    total_reports = Column(Integer, default=1, nullable=False, index=True)
    unique_citizens = Column(Integer, default=1, nullable=False)
    first_reported_at = Column(DateTime, default=datetime.utcnow, nullable=True)
    last_reported_at = Column(DateTime, default=datetime.utcnow, nullable=True)

    # Lifecycle
    status = Column(SQLEnum(IssueStatus), default=IssueStatus.SUBMITTED, nullable=False, index=True)
    progress_percentage = Column(Integer, default=0, nullable=False)
    latest_update = Column(Text, nullable=True)
    
    # Assignments & Ownership
    reporter_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    department_id = Column(Integer, ForeignKey("departments.id"), nullable=True, index=True)
    assigned_officer_id = Column(Integer, ForeignKey("users.id"), nullable=True, index=True)
    assigned_department = Column(String(150), nullable=True)
    assigned_officer_name = Column(String(100), nullable=True)
    assigned_at = Column(DateTime, nullable=True)
    
    # SLA & Deadlines
    sla_hours = Column(Integer, default=48)
    sla_deadline = Column(DateTime, nullable=True)
    deadline = Column(DateTime, nullable=True)
    is_escalated = Column(Boolean, default=False)
    escalation_reason = Column(Text, nullable=True)
    
    # Resolution & Citizen Verification
    resolution_image_path = Column(String(255), nullable=True)
    resolution_notes = Column(Text, nullable=True)
    resolution_ai_comparison = Column(Text, nullable=True)  # JSON before vs after similarity & confidence
    resolution_submitted_at = Column(DateTime, nullable=True)
    citizen_feedback = Column(Text, nullable=True)
    citizen_verified_at = Column(DateTime, nullable=True)
    estimated_completion_date = Column(DateTime, nullable=True)
    resolved_at = Column(DateTime, nullable=True)
    closed_at = Column(DateTime, nullable=True)
    
    # Multilingual & Voice
    original_language = Column(String(10), default="en")  # 'en', 'hi', 'pa'
    voice_audio_path = Column(String(255), nullable=True)
    voice_transcript = Column(Text, nullable=True)
    
    # Community Support Count
    support_count = Column(Integer, default=1)
    
    # Timestamps
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    reporter = relationship("User", foreign_keys=[reporter_id], back_populates="issues")
    assigned_officer = relationship("User", foreign_keys=[assigned_officer_id])
    department = relationship("Department", back_populates="issues")
    images = relationship("IssueImage", back_populates="issue", cascade="all, delete-orphan")
    status_history = relationship("IssueStatusHistory", back_populates="issue", cascade="all, delete-orphan")
    duplicate_relations = relationship(
        "DuplicateIssueRelation",
        foreign_keys="[DuplicateIssueRelation.original_issue_id]",
        back_populates="original_issue",
        cascade="all, delete-orphan"
    )
    supports = relationship("ComplaintSupport", back_populates="issue", cascade="all, delete-orphan")
    inspections = relationship("InspectionRequest", back_populates="issue", cascade="all, delete-orphan")
    reports = relationship(
        "Report",
        foreign_keys="[Report.issue_id]",
        back_populates="issue",
        cascade="all, delete-orphan"
    )
    suggested_reports = relationship(
        "Report",
        foreign_keys="[Report.suggested_issue_id]",
        back_populates="suggested_issue"
    )
    severity_assessments = relationship(
        "SeverityAssessment",
        back_populates="issue",
        cascade="all, delete-orphan"
    )
    activity_logs = relationship(
        "IssueActivityLog",
        back_populates="issue",
        cascade="all, delete-orphan"
    )


class ComplaintSupport(Base):
    __tablename__ = "complaint_supports"

    id = Column(Integer, primary_key=True, index=True)
    issue_id = Column(Integer, ForeignKey("issues.id"), nullable=False, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    issue = relationship("Issue", back_populates="supports")
    user = relationship("User")


class InspectionRequest(Base):
    __tablename__ = "inspection_requests"

    id = Column(Integer, primary_key=True, index=True)
    issue_id = Column(Integer, ForeignKey("issues.id"), nullable=False, index=True)
    requested_by_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    inspector_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    status = Column(String(50), default="PENDING")  # PENDING, IN_PROGRESS, COMPLETED
    finding_summary = Column(Text, nullable=True)
    findings_passed = Column(Boolean, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    completed_at = Column(DateTime, nullable=True)

    issue = relationship("Issue", back_populates="inspections")
    requested_by = relationship("User", foreign_keys=[requested_by_id])
    inspector = relationship("User", foreign_keys=[inspector_id])
