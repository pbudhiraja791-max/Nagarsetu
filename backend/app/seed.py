import os
import sys
import uuid
import json
from datetime import datetime, timedelta

# Add backend directory to sys.path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from sqlalchemy.orm import Session
from app.core.database import SessionLocal, engine, Base
from app.core.security import get_password_hash
from app.core.migrations import run_migrations
from app.models.department import Department
from app.models.user import User, UserRole
from app.models.issue import (
    Issue, IssueType, IssueStatus, SeverityLevel, ComplaintSupport
)
from app.models.image import IssueImage
from app.models.history import IssueStatusHistory
from app.models.duplicate import DuplicateIssueRelation
from app.models.intelligence import (
    Report, ReportMedia, ReportMatch, SeverityAssessment,
    IssueActivityLog, DedupConfig, SeverityConfig, PriorityConfig, AdminReview
)
from app.services.counter_management_service import recompute_and_update_issue_counters
from app.services.image_similarity_service import calculate_sha256, calculate_dhash


def seed_database():
    print("=" * 70)
    print("   NAGARSETU (नागरिकों और प्रशासन के बीच सेतु) — ADVANCED SEED SCRIPT")
    print("=" * 70)
    
    # Run auto-migrations first to ensure all columns and tables exist
    run_migrations()
    db: Session = SessionLocal()

    try:
        # 1. Seed Departments
        dept_data = [
            {"name": "Road Maintenance & Paving Department", "code": "DEPT_ROAD", "description": "Arterial roads, pothole resurfacing, and pavement safety.", "email": "roads@nagarsetu.gov.in"},
            {"name": "Sanitation & Waste Management Department", "code": "DEPT_SAN", "description": "Solid waste collection, municipal dumpsters, and illegal garbage dumping.", "email": "sanitation@nagarsetu.gov.in"},
            {"name": "Water Supply & Distribution Department", "code": "DEPT_WATER", "description": "Potable water mains, pipeline bursts, leakages, and pressure monitoring.", "email": "water@nagarsetu.gov.in"},
            {"name": "Drainage & Stormwater Department", "code": "DEPT_DRAIN", "description": "Stormwater drains, sewer lines, open manholes, and urban waterlogging prevention.", "email": "drainage@nagarsetu.gov.in"},
            {"name": "Electrical Infrastructure Department", "code": "DEPT_ELEC", "description": "Municipal lighting, exposed electric cables, and transformer safety.", "email": "electrical@nagarsetu.gov.in"},
            {"name": "Public Works Department (PWD)", "code": "DEPT_PWD", "description": "Public infrastructure, footpaths, bridges, and general civic assets.", "email": "pwd@nagarsetu.gov.in"},
        ]

        dept_map = {}
        for d in dept_data:
            dept = db.query(Department).filter(Department.code == d["code"]).first()
            if not dept:
                dept = Department(name=d["name"], code=d["code"], description=d["description"], contact_email=d["email"])
                db.add(dept)
                db.flush()
            dept_map[d["code"]] = dept
        db.commit()

        # 2. Seed Users
        admin = db.query(User).filter(User.email == "admin@nagarsetu.gov.in").first()
        if not admin:
            admin = User(
                full_name="Municipal Chief Commissioner (NagarSetu Admin)",
                email="admin@nagarsetu.gov.in",
                hashed_password=get_password_hash("Admin@123"),
                role=UserRole.ADMIN
            )
            db.add(admin)
            db.flush()

        # Department Officers
        officers_data = [
            ("Rajesh Sharma", "road.officer@nagarsetu.gov.in", "DEPT_ROAD"),
            ("Priya Patel", "sanitation.officer@nagarsetu.gov.in", "DEPT_SAN"),
            ("Vikram Malhotra", "water.officer@nagarsetu.gov.in", "DEPT_WATER"),
            ("Amit Deshmukh", "drainage.officer@nagarsetu.gov.in", "DEPT_DRAIN"),
            ("Kavita Nair", "electrical.officer@nagarsetu.gov.in", "DEPT_ELEC"),
            ("Suresh Chandra", "pwd.officer@nagarsetu.gov.in", "DEPT_PWD"),
        ]
        officer_map = {}
        for name, email, dcode in officers_data:
            off = db.query(User).filter(User.email == email).first()
            if not off:
                off = User(full_name=name, email=email, hashed_password=get_password_hash("Officer@123"), role=UserRole.OFFICER, department_id=dept_map[dcode].id)
                db.add(off)
                db.flush()
            officer_map[email] = off

        # Citizens (15 unique citizens for multi-citizen reporting)
        citizen_names = [
            ("Ananya Verma", "citizen@nagarsetu.gov.in"),
            ("Rohan Gupta", "rohan.gupta@delhi.org"),
            ("Harpreet Singh", "harpreet.singh@rajpura.org"),
            ("Gurpreet Kaur", "gurpreet.kaur@rajpura.org"),
            ("Rajinder Kumar", "rajinder.kumar@punjab.org"),
            ("Sunita Rani", "sunita.rani@rajpura.org"),
            ("Manish Tiwari", "manish.tiwari@delhi.org"),
            ("Aman Deep", "aman.deep@punjab.org"),
            ("Simranjeet Singh", "simran.singh@rajpura.org"),
            ("Pooja Sharma", "pooja.sharma@delhi.org"),
            ("Deepak Varma", "deepak.varma@rajpura.org"),
            ("Kiran Bala", "kiran.bala@punjab.org"),
            ("Vikramjit Sandhu", "vikram.sandhu@rajpura.org"),
            ("Tarun Bajaj", "tarun.bajaj@delhi.org"),
            ("Meenakshi Sood", "meenakshi.sood@delhi.org"),
        ]
        citizen_users = []
        for name, email in citizen_names:
            u = db.query(User).filter(User.email == email).first()
            if not u:
                u = User(full_name=name, email=email, hashed_password=get_password_hash("Citizen@123"), role=UserRole.CITIZEN)
                db.add(u)
                db.flush()
            citizen_users.append(u)
        db.commit()

        now = datetime.utcnow()

        # =========================================================================
        # 3. SEED MASTER ISSUE NG-101: Garbage accumulation at Main Market, Rajpura
        # Requirement: 12 existing reports from 10 different citizens
        # =========================================================================
        ng101 = db.query(Issue).filter(Issue.display_id == "NG-101").first()
        if not ng101:
            ng101 = Issue(
                display_id="NG-101",
                title="Garbage accumulation at Main Market, Rajpura",
                summary="Extensive solid waste dumping and rotting garbage pile obstructing shopfronts and pedestrian walkway at Main Market, Rajpura.",
                description="Massive garbage accumulation spilling onto the road near Main Market central square. Stench spreading, stray cattle scattering plastic waste.",
                issue_type=IssueType.GARBAGE,
                latitude=30.4840,
                longitude=76.5938,
                address="Main Market, Rajpura, Punjab 140401",
                area="Main Market, Rajpura",
                ai_confidence=0.92,
                severity=SeverityLevel.MEDIUM,
                severity_score=42.0,
                severity_level="MEDIUM",
                priority_score=48.5,
                priority_level="MEDIUM",
                priority_breakdown=json.dumps({
                    "final_priority_score": 48.5,
                    "priority_level": "MEDIUM",
                    "factors": {
                        "severity": {"raw_value": 42.0, "normalized": 0.42, "weighted_contribution": 14.7},
                        "safety_risk": {"raw_value": 45.0, "normalized": 0.45, "weighted_contribution": 11.2},
                        "affected_population": {"normalized": 0.65, "weighted_contribution": 9.8},
                        "duration": {"normalized": 0.35, "weighted_contribution": 3.5},
                        "unique_citizens": {"count": 10, "normalized": 0.67, "weighted_contribution": 6.7},
                        "escalation_trend": {"normalized": 0.20, "weighted_contribution": 1.0}
                    }
                }),
                priority_explanation="Priority Score: 48.5/100 (MEDIUM)\n• Public sanitation and market amenity impact.\n• Endorsed by 12 citizen reports from 10 unique residents.\nRecommended Action: Municipal waste truck clearance within 48 hours.",
                status=IssueStatus.IN_PROGRESS,
                progress_percentage=45,
                latest_update="Sanitation supervisor dispatched collection crew with compactor truck.",
                total_reports=12,
                unique_citizens=10,
                first_reported_at=now - timedelta(days=3),
                last_reported_at=now - timedelta(hours=2),
                reporter_id=citizen_users[2].id,  # Harpreet Singh
                department_id=dept_map["DEPT_SAN"].id,
                assigned_department=dept_map["DEPT_SAN"].name,
                assigned_officer_id=officer_map["sanitation.officer@nagarsetu.gov.in"].id,
                assigned_officer_name="Priya Patel",
                assigned_at=now - timedelta(days=2),
                sla_hours=72,
                sla_deadline=now + timedelta(hours=24),
                deadline=now + timedelta(hours=24),
                support_count=12,
                original_language="pa",
                created_at=now - timedelta(days=3)
            )
            db.add(ng101)
            db.flush()

            # Seed 12 Reports for NG-101
            # 10 unique citizens: indices 2 to 11. Citizen index 2 and index 3 report twice (10 unique, 12 total)
            ng101_report_configs = [
                (2, "Main Market vich kooda ikkatha ho gaya hai. Badboo aa rahi hai.", now - timedelta(days=3), False),
                (3, "Bada kachre ka dher shop number 14 ke samne laga hua hai.", now - timedelta(days=2, hours=20), False),
                (4, "Garbage accumulation blocking pedestrian movement on Main Market road.", now - timedelta(days=2, hours=15), False),
                (5, "Stray animals spreading municipal trash across the street near Rajpura market.", now - timedelta(days=2, hours=8), False),
                (6, "Severe stench from rotting organic waste in front of grain market entrance.", now - timedelta(days=2, hours=2), False),
                (7, "Main Market road par kachra overflow ho raha hai. Please saaf karwaiye.", now - timedelta(days=1, hours=20), False),
                (8, "Municipal bins completely overflowing. Plastic bags and food waste scattered.", now - timedelta(days=1, hours=14), False),
                (9, "Kachre di wajah ton market vich chalna mushkil ho gaya hai.", now - timedelta(days=1, hours=8), False),
                (10, "Garbage heap growing daily. Shopkeepers facing severe business disruption.", now - timedelta(days=1, hours=2), False),
                (11, "Piled up garbage attracting mosquitoes and flies near sweet shop.", now - timedelta(hours=18), False),
                (2, "Same garbage pile has not been picked up yet. Still lying near shop 12.", now - timedelta(hours=8), True),  # repeat reporter
                (3, "Kude da dher haley vi nahi uthaya. Please send municipal cleaning crew.", now - timedelta(hours=2), True), # repeat reporter
            ]

            for idx, (c_idx, desc, rep_time, is_repeat) in enumerate(ng101_report_configs, start=1):
                cit = citizen_users[c_idx]
                r_track = f"REP-2026-RAJ{idx:03d}"
                sub_uuid = str(uuid.uuid4())
                rep = Report(
                    report_tracking_id=r_track,
                    issue_id=ng101.id,
                    submission_id=sub_uuid,
                    reporter_id=cit.id,
                    reporter_name=cit.full_name,
                    reporter_phone="+91 98765 43210",
                    description=desc,
                    selected_category="Garbage Accumulation",
                    urgency="urgent" if idx >= 10 else "normal",
                    latitude=30.4840 + (idx * 0.00008),
                    longitude=76.5938 + (idx * 0.00005),
                    gps_accuracy=8.5,
                    location_source="gps",
                    address=f"Main Market Shop #{10 + idx}, Rajpura",
                    status="accepted",
                    counted=True,
                    link_method="direct_creation" if idx == 1 else "auto_ai",
                    repeat_reporter=is_repeat,
                    created_at=rep_time
                )
                db.add(rep)
                db.flush()

                # Add Media Evidence for each report
                db.add(ReportMedia(
                    report_id=rep.id,
                    image_url="/uploads/original/sample_infra.jpg",
                    image_hash="e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
                    perceptual_hash="d0f0e0c0b0a09080",
                    media_type="image/jpeg",
                    uploaded_at=rep_time
                ))

            # Add issue images
            db.add(IssueImage(
                issue_id=ng101.id,
                original_image_path="/uploads/original/sample_infra.jpg",
                annotated_image_path="/uploads/annotated/sample_infra_annotated.jpg",
                bounding_box_json='[{"class": "Garbage Accumulation", "confidence": 0.92}]'
            ))

            # Initial Severity Assessment
            db.add(SeverityAssessment(
                issue_id=ng101.id,
                severity_score=42.0,
                severity_level="MEDIUM",
                confidence=0.88,
                risk_factors=json.dumps(["pedestrian_inconvenience", "market_hygiene"]),
                explanation="Initial assessment: Moderate solid waste accumulation at Main Market. Baseline safety hazard 45/100.",
                supporting_evidence=json.dumps({"area_ratio": 0.12, "category": "Garbage Accumulation"}),
                model_name="nagarsetu-deterministic-severity-v1",
                created_at=now - timedelta(days=3)
            ))

            # Activity Log entries
            db.add(IssueActivityLog(
                issue_id=ng101.id,
                actor_id=citizen_users[2].id,
                actor_name=citizen_users[2].full_name,
                actor_role="CITIZEN",
                action="ISSUE_CREATED",
                before_state=None,
                after_state=json.dumps({"display_id": "NG-101", "total_reports": 1, "severity_score": 42.0}),
                notes="Civic issue NG-101 created at Main Market, Rajpura.",
                created_at=now - timedelta(days=3)
            ))
            db.add(IssueActivityLog(
                issue_id=ng101.id,
                actor_name="System AI",
                actor_role="SYSTEM",
                action="REPORT_COUNT_CHANGED",
                before_state=json.dumps({"total_reports": 1}),
                after_state=json.dumps({"total_reports": 12, "unique_citizens": 10}),
                notes="11 matching citizen reports consolidated under NG-101 by AI duplicate engine.",
                created_at=now - timedelta(hours=2)
            ))

        # =========================================================================
        # 4. SEED OTHER CIVIC ISSUES (Different Severities & Priorities)
        # =========================================================================
        other_issues = [
            {
                "display_id": "NG-102",
                "title": "Hazardous Open Manhole on Ring Road near Metro Pillar 42",
                "description": "Deep open stormwater chamber without warning barricades or reflector tape. High fatal fall hazard.",
                "category": IssueType.MANHOLE,
                "lat": 28.6139,
                "lng": 77.2090,
                "address": "Ring Road Sector 4, Connaught Place, New Delhi",
                "area": "Connaught Place",
                "severity_score": 95.0,
                "severity_level": "CRITICAL",
                "priority_score": 94.0,
                "priority_level": "CRITICAL",
                "status": IssueStatus.ASSIGNED,
                "dept_code": "DEPT_DRAIN",
                "total_reports": 4,
                "unique_citizens": 4,
            },
            {
                "display_id": "NG-103",
                "title": "Severe Pothole Cluster and Asphalt Cratering on Outer Ring Road",
                "description": "Road surface eroded causing 10-inch deep potholes. Bike riders skidded yesterday during rain.",
                "category": IssueType.POTHOLE,
                "lat": 28.6250,
                "lng": 77.2180,
                "address": "Barakhamba Road Crossing, Central Delhi",
                "area": "Central Delhi",
                "severity_score": 68.0,
                "severity_level": "HIGH",
                "priority_score": 75.5,
                "priority_level": "HIGH",
                "status": IssueStatus.IN_PROGRESS,
                "dept_code": "DEPT_ROAD",
                "total_reports": 5,
                "unique_citizens": 4,
            },
            {
                "display_id": "NG-104",
                "title": "Dangling Live High-Voltage Cable near Community Park",
                "description": "Nangi bijli ki taar park ke gate par latak rahi hai. Children play here every evening. Lethal electrocution risk.",
                "category": IssueType.ELECTRICAL_WIRE,
                "lat": 28.6080,
                "lng": 77.2150,
                "address": "Lodi Garden Gate 3, New Delhi",
                "area": "Lodi Garden",
                "severity_score": 96.0,
                "severity_level": "CRITICAL",
                "priority_score": 98.0,
                "priority_level": "CRITICAL",
                "status": IssueStatus.ACCEPTED,
                "dept_code": "DEPT_ELEC",
                "total_reports": 2,
                "unique_citizens": 2,
            },
            {
                "display_id": "NG-105",
                "title": "Broken Streetlight Array Creating Dark Zone (RESOLVED)",
                "description": "Three consecutive sodium vapor lights were damaged. Pedestrian night crossing restored.",
                "category": IssueType.STREETLIGHT,
                "lat": 28.6050,
                "lng": 77.2150,
                "address": "Max Mueller Marg, Lodi Estate, New Delhi",
                "area": "Lodi Estate",
                "severity_score": 24.0,
                "severity_level": "LOW",
                "priority_score": 22.0,
                "priority_level": "LOW",
                "status": IssueStatus.RESOLVED,
                "dept_code": "DEPT_ELEC",
                "total_reports": 1,
                "unique_citizens": 1,
                "resolved": True
            }
        ]

        for item in other_issues:
            existing_iss = db.query(Issue).filter(Issue.display_id == item["display_id"]).first()
            if not existing_iss:
                sla_h = 24 if item["severity_level"] == "CRITICAL" else 48
                iss = Issue(
                    display_id=item["display_id"],
                    title=item["title"],
                    summary=item["description"][:200],
                    description=item["description"],
                    issue_type=item["category"],
                    latitude=item["lat"],
                    longitude=item["lng"],
                    address=item["address"],
                    area=item["area"],
                    ai_confidence=0.94,
                    severity=getattr(SeverityLevel, item["severity_level"], SeverityLevel.MEDIUM),
                    severity_score=item["severity_score"],
                    severity_level=item["severity_level"],
                    priority_score=item["priority_score"],
                    priority_level=item["priority_level"],
                    total_reports=item["total_reports"],
                    unique_citizens=item["unique_citizens"],
                    status=item["status"],
                    progress_percentage=100 if item.get("resolved") else 30,
                    latest_update=f"Ticket managed at status {item['status'].value}.",
                    reporter_id=citizen_users[0].id,
                    department_id=dept_map[item["dept_code"]].id,
                    assigned_department=dept_map[item["dept_code"]].name,
                    sla_hours=sla_h,
                    sla_deadline=now + timedelta(hours=sla_h),
                    deadline=now + timedelta(hours=sla_h),
                    resolved_at=now - timedelta(hours=6) if item.get("resolved") else None,
                    resolution_image_path="/uploads/original/sample_infra.jpg" if item.get("resolved") else None,
                    resolution_notes="Repairs completed and inspected by department crew." if item.get("resolved") else None,
                    created_at=now - timedelta(days=2)
                )
                db.add(iss)
                db.flush()

                # Add initial Report
                db.add(Report(
                    report_tracking_id=f"REP-2026-{item['display_id']}-01",
                    issue_id=iss.id,
                    submission_id=str(uuid.uuid4()),
                    reporter_id=citizen_users[0].id,
                    reporter_name=citizen_users[0].full_name,
                    description=item["description"],
                    selected_category=getattr(item["category"], 'value', str(item["category"])),
                    latitude=item["lat"],
                    longitude=item["lng"],
                    address=item["address"],
                    status="accepted",
                    counted=True,
                    link_method="direct_creation",
                    created_at=now - timedelta(days=2)
                ))

                # Add initial Severity Assessment
                db.add(SeverityAssessment(
                    issue_id=iss.id,
                    severity_score=item["severity_score"],
                    severity_level=item["severity_level"],
                    confidence=0.92,
                    risk_factors=json.dumps(["safety_hazard"]),
                    explanation=f"Initial assessment for {item['display_id']}: {item['severity_level']} severity.",
                    model_name="nagarsetu-deterministic-severity-v1",
                    created_at=now - timedelta(days=2)
                ))

        # =========================================================================
        # 5. SEED PENDING DUPLICATE REVIEWS (For Duplicate Review Queue)
        # =========================================================================
        pending_check = db.query(Report).filter(Report.status == "pending_review").first()
        if not pending_check:
            # Medium confidence duplicate candidate matching NG-101
            p_rep1 = Report(
                report_tracking_id="REP-2026-PEND-001",
                suggested_issue_id=ng101.id if ng101 else 1,
                submission_id=str(uuid.uuid4()),
                reporter_id=citizen_users[13].id,
                reporter_name=citizen_users[13].full_name,
                description="Heavy garbage and plastic sacks lying near Rajpura Main Market vegetable corner. Smells bad.",
                selected_category="Garbage Accumulation",
                urgency="normal",
                latitude=30.4845,
                longitude=76.5942,
                gps_accuracy=12.0,
                location_source="gps",
                address="Near Veggie Corner, Main Market, Rajpura",
                status="pending_review",
                counted=False,
                link_method="pending_admin_review",
                created_at=now - timedelta(hours=3)
            )
            db.add(p_rep1)
            db.flush()

            db.add(ReportMedia(
                report_id=p_rep1.id,
                image_url="/uploads/original/sample_infra.jpg",
                image_hash="e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
                perceptual_hash="d0f0e0c0b0a09080",
                media_type="image/jpeg",
                uploaded_at=now - timedelta(hours=3)
            ))

            db.add(ReportMatch(
                report_id=p_rep1.id,
                issue_id=ng101.id if ng101 else 1,
                geo_similarity=0.74,
                text_similarity=0.68,
                visual_similarity=0.62,
                context_similarity=0.85,
                final_score=0.71,
                confidence=0.82,
                ai_reasoning="Moderate similarity (71%) to NG-101. Located ~55m from center of garbage pile. Requires administrator review to confirm if part of same dumping site.",
                model_name="nagarsetu-dedup-v1",
                decision="MEDIUM",
                created_at=now - timedelta(hours=3)
            ))

        db.commit()
        print("[OK] Advanced Seed Database Completed Successfully!")
        print(f"  ✓ Issue NG-101 verified with 12 citizen reports from 10 unique citizens.")
        print(f"  ✓ Issues NG-102 through NG-105 seeded across LOW, HIGH, and CRITICAL severities.")
        print(f"  ✓ Pending duplicate review queue populated.")
        print("=" * 70)

    except Exception as e:
        print(f"Error seeding database: {e}")
        db.rollback()
    finally:
        db.close()


if __name__ == "__main__":
    seed_database()
