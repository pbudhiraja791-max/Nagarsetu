import logging
from datetime import datetime
from sqlalchemy import inspect, text
from sqlalchemy.orm import Session
from app.core.database import engine, Base, SessionLocal
import app.models  # Ensure all models are registered in Base

logger = logging.getLogger("nagarsetu.migrations")

def run_migrations():
    """
    Safely inspects existing database schema and executes non-destructive DDL migrations.
    Guarantees backward compatibility for SQLite and PostgreSQL, ensuring no data loss.
    """
    logger.info("Starting NagarSetu schema verification and auto-migration...")
    
    # 1. Create all missing tables first
    Base.metadata.create_all(bind=engine)
    
    # 2. Inspect existing columns in 'issues' table and add any missing columns
    inspector = inspect(engine)
    existing_issue_columns = {col["name"] for col in inspector.get_columns("issues")} if "issues" in inspector.get_table_names() else set()
    
    columns_to_ensure = [
        ("display_id", "VARCHAR(20)"),
        ("summary", "TEXT"),
        ("area", "VARCHAR(100)"),
        ("severity_score", "FLOAT DEFAULT 50.0"),
        ("severity_level", "VARCHAR(20) DEFAULT 'MEDIUM'"),
        ("priority_level", "VARCHAR(20) DEFAULT 'MEDIUM'"),
        ("priority_breakdown", "TEXT"),
        ("total_reports", "INTEGER DEFAULT 1"),
        ("unique_citizens", "INTEGER DEFAULT 1"),
        ("first_reported_at", "DATETIME"),
        ("last_reported_at", "DATETIME"),
        ("assigned_officer_id", "INTEGER"),
        ("assigned_at", "DATETIME"),
        ("assigned_department", "VARCHAR(150)"),
        ("assigned_officer_name", "VARCHAR(100)"),
        ("deadline", "DATETIME"),
        ("progress_percentage", "INTEGER DEFAULT 0"),
        ("latest_update", "TEXT"),
        ("sla_hours", "INTEGER DEFAULT 48"),
        ("sla_deadline", "DATETIME"),
        ("is_escalated", "BOOLEAN DEFAULT 0"),
        ("escalation_reason", "TEXT"),
        ("resolution_image_path", "VARCHAR(255)"),
        ("resolution_notes", "TEXT"),
        ("resolution_ai_comparison", "TEXT"),
        ("resolution_submitted_at", "DATETIME"),
        ("citizen_feedback", "TEXT"),
        ("citizen_verified_at", "DATETIME"),
        ("estimated_completion_date", "DATETIME"),
        ("resolved_at", "DATETIME"),
        ("closed_at", "DATETIME"),
        ("original_language", "VARCHAR(10) DEFAULT 'en'"),
        ("voice_audio_path", "VARCHAR(255)"),
        ("voice_transcript", "TEXT"),
        ("support_count", "INTEGER DEFAULT 1"),
    ]

    with engine.begin() as conn:
        for col_name, col_type in columns_to_ensure:
            if col_name not in existing_issue_columns:
                try:
                    conn.execute(text(f"ALTER TABLE issues ADD COLUMN {col_name} {col_type};"))
                    logger.info(f"Added column {col_name} to issues table.")
                except Exception as e:
                    logger.warning(f"Could not add column {col_name} (might already exist): {e}")

        # Also ensure issue_status_history has progress_percentage
        history_cols = {col["name"] for col in inspector.get_columns("issue_status_history")} if "issue_status_history" in inspector.get_table_names() else set()
        if "progress_percentage" not in history_cols:
            try:
                conn.execute(text("ALTER TABLE issue_status_history ADD COLUMN progress_percentage INTEGER;"))
                logger.info("Added progress_percentage column to issue_status_history.")
            except Exception as e:
                logger.warning(f"Could not add progress_percentage to issue_status_history: {e}")

    # 3. Seed default configurations if empty & backfill existing issues with display_id and reports
    db: Session = SessionLocal()
    try:
        from app.models.intelligence import DedupConfig, SeverityConfig, PriorityConfig, Report, ReportMedia
        from app.models.issue import Issue
        
        # DedupConfig
        if not db.query(DedupConfig).first():
            db.add(DedupConfig())
            db.commit()
            
        # SeverityConfig
        if not db.query(SeverityConfig).first():
            db.add(SeverityConfig())
            db.commit()
            
        # PriorityConfig
        if not db.query(PriorityConfig).first():
            db.add(PriorityConfig())
            db.commit()

        # Ensure all existing issues have display_id and default values
        existing_issues = db.query(Issue).all()
        for idx, issue in enumerate(existing_issues, start=101):
            changed = False
            if not issue.display_id:
                issue.display_id = f"NG-{idx}"
                changed = True
            if issue.total_reports is None or issue.total_reports < 1:
                issue.total_reports = 1
                changed = True
            if issue.unique_citizens is None or issue.unique_citizens < 1:
                issue.unique_citizens = 1
                changed = True
            if not issue.first_reported_at:
                issue.first_reported_at = issue.created_at or datetime.utcnow()
                changed = True
            if not issue.last_reported_at:
                issue.last_reported_at = issue.created_at or datetime.utcnow()
                changed = True
            if not issue.severity_level:
                issue.severity_level = getattr(issue.severity, 'value', str(issue.severity or 'MEDIUM'))
                changed = True
            if issue.severity_score is None:
                issue.severity_score = 50.0
                changed = True
            if not issue.priority_level:
                p_score = issue.priority_score or 50.0
                if p_score >= 75:
                    issue.priority_level = "CRITICAL"
                elif p_score >= 50:
                    issue.priority_level = "HIGH"
                elif p_score >= 25:
                    issue.priority_level = "MEDIUM"
                else:
                    issue.priority_level = "LOW"
                changed = True

            # Backfill initial report if no reports exist for this issue
            has_report = db.query(Report).filter(Report.issue_id == issue.id).first()
            if not has_report:
                import uuid
                report_track = f"REP-{datetime.utcnow().year}-{issue.id:04d}"
                sub_id = str(uuid.uuid4())
                rep = Report(
                    report_tracking_id=report_track,
                    issue_id=issue.id,
                    submission_id=sub_id,
                    reporter_id=issue.reporter_id,
                    reporter_name="Citizen Reporter",
                    description=issue.description or issue.title,
                    selected_category=getattr(issue.issue_type, 'value', str(issue.issue_type)),
                    latitude=issue.latitude,
                    longitude=issue.longitude,
                    address=issue.address,
                    status="accepted",
                    counted=True,
                    link_method="direct_creation",
                    created_at=issue.created_at or datetime.utcnow()
                )
                db.add(rep)
                db.flush()
                
                # If issue had images, link to report_media
                if issue.images:
                    for img in issue.images:
                        db.add(ReportMedia(
                            report_id=rep.id,
                            image_url=img.original_image_path,
                            media_type="image/jpeg",
                            uploaded_at=img.created_at or datetime.utcnow()
                        ))
                changed = True

            if changed:
                db.commit()

        logger.info("NagarSetu schema migration and configuration verification complete.")
    finally:
        db.close()


if __name__ == "__main__":
    run_migrations()
    print("Migrations executed successfully.")
