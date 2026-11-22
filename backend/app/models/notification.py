from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, Boolean, Enum as SQLEnum
from sqlalchemy.orm import relationship
from datetime import datetime
import enum
from app.core.database import Base

class NotificationType(str, enum.Enum):
    STATUS_UPDATE = "STATUS_UPDATE"
    RECURRING_FOLLOW_UP = "RECURRING_FOLLOW_UP"
    RESOLUTION_VERIFICATION = "RESOLUTION_VERIFICATION"
    SYSTEM = "SYSTEM"

class FollowUpStatus(str, enum.Enum):
    PENDING = "PENDING"
    STILL_EXISTS = "STILL_EXISTS"
    RESOLVED = "RESOLVED"
    RETURNED = "RETURNED"
    NOT_SURE = "NOT_SURE"

class Notification(Base):
    __tablename__ = "notifications"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), nullable=False, index=True)
    issue_id = Column(Integer, ForeignKey("issues.id"), nullable=True, index=True)
    title = Column(String(200), nullable=False)
    message = Column(Text, nullable=False)
    notification_type = Column(SQLEnum(NotificationType), default=NotificationType.STATUS_UPDATE, nullable=False)
    is_read = Column(Boolean, default=False)
    follow_up_status = Column(SQLEnum(FollowUpStatus), nullable=True)
    follow_up_response_at = Column(DateTime, nullable=True)
    follow_up_note = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)

    # Relationships
    user = relationship("User", backref="notifications")
    issue = relationship("Issue", backref="notifications")
