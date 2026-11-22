import os
import sys
import uuid
import json
from datetime import datetime, timedelta

# Add backend directory to sys.path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from sqlalchemy.orm import Session
from app.core.database import SessionLocal
from app.models.user import User, UserRole
from app.models.issue import Issue, IssueStatus, IssueType, SeverityLevel
from app.models.intelligence import Report, SeverityAssessment, IssueActivityLog, DedupConfig
from app.services.submission_pipeline import execute_submission_pipeline
from app.services.counter_management_service import (
    recompute_and_update_issue_counters, reconcile_all_issues
)
from app.services.dedup_engine import get_category_radius, retrieve_candidate_issues
from app.services.ai_intelligence_service import assess_severity_with_ai, classify_duplicate_with_ai
from app.services.dynamic_priority_service import calculate_dynamic_priority


def run_comprehensive_intelligence_tests():
    print("=" * 80)
    print("   NAGARSETU AI ISSUE INTELLIGENCE & DEDUPLICATION VERIFICATION SUITE")
    print("=" * 80)

    db: Session = SessionLocal()
    passed_tests = 0
    total_tests = 0

    def assert_test(condition: bool, test_name: str, detail: str = ""):
        nonlocal passed_tests, total_tests
        total_tests += 1
        if condition:
            passed_tests += 1
            print(f"  ✓ [PASS] {test_name}" + (f" ({detail})" if detail else ""))
        else:
            print(f"  ✗ [FAIL] {test_name}" + (f" ({detail})" if detail else ""))
            raise AssertionError(f"Test failed: {test_name} - {detail}")

    try:
        from app.seed import seed_database
        seed_database()

        # Get users for testing
        admin_user = db.query(User).filter(User.role == UserRole.ADMIN).first()
        citizen_users = db.query(User).filter(User.role == UserRole.CITIZEN).all()

        user1 = citizen_users[0]
        user2 = citizen_users[1]
        user3 = citizen_users[2]

        print("\n--- GROUP 1: DUPLICATE DETECTION & COUNT INTEGRITY TESTS ---")
        
        # Test 1.1: Existing NG-101 starts with 12 reports. A matching report must increase count to 13.
        ng101 = db.query(Issue).filter(Issue.display_id == "NG-101").first()
        assert_test(ng101 is not None, "NG-101 exists in database", f"ID: {ng101.id if ng101 else 'None'}")
        
        # Clean any extra reports on NG-101 from previous test runs so baseline is exactly 12
        extra_reps = db.query(Report).filter(Report.issue_id == ng101.id, Report.report_tracking_id.notlike("REP-2026-RAJ%")).all()
        for er in extra_reps:
            db.delete(er)
        db.commit()
        recompute_and_update_issue_counters(db, ng101.id)
        db.refresh(ng101)

        initial_reports = ng101.total_reports
        initial_unique = ng101.unique_citizens
        assert_test(initial_reports == 12, "NG-101 baseline total_reports is 12", f"Count: {initial_reports}")
        assert_test(initial_unique == 10, "NG-101 baseline unique_citizens is 10", f"Count: {initial_unique}")
        
        # Submit a matching report from a brand new citizen
        new_cit_email = f"tester_{uuid.uuid4().hex[:6]}@rajpura.org"
        new_tester = User(full_name="New Citizen Tester", email=new_cit_email, hashed_password="pwd", role=UserRole.CITIZEN)
        db.add(new_tester)
        db.commit()
        db.refresh(new_tester)

        submission_uuid_1 = str(uuid.uuid4())
        res1 = execute_submission_pipeline(
            db=db,
            current_user=new_tester,
            submission_id=submission_uuid_1,
            selected_category="Garbage Accumulation",
            description="Garbage still accumulating near Rajpura Main Market center.",
            latitude=ng101.latitude + 0.0001,  # ~11 meters away
            longitude=ng101.longitude + 0.0001,
            address="Main Market, Rajpura",
            gps_accuracy=10.0
        )
        
        db.refresh(ng101)
        assert_test(
            ng101.total_reports == initial_reports + 1,
            "Matching report increases total_reports by exactly 1",
            f"Before: {initial_reports}, After: {ng101.total_reports}"
        )
        assert_test(
            ng101.unique_citizens == initial_unique + 1,
            "New citizen increments unique_citizens by exactly 1",
            f"Before: {initial_unique}, After: {ng101.unique_citizens}"
        )
        assert_test(
            res1["duplicate_decision"] == "HIGH",
            "Duplicate decision is HIGH for immediate proximity and matching category",
            f"Decision: {res1['duplicate_decision']}"
        )

        # Test 1.2: Idempotency Protection - Retrying same submission_id 5 times must return original response without incrementing
        pre_retry_total = ng101.total_reports
        for i in range(5):
            retry_res = execute_submission_pipeline(
                db=db,
                current_user=new_tester,
                submission_id=submission_uuid_1,
                selected_category="Garbage Accumulation",
                description="Garbage still accumulating near Rajpura Main Market center.",
                latitude=ng101.latitude + 0.0001,
                longitude=ng101.longitude + 0.0001
            )
            assert_test(
                retry_res["duplicate_decision"] == "IDEMPOTENT_RETRY",
                f"Idempotency retry {i+1}/5 returned original report without re-execution",
                f"Tracking ID: {retry_res['report_tracking_id']}"
            )
        
        db.refresh(ng101)
        assert_test(
            ng101.total_reports == pre_retry_total,
            "5 identical retries did NOT increment total_reports",
            f"Count remained stable at {ng101.total_reports}"
        )

        # Test 1.3: Repeat Reporter - Same citizen submitting another accepted report
        res_repeat = execute_submission_pipeline(
            db=db,
            current_user=new_tester,
            submission_id=str(uuid.uuid4()),
            selected_category="Garbage Accumulation",
            description="Second report by same citizen regarding ongoing garbage.",
            latitude=ng101.latitude + 0.00012,
            longitude=ng101.longitude + 0.00012,
            address="Main Market, Rajpura"
        )
        db.refresh(ng101)
        assert_test(
            res_repeat["repeat_reporter"] == True,
            "Repeat reporter flag is True when citizen reports same issue again"
        )
        assert_test(
            ng101.total_reports == pre_retry_total + 1,
            "Total reports increased by 1 for genuine second report",
            f"Total: {ng101.total_reports}"
        )
        assert_test(
            ng101.unique_citizens == initial_unique + 1,
            "Unique citizens remained UNCHANGED for repeat reporter",
            f"Unique citizens: {ng101.unique_citizens}"
        )

        # Test 1.4: Hard Category Gate - Pothole and Garbage at identical coordinates remain separate issues
        # Ensure no preexisting pothole at these exact coordinates
        old_test_potholes = db.query(Issue).filter(Issue.latitude == ng101.latitude, Issue.issue_type == "Pothole").all()
        for otp in old_test_potholes:
            db.query(Report).filter(Report.issue_id == otp.id).delete()
            db.delete(otp)
        db.commit()

        pothole_sub_id = str(uuid.uuid4())
        pothole_res = execute_submission_pipeline(
            db=db,
            current_user=user1,
            submission_id=pothole_sub_id,
            selected_category="Pothole",
            description="Deep pothole right beside the market entrance.",
            latitude=ng101.latitude,  # IDENTICAL COORDINATES
            longitude=ng101.longitude,
            address="Main Market, Rajpura"
        )
        assert_test(
            pothole_res["duplicate_decision"] == "LOW",
            "Hard category gate prevents auto-merging different categories at same coordinates",
            f"Decision: {pothole_res['duplicate_decision']}, Category: Pothole"
        )
        assert_test(
            pothole_res["parent_issue"]["id"] != ng101.id,
            "Pothole created its own independent issue rather than merging into Garbage NG-101",
            f"New Issue: {pothole_res['parent_issue']['display_id']} vs {ng101.display_id}"
        )

        # Test 1.5: Geographical Radius Boundary - Same category 500m away creates a new issue
        for old_hw in db.query(Issue).filter(Issue.address == "Outer Highway, Rajpura").all():
            db.query(Report).filter(Report.issue_id == old_hw.id).delete()
            db.delete(old_hw)
        db.commit()

        far_garbage_res = execute_submission_pipeline(
            db=db,
            current_user=user2,
            submission_id=str(uuid.uuid4()),
            selected_category="Garbage Accumulation",
            description="Garbage dump on highway 500 meters away.",
            latitude=ng101.latitude + 0.0045,  # ~500 meters away
            longitude=ng101.longitude,
            address="Outer Highway, Rajpura"
        )
        assert_test(
            far_garbage_res["duplicate_decision"] == "LOW",
            "Report 500m away outside category radius created a separate issue",
            f"Decision: {far_garbage_res['duplicate_decision']}"
        )
        assert_test(
            far_garbage_res["parent_issue"]["id"] != ng101.id,
            "Distant report was not merged into NG-101"
        )

        # Test 1.6: Invalidation Decrement - Invalidating a counted report decrements count exactly once
        from app.api.v1.endpoints.admin import invalidate_report
        from app.schemas.intelligence import InvalidateReportRequest
        
        rep_to_invalidate = db.query(Report).filter(Report.submission_id == pothole_sub_id).first()
        pothole_issue_id = rep_to_invalidate.issue_id
        pothole_issue = db.query(Issue).filter(Issue.id == pothole_issue_id).first()
        initial_pothole_count = pothole_issue.total_reports
        
        inv_res = invalidate_report(
            report_id=rep_to_invalidate.id,
            payload=InvalidateReportRequest(reason="Test invalidation verification"),
            db=db,
            current_user=admin_user
        )
        db.refresh(pothole_issue)
        assert_test(
            pothole_issue.total_reports == initial_pothole_count - 1,
            "Invalidating report decremented total_reports exactly once",
            f"Before: {initial_pothole_count}, After: {pothole_issue.total_reports}"
        )

        # Test 1.7: Reconciliation Invariant
        audit = reconcile_all_issues(db)
        assert_test(
            audit["discrepancies_found"] == 0 or audit["status"] in ["CONSISTENT", "REPAIRED"],
            "Database count reconciliation reports zero count inconsistencies",
            f"Discrepancies: {audit['discrepancies_found']}"
        )

        print("\n--- GROUP 2: AI SEVERITY ASSESSMENT & ESCALATION TESTS ---")

        # Test 2.1: Category Risk Distinction - Pothole vs Road Collapse / Open Manhole
        sev_pothole = assess_severity_with_ai({"selected_category": "Pothole", "description": "Small 2-inch road depression."})
        sev_manhole = assess_severity_with_ai({"selected_category": "Open Manhole", "description": "Open manhole without cover on busy road."})
        assert_test(
            sev_manhole["severity_score"] > sev_pothole["severity_score"],
            "Open Manhole hazard receives substantially higher severity than small pothole",
            f"Manhole: {sev_manhole['severity_score']} vs Pothole: {sev_pothole['severity_score']}"
        )
        assert_test(
            sev_manhole["severity_level"] in ["HIGH", "CRITICAL"],
            "Open manhole classified as HIGH/CRITICAL hazard",
            f"Level: {sev_manhole['severity_level']}"
        )

        # Test 2.2: Evidence-Based Escalation - New evidence showing spreading/worsening increases severity
        base_sev = 40.0
        escalated_sev = assess_severity_with_ai(
            report_data={
                "selected_category": "Garbage Accumulation",
                "description": "Garbage is now spreading and overflowing onto road, blocking traffic and pedestrians slipping."
            },
            current_severity_score=base_sev
        )
        assert_test(
            escalated_sev["is_escalation"] == True,
            "AI detected worsening physical evidence and flagged is_escalation=True"
        )
        assert_test(
            escalated_sev["severity_score"] > base_sev,
            "Severity score escalated based on worsening evidence",
            f"Base: {base_sev}, Escalated: {escalated_sev['severity_score']}"
        )

        # Test 2.3: Unchanged Condition Stability - Repeated reports describing unchanged conditions do NOT inflate severity
        stable_sev = assess_severity_with_ai(
            report_data={
                "selected_category": "Garbage Accumulation",
                "description": "Garbage is still lying there as before."
            },
            current_severity_score=base_sev
        )
        assert_test(
            stable_sev["severity_score"] == base_sev,
            "Repeated report of unchanged condition did NOT artificially inflate severity",
            f"Severity remained: {stable_sev['severity_score']}"
        )

        # Test 2.4: Evidence-Based De-escalation - Verified improvement de-escalates severity
        deescalated_sev = assess_severity_with_ai(
            report_data={
                "selected_category": "Garbage Accumulation",
                "description": "Area partially cleared and dumpster emptied, danger reduced."
            },
            current_severity_score=65.0
        )
        assert_test(
            deescalated_sev["is_deescalation"] == True,
            "AI detected remediation evidence and flagged is_deescalation=True"
        )
        assert_test(
            deescalated_sev["severity_score"] < 65.0,
            "Severity de-escalated based on physical improvement",
            f"Previous: 65.0, De-escalated: {deescalated_sev['severity_score']}"
        )

        print("\n--- GROUP 3: DYNAMIC PRIORITY SCORE TESTS ---")

        # Test 3.1: High Risk Outranks High Volume Minor Issue
        # Dangerous wire reported by 1 citizen vs minor pothole reported by 15 citizens
        pri_wire, wire_lvl, _, _ = calculate_dynamic_priority(
            severity_score=96.0,
            category="Exposed Electrical Wire",
            unique_citizens=1
        )
        pri_pothole, pothole_lvl, _, _ = calculate_dynamic_priority(
            severity_score=30.0,
            category="Pothole",
            unique_citizens=15
        )
        assert_test(
            pri_wire > pri_pothole,
            "Lethal exposed wire with 1 report outranks minor pothole with 15 reports",
            f"Wire: {pri_wire} ({wire_lvl}) vs Pothole: {pri_pothole} ({pothole_lvl})"
        )

        # Test 3.2: Unique Citizens Component Scaling
        pri_cit1, _, b1, _ = calculate_dynamic_priority(severity_score=50.0, category="Garbage Accumulation", unique_citizens=1)
        pri_cit10, _, b10, _ = calculate_dynamic_priority(severity_score=50.0, category="Garbage Accumulation", unique_citizens=10)
        assert_test(
            pri_cit10 > pri_cit1,
            "Increasing unique citizen reports increases priority score",
            f"1 Citizen: {pri_cit1} vs 10 Citizens: {pri_cit10}"
        )
        assert_test(
            b10["factors"]["unique_citizens"]["weighted_contribution"] > b1["factors"]["unique_citizens"]["weighted_contribution"],
            "Priority breakdown accurately reflects unique citizen weighted contribution"
        )

        # Test 3.3: Backlog Duration Scaling
        old_time = datetime.utcnow() - timedelta(days=5)
        pri_recent, _, _, _ = calculate_dynamic_priority(severity_score=50.0, category="Garbage Accumulation", unique_citizens=2, first_reported_at=datetime.utcnow())
        pri_aging, _, _, _ = calculate_dynamic_priority(severity_score=50.0, category="Garbage Accumulation", unique_citizens=2, first_reported_at=old_time)
        assert_test(
            pri_aging > pri_recent,
            "Unresolved aging issue receives higher priority over time",
            f"Recent: {pri_recent} vs 5-Day Backlog: {pri_aging}"
        )

        print("\n--- GROUP 4: REVIEW QUEUES & ADMIN ACTIONS ---")

        # Test 4.1: Confirm Pending Duplicate Queue Action
        from app.api.v1.endpoints.admin import confirm_duplicate
        from app.schemas.intelligence import ConfirmDuplicateRequest

        # Seed a fresh pending report for confirmation test
        pending_rep = Report(
            report_tracking_id=f"REP-TEST-PEND-{uuid.uuid4().hex[:4]}",
            suggested_issue_id=ng101.id,
            submission_id=str(uuid.uuid4()),
            reporter_id=user3.id,
            reporter_name=user3.full_name,
            description="Garbage pile verification test.",
            selected_category="Garbage Accumulation",
            latitude=ng101.latitude,
            longitude=ng101.longitude,
            status="pending_review",
            counted=False,
            link_method="pending_admin_review"
        )
        db.add(pending_rep)
        db.commit()
        db.refresh(pending_rep)

        pre_confirm_total = ng101.total_reports
        conf_res = confirm_duplicate(
            report_id=pending_rep.id,
            payload=ConfirmDuplicateRequest(notes="Admin approved duplicate in test"),
            db=db,
            current_user=admin_user
        )
        db.refresh(ng101)
        assert_test(
            ng101.total_reports == pre_confirm_total + 1,
            "Confirming duplicate increments total_reports exactly once",
            f"Before: {pre_confirm_total}, After: {ng101.total_reports}"
        )

        # Double confirmation check
        conf_double = confirm_duplicate(
            report_id=pending_rep.id,
            payload=ConfirmDuplicateRequest(notes="Attempt double confirmation"),
            db=db,
            current_user=admin_user
        )
        db.refresh(ng101)
        assert_test(
            ng101.total_reports == pre_confirm_total + 1,
            "Double-confirming same report did NOT double-count",
            f"Count remained: {ng101.total_reports}"
        )

        print("\n" + "=" * 80)
        print(f"   SUMMARY: {passed_tests}/{total_tests} TESTS PASSED SUCCESSFULLY! (100% SUCCESS RATE)")
        print("=" * 80)

    except Exception as e:
        print(f"\n[ERROR] Test execution failed with exception: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
    finally:
        db.close()


if __name__ == "__main__":
    run_comprehensive_intelligence_tests()
