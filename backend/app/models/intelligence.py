import uuid
from datetime import datetime
from sqlalchemy import (
    Column, Integer, String, Text, Float, DateTime, ForeignKey, Boolean
)
from sqlalchemy.orm import relationship
from app.core.database import Base


class Report(Base):
    __tablename__ = "reports"

    id = Column(Integer, primary_key=True, index=True)
    report_tracking_id = Column(String(50), unique=True, index=True, nullable=False)
    issue_id = Column(Integer, ForeignKey("issues.id"), nullable=True, index=True)
    suggested_issue_id = Column(Integer, ForeignKey("issues.id"), nullable=True, index=True)
    submission_id = Column(String(64), unique=True, index=True, nullable=False)
    
    reporter_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    reporter_name = Column(String(100), nullable=False)
    reporter_phone = Column(String(20), nullable=True)
    
    description = Column(Text, nullable=True)
    selected_category = Column(String(50), nullable=False, index=True)
    urgency = Column(String(20), default="normal")  # normal, urgent, critical
    
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    gps_accuracy = Column(Float, default=10.0)
    location_source = Column(String(50), default="gps")  # gps, manual, browser
    address = Column(String(255), nullable=True)
    
    status = Column(String(20), default="accepted", index=True)  # accepted, pending_review, invalidated, rejected
    counted = Column(Boolean, default=False, index=True)
    link_method = Column(String(30), default="direct_creation")  # auto_ai, manual_admin, direct_creation, citizen_confirmed
    repeat_reporter = Column(Boolean, default=False)
    
    created_at = Column(DateTime, default=datetime.utcnow, index=True)

    # Relationships
    issue = relationship("Issue", foreign_keys=[issue_id], back_populates="reports")
    suggested_issue = relationship("Issue", foreign_keys=[suggested_issue_id], back_populates="suggested_reports")
    reporter = relationship("User", foreign_keys=[reporter_id])
    media = relationship("ReportMedia", back_populates="report", cascade="all, delete-orphan")
    matches = relationship("ReportMatch", back_populates="report", cascade="all, delete-orphan")
    severity_assessments = relationship("SeverityAssessment", back_populates="report")
    activity_logs = relationship("IssueActivityLog", back_populates="report")
    admin_reviews = relationship("AdminReview", back_populates="report", cascade="all, delete-orphan")


class ReportMedia(Base):
    __tablename__ = "report_media"

    id = Column(Integer, primary_key=True, index=True)
    report_id = Column(Integer, ForeignKey("reports.id", ondelete="CASCADE"), nullable=False, index=True)
    image_url = Column(String(255), nullable=False)
    image_hash = Column(String(64), nullable=True, index=True)  # SHA-256
    perceptual_hash = Column(String(64), nullable=True, index=True)  # pHash / dHash
    media_type = Column(String(50), default="image/jpeg")
    uploaded_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    report = relationship("Report", back_populates="media")


class ReportMatch(Base):
    __tablename__ = "report_matches"

    id = Column(Integer, primary_key=True, index=True)
    report_id = Column(Integer, ForeignKey("reports.id", ondelete="CASCADE"), nullable=False, index=True)
    issue_id = Column(Integer, ForeignKey("issues.id", ondelete="CASCADE"), nullable=False, index=True)
    
    geo_similarity = Column(Float, default=0.0)
    text_similarity = Column(Float, default=0.0)
    visual_similarity = Column(Float, default=0.0)
    context_similarity = Column(Float, default=0.0)
    final_score = Column(Float, default=0.0)
    confidence = Column(Float, default=0.0)
    
    ai_reasoning = Column(Text, nullable=True)
    model_name = Column(String(50), default="nagarsetu-dedup-v1")
    raw_ai_response = Column(Text, nullable=True)
    decision = Column(String(30), default="LOW")  # HIGH (auto_link), MEDIUM (admin_review), LOW (new_issue)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    report = relationship("Report", back_populates="matches")
    issue = relationship("Issue")


class SeverityAssessment(Base):
    __tablename__ = "severity_assessments"

    id = Column(Integer, primary_key=True, index=True)
    issue_id = Column(Integer, ForeignKey("issues.id", ondelete="CASCADE"), nullable=False, index=True)
    report_id = Column(Integer, ForeignKey("reports.id", ondelete="SET NULL"), nullable=True, index=True)
    
    severity_score = Column(Float, nullable=False)
    severity_level = Column(String(20), nullable=False)  # LOW, MEDIUM, HIGH, CRITICAL
    confidence = Column(Float, default=0.85)
    risk_factors = Column(Text, nullable=True)  # JSON array
    explanation = Column(Text, nullable=True)
    supporting_evidence = Column(Text, nullable=True)  # JSON string
    
    raw_ai_response = Column(Text, nullable=True)
    model_name = Column(String(50), default="nagarsetu-severity-v1")
    is_escalation = Column(Boolean, default=False)
    is_deescalation = Column(Boolean, default=False)
    created_at = Column(DateTime, default=datetime.utcnow, index=True)

    # Relationships
    issue = relationship("Issue", back_populates="severity_assessments")
    report = relationship("Report", back_populates="severity_assessments")


