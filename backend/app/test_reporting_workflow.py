import os
import sys
import io

# Add backend directory to sys.path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from PIL import Image
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_full_issue_reporting_workflow():
    print("=" * 60)
    print("      CIVICSENSE AI — ISSUE REPORTING WORKFLOW TEST")
    print("=" * 60)

    # 1. Login Citizen to obtain JWT token
    login_res = client.post("/api/v1/auth/login", json={
        "email": "citizen.test@civicsense.ai",
        "password": "Password@123"
    })
    assert login_res.status_code == 200, f"Login failed: {login_res.text}"
    token = login_res.json()["access_token"]
    headers = {"Authorization": f"Bearer {token}"}
    print("[+] 1. Citizen Authentication: SUCCESS (JWT Bearer Token obtained)")

    # 2. Prepare synthetic image upload
    img_byte_arr = io.BytesIO()
    test_img = Image.new('RGB', (640, 640), color=(100, 150, 200))
    test_img.save(img_byte_arr, format='JPEG')
    img_byte_arr.seek(0)

    # 3. Call POST /api/v1/issues/analyze-image
    files = {"file": ("report_test.jpg", img_byte_arr, "image/jpeg")}
    ai_res = client.post("/api/v1/issues/analyze-image", files=files, headers=headers)
    assert ai_res.status_code == 200, f"AI Analysis failed: {ai_res.text}"
    ai_data = ai_res.json()

    print("[+] 2. AI Image Analysis & Bounding Box Inspection: SUCCESS")
    print(f"    - Detected Class: {ai_data['issue_type']}")
    print(f"    - AI Confidence: {ai_data['confidence'] * 100}%")
    print(f"    - Severity: {ai_data['severity']}")
    print(f"    - Initial Priority Score: {ai_data['priority_score']} / 100")
    print(f"    - Recommended Department: {ai_data['recommended_department']} ({ai_data['recommended_department_code']})")
    print(f"    - Original Image URL: {ai_data['original_image_url']}")
    print(f"    - Annotated Image URL: {ai_data['annotated_image_url']}")

    # 4. Submit Issue Report to POST /api/v1/issues
    issue_payload = {
        "title": f"Hazardous {ai_data['issue_type']} on Main Street",
        "description": "Deep defect reported via automated AI workflow test.",
        "issue_type": ai_data["issue_type"],
        "latitude": 28.6139,
        "longitude": 77.2090,
        "address": "Main Street Crossing, Sector 4",
        "original_image_url": ai_data["original_image_url"],
        "annotated_image_url": ai_data["annotated_image_url"],
        "ai_confidence": ai_data["confidence"],
        "severity": ai_data["severity"],
        "priority_score": ai_data["priority_score"],
        "bounding_box_json": str(ai_data["bounding_boxes"])
    }

    create_res = client.post("/api/v1/issues", json=issue_payload, headers=headers)
    assert create_res.status_code == 201, f"Issue submission failed: {create_res.text}"
    created_issue = create_res.json()

    print("[+] 3. Issue Submission & Database Record Creation: SUCCESS")
    print(f"    - Created Issue ID: #{created_issue['id']}")
    print(f"    - Title: {created_issue['title']}")
    print(f"    - Status: {created_issue['status']}")
    print(f"    - Priority Score: {created_issue['priority_score']} / 100")
    print(f"    - Assigned Dept ID: {created_issue['department_id']}")
    print(f"    - Images Linked: {len(created_issue['images'])}")
    print(f"    - History Log Entries: {len(created_issue['status_history'])}")

    print("=" * 60)
    print("      ISSUE REPORTING WORKFLOW VERIFIED SUCCESSFULLY")
    print("=" * 60)

if __name__ == "__main__":
    test_full_issue_reporting_workflow()
