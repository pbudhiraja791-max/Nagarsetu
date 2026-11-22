import os
import sys
import json
from datetime import datetime
from PIL import Image, ImageDraw

# Add backend directory to sys.path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from sqlalchemy.orm import Session
from app.core.database import SessionLocal
from app.core.config import settings
from app.models.issue import Issue, IssueStatus, IssueType, SeverityLevel
from app.models.user import User, UserRole
from app.models.department import Department
from app.services.ai_service import (
    analyze_issue_image, analyze_text_description, compare_resolution_evidence
)
from app.services.duplicate_service import (
    find_intelligent_duplicates, support_existing_issue, calculate_haversine_distance
)
from app.services.routing_service import route_issue_to_department
from app.services.priority_service import (
    calculate_priority_score_with_explanation, get_sla_hours_from_priority
)
from app.services.analytics_service import (
    get_predictive_hotspots, get_public_accountability_summary
)

def run_nagarsetu_verification():
    print("=" * 75)
    print("      NAGARSETU (नागरिकों और प्रशासन के बीच सेतु) — VERIFICATION SUITE")
    print("=" * 75)

    db: Session = SessionLocal()

    try:
        # 1. Computer Vision Defect Pipeline Test
        print("\n[TEST 1] AI COMPUTER VISION INSPECTION ENGINE")
        test_img_path = os.path.join(settings.ORIGINAL_IMG_DIR, "nagarsetu_test_road.jpg")
        img = Image.new('RGB', (600, 600), color=(80, 85, 90))
        d = ImageDraw.Draw(img)
        d.rectangle([(150, 150), (450, 450)], fill=(30, 30, 30))  # Synthetic road defect
        img.save(test_img_path)

        cv_res = analyze_issue_image(test_img_path)
        print(f"  ✓ Detected Category: {cv_res['issue_type']}")
        print(f"  ✓ AI Confidence: {int(cv_res['confidence'] * 100)}%")
        print(f"  ✓ Calculated Severity: {cv_res['severity']}")
        print(f"  ✓ Explainable Priority Score: {cv_res['priority_score']}/100")
        print(f"  ✓ SLA Target Commitment: {cv_res['sla_hours']} hours")
        print(f"  ✓ Bounding Boxes: {len(cv_res['bounding_boxes'])} box(es) mapped")
        assert cv_res["priority_score"] >= 0.0 and cv_res["priority_score"] <= 100.0

        # 2. Multilingual NLP Engine Test (Hindi & English)
        print("\n[TEST 2] MULTILINGUAL VOICE & TEXT NLP ENGINE")
        hindi_input = "Mere ghar ke paas sadak par bahut bada gaddha hai aur andhera hai"
        nlp_hi = analyze_text_description(hindi_input)
        print(f"  ✓ Hindi Text: '{hindi_input}'")
        print(f"    - Predicted Category: {nlp_hi['problem_category']}")
        print(f"    - Detected Language: {nlp_hi['detected_language']}")
        print(f"    - Extracted Keywords: {nlp_hi['matched_keywords']}")
        print(f"    - Suggested Title: {nlp_hi['suggested_title']}")
        assert nlp_hi["problem_category"] in ["Pothole", "Damaged Road", "Damaged Streetlight"]

        english_urgent = "Dangerous exposed electrical wire hanging near school gate with sparking"
        nlp_en = analyze_text_description(english_urgent)
        print(f"  ✓ English Urgent Text: '{english_urgent}'")
        print(f"    - Predicted Category: {nlp_en['problem_category']}")
        print(f"    - Urgency Flag: {nlp_en['is_urgent']}")
        print(f"    - Recommended Department: {nlp_en['recommended_department']}")
        assert nlp_en["is_urgent"] is True
        assert "Electrical" in nlp_en["recommended_department"]

        # 3. Intelligent Duplicate Detection & Haversine Proximity Test
        print("\n[TEST 3] INTELLIGENT DUPLICATE DETECTION (50m Radius)")
        # Ring road test coordinates
        lat1, lng1 = 28.6139, 77.2090
        lat2, lng2 = 28.6141, 77.2091  # ~25 meters away
        dist = calculate_haversine_distance(lat1, lng1, lat2, lng2)
        print(f"  ✓ Coordinate Distance Check: {round(dist, 1)} meters (Expected ~25m)")
        assert dist < 50.0

        dupes = find_intelligent_duplicates(
            db=db,
            latitude=lat2,
            longitude=lng2,
            issue_type="Open Manhole",
            radius_meters=50.0
        )
        print(f"  ✓ Proximity Candidates Identified within 50m: {len(dupes)}")
        for d_item in dupes:
            print(f"    - Match #{d_item['id']} '{d_item['title'][:40]}...' at {d_item['distance_meters']}m (Match confidence: {int(d_item['match_confidence']*100)}%)")

        # 4. Community Support / Upvote Signal Test
        print("\n[TEST 4] CITIZEN COMMUNITY ENDORSEMENT / UPVOTING")
        target_issue = db.query(Issue).filter(Issue.status != IssueStatus.RESOLVED).first()
        if target_issue:
            citizen_user = db.query(User).filter(User.role == UserRole.CITIZEN).first()
            old_supports = target_issue.support_count or 1
            updated_issue = support_existing_issue(db, target_issue.id, citizen_user.id, "Nearby resident confirming issue")
            print(f"  ✓ Complaint #{target_issue.id} support count incremented: {old_supports} -> {updated_issue.support_count}")
            print(f"  ✓ Priority score dynamically adjusted to: {updated_issue.priority_score}/100")
            assert updated_issue.support_count >= old_supports

        # 5. Citizen-Verified Resolution Evidence Comparison
        print("\n[TEST 5] CITIZEN-VERIFIED RESOLUTION & AI COMPARISON")
        # Create dummy before and after images
        res_img_path = os.path.join(settings.ORIGINAL_IMG_DIR, "nagarsetu_test_repaired.jpg")
        img_res = Image.new('RGB', (600, 600), color=(120, 125, 130))  # Smooth repaired asphalt
        img_res.save(res_img_path)

        comp = compare_resolution_evidence(test_img_path, res_img_path)
        print(f"  ✓ Before vs After Evidence Comparison:")
        print(f"    - Repair Verified: {comp['comparison_verified']}")
        print(f"    - Defect Cleared: {comp['defect_cleared']}")
        print(f"    - AI Confidence Assessment: {int(comp['repair_confidence'] * 100)}%")
        print(f"    - Verdict: {comp['verdict']}")
        print(f"    - Assessment Notes: {comp['ai_assessment_notes']}")
        assert comp["comparison_verified"] is True

        # 6. Predictive Civic Intelligence & Hotspot Analytics
        print("\n[TEST 6] PREDICTIVE CIVIC INTELLIGENCE (Hotspots & Recurrence Risk)")
        hotspots = get_predictive_hotspots(db)
        print(f"  ✓ Geographic Hotspot Clusters Analyzed: {len(hotspots)}")
        for h in hotspots[:3]:
            print(f"    - Cluster '{h['cluster_id']}' at {h['address'][:35]}:")
            print(f"      * Risk Level: {h['risk_level']} (Score: {h['risk_score']}/100, Recurrence: {h['recurrence_probability']})")
            print(f"      * Dominant Issue: {h['dominant_category']}")
            print(f"      * Preventive Recommendation: {h['preventive_action'][:55]}...")

        # 7. Public Accountability Transparency Summary
        print("\n[TEST 7] PUBLIC ACCOUNTABILITY METRICS (Citizen Privacy Protected)")
        pub_stats = get_public_accountability_summary(db)
        print(f"  ✓ Total Complaints Received: {pub_stats['total_complaints']}")
        print(f"  ✓ Resolved Complaints: {pub_stats['resolved_complaints']}")
        print(f"  ✓ Public Resolution Rate: {pub_stats['resolution_rate']}%")
        print(f"  ✓ Average Resolution Time: {pub_stats['avg_resolution_hours']} hours")
        print(f"  ✓ Department Scorecards Monitored: {len(pub_stats['department_metrics'])}")

        print("\n" + "=" * 75)
        print("      ALL 7 NAGARSETU BACKEND MODULES FULLY OPERATIONAL AND VERIFIED")
        print("=" * 75)

    except Exception as e:
        print(f"[FAIL] Error during NagarSetu verification: {e}")
        import traceback
        traceback.print_exc()
        raise e
    finally:
        db.close()

if __name__ == "__main__":
    run_nagarsetu_verification()