class IssueActivityLog(Base):
    __tablename__ = "issue_activity_log"

    id = Column(Integer, primary_key=True, index=True)
    issue_id = Column(Integer, ForeignKey("issues.id", ondelete="CASCADE"), nullable=False, index=True)
    report_id = Column(Integer, ForeignKey("reports.id", ondelete="SET NULL"), nullable=True, index=True)
    
    actor_id = Column(Integer, ForeignKey("users.id", ondelete="SET NULL"), nullable=True)
    actor_name = Column(String(100), default="System AI")
    actor_role = Column(String(30), default="SYSTEM")
    
    action = Column(String(50), nullable=False, index=True)
    # Actions: ISSUE_CREATED, REPORT_SUBMITTED, DUPLICATE_DETECTED, REPORT_LINKED,
    # REPORT_COUNT_CHANGED, SEVERITY_CHANGED, PRIORITY_CHANGED, ADMIN_REVIEW,
    # REPORT_INVALIDATED, ISSUE_RESOLVED, ISSUE_REOPENED, ADMIN_OVERRIDE
    
    before_state = Column(Text, nullable=True)  # JSON
    after_state = Column(Text, nullable=True)   # JSON
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow, index=True)

    # Relationships
    issue = relationship("Issue", back_populates="activity_logs")
    report = relationship("Report", back_populates="activity_logs")
    actor = relationship("User")


class DedupConfig(Base):
    __tablename__ = "dedup_config"

    id = Column(Integer, primary_key=True, index=True)
    auto_link_threshold = Column(Float, default=0.80)
    manual_review_threshold = Column(Float, default=0.55)
    category_radii_json = Column(Text, default='{"Pothole": 30.0, "Damaged Road": 40.0, "Garbage Accumulation": 75.0, "Overflowing Dustbin": 50.0, "Water Leakage": 40.0, "Drainage Blockage": 50.0, "Waterlogging": 60.0, "Damaged Streetlight": 20.0, "Exposed Electrical Wire": 30.0, "Open Manhole": 25.0, "Broken Public Infrastructure": 40.0, "Other Civic Problem": 40.0}')
    weights_json = Column(Text, default='{"geo": 0.30, "visual": 0.30, "text": 0.20, "context": 0.20}')
    ai_enabled = Column(Boolean, default=True)
    reopening_window_hours = Column(Float, default=72.0)
    max_candidates = Column(Integer, default=5)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class SeverityConfig(Base):
    __tablename__ = "severity_config"

    id = Column(Integer, primary_key=True, index=True)
    low_max = Column(Float, default=25.0)
    medium_max = Column(Float, default=50.0)
    high_max = Column(Float, default=75.0)
    critical_max = Column(Float, default=100.0)
    confidence_threshold = Column(Float, default=0.70)
    auto_update_threshold = Column(Float, default=0.75)
    category_weights_json = Column(Text, default='{}')
    rules_json = Column(Text, default='{}')
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class PriorityConfig(Base):
    __tablename__ = "priority_config"

    id = Column(Integer, primary_key=True, index=True)
    weight_severity = Column(Float, default=0.35)
    weight_safety_risk = Column(Float, default=0.25)
    weight_affected_population = Column(Float, default=0.15)
    weight_duration = Column(Float, default=0.10)
    weight_unique_citizens = Column(Float, default=0.10)
    weight_escalation_trend = Column(Float, default=0.05)
    normalization_rules_json = Column(Text, default='{"max_unique_citizens": 20, "max_duration_hours": 168}')
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class AdminReview(Base):
    __tablename__ = "admin_reviews"

    id = Column(Integer, primary_key=True, index=True)
    report_id = Column(Integer, ForeignKey("reports.id", ondelete="CASCADE"), nullable=True, index=True)
    issue_id = Column(Integer, ForeignKey("issues.id", ondelete="CASCADE"), nullable=True, index=True)
    admin_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    
    review_type = Column(String(30), nullable=False)  # DUPLICATE_REVIEW, SEVERITY_REVIEW, PRIORITY_OVERRIDE, REPORT_INVALIDATION
    decision = Column(String(30), nullable=False)     # CONFIRMED_DUPLICATE, REJECTED_DUPLICATE, MOVED_ISSUE, INVALIDATED, APPROVED_SEVERITY, REJECTED_SEVERITY, MODIFIED
    notes = Column(Text, nullable=True)
    previous_values = Column(Text, nullable=True)     # JSON
    new_values = Column(Text, nullable=True)          # JSON
    created_at = Column(DateTime, default=datetime.utcnow, index=True)

    # Relationships
    report = relationship("Report", back_populates="admin_reviews")
    issue = relationship("Issue")
    admin = relationship("User")
