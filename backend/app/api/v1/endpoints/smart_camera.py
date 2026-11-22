"""
NagarSetu Smart Camera API — Backend Endpoint
Handles: image upload, Gemini Vision AI analysis, GPS nearby duplicate detection, report submission
"""
import os
import uuid
import base64
import json
import httpx
from datetime import datetime
from typing import Optional, List

from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form, Query
from fastapi.responses import JSONResponse
from sqlalchemy.orm import Session

from app.core.database import get_db
from app.core.config import settings
from app.api.v1.endpoints.auth import get_current_user
from app.models.user import User
from app.models.issue import Issue, IssueStatus, IssueType, SeverityLevel
from app.models.image import IssueImage
from app.services.ai_service import analyze_issue_image
from app.services.duplicate_service import find_intelligent_duplicates, calculate_haversine_distance
from app.services.routing_service import route_issue_to_department
from app.services.priority_service import calculate_priority_score_with_explanation

router = APIRouter()

ALLOWED_IMAGE_TYPES = {"image/jpeg", "image/jpg", "image/png", "image/webp"}
MAX_IMAGE_SIZE_MB = 15
MAX_IMAGE_BYTES = MAX_IMAGE_SIZE_MB * 1024 * 1024

CIVIC_CATEGORIES = [
    "Pothole", "Road Damage", "Garbage Accumulation", "Overflowing Dustbin",
    "Water Leakage", "Drainage Blockage", "Waterlogging",
    "Electrical Wire Hazard", "Open Manhole", "Infrastructure Damage", "Other"
]

GEMINI_CIVIC_PROMPT = """You are an expert civic infrastructure analyst for Indian municipalities.

Analyze this image and determine if it shows a civic infrastructure problem.

Respond ONLY with a JSON object (no markdown, no explanation) in exactly this format:
{
  "is_civic_issue": true or false,
  "issue_category": "one of: Pothole, Road Damage, Garbage Accumulation, Overflowing Dustbin, Water Leakage, Drainage Blockage, Waterlogging, Electrical Wire Hazard, Open Manhole, Infrastructure Damage, Other",
  "issue_title": "short clear title under 60 characters",
  "description": "2-3 sentence description of the specific problem visible",
  "severity": "one of: Low, Medium, High, Critical",
  "confidence": 0.0 to 1.0 as a number,
  "suggested_department": "relevant municipal department name",
  "visual_evidence": "brief note on what visual clues indicate this issue",
  "not_civic_reason": "if is_civic_issue is false, explain why"
}

Be conservative: only mark is_civic_issue=true if you clearly see infrastructure damage or civic problem.
If the image is blurry, irrelevant (selfie, food, interior, etc.) or unclear, set is_civic_issue=false.
"""


def _get_gemini_key() -> Optional[str]:
    return os.getenv("GEMINI_API_KEY") or getattr(settings, "GEMINI_API_KEY", None)


async def _call_gemini_vision(image_bytes: bytes, mime_type: str) -> dict:
    """Call Gemini Vision API with the image and return parsed analysis."""
    api_key = _get_gemini_key()
    if not api_key:
        raise ValueError("GEMINI_API_KEY not configured")

    b64_image = base64.b64encode(image_bytes).decode("utf-8")

    payload = {
        "contents": [{
            "parts": [
                {"text": GEMINI_CIVIC_PROMPT},
                {
                    "inline_data": {
                        "mime_type": mime_type,
                        "data": b64_image
                    }
                }
            ]
        }],
        "generationConfig": {
            "temperature": 0.1,
            "maxOutputTokens": 512,
        }
    }

    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={api_key}"

    async with httpx.AsyncClient(timeout=30.0) as client:
        response = await client.post(url, json=payload)
        response.raise_for_status()
        data = response.json()

    # Extract text from response
    text = data["candidates"][0]["content"]["parts"][0]["text"].strip()

    # Clean up markdown code fences if present
    if text.startswith("```"):
        lines = text.split("\n")
        text = "\n".join(lines[1:-1] if lines[-1] == "```" else lines[1:])

    return json.loads(text)


def _category_to_issue_type(category: str) -> str:
    mapping = {
        "Pothole": IssueType.POTHOLE.value,
        "Road Damage": IssueType.ROAD_DAMAGE.value,
        "Garbage Accumulation": IssueType.GARBAGE.value,
        "Overflowing Dustbin": IssueType.OVERFLOWING_DUSTBIN.value,
        "Water Leakage": IssueType.WATER_LEAKAGE.value,
        "Drainage Blockage": IssueType.DRAINAGE_BLOCKAGE.value,
        "Waterlogging": IssueType.WATERLOGGING.value,
        "Damaged Streetlight": IssueType.STREETLIGHT.value,
        "Electrical Wire Hazard": IssueType.ELECTRICAL_WIRE.value,
        "Open Manhole": IssueType.MANHOLE.value,
        "Infrastructure Damage": IssueType.INFRASTRUCTURE_DAMAGE.value,
        "Other": IssueType.OTHER.value,
    }
    return mapping.get(category, IssueType.OTHER.value)


def _severity_to_level(severity: str) -> str:
    mapping = {
        "Low": SeverityLevel.LOW.value,
        "Medium": SeverityLevel.MODERATE.value,
        "High": SeverityLevel.HIGH.value,
        "Critical": SeverityLevel.CRITICAL.value,
    }
    return mapping.get(severity, SeverityLevel.MODERATE.value)


# ─────────────────────────────────────────────────────────────────────────────
# ENDPOINT 1: Upload & Analyze Image with Gemini Vision
# ─────────────────────────────────────────────────────────────────────────────
@router.post("/analyze", summary="Upload image and get AI civic issue analysis")
async def analyze_camera_image(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Accepts an image upload, calls Gemini Vision AI to detect civic issues,
    and returns structured analysis. No DB record created yet.
    """
    # Validate file type
    if file.content_type not in ALLOWED_IMAGE_TYPES:
        raise HTTPException(
            status_code=400,
            detail=f"Invalid file type '{file.content_type}'. Allowed: JPG, PNG, WEBP"
        )

    # Read and validate size
    image_bytes = await file.read()
    if len(image_bytes) > MAX_IMAGE_BYTES:
        raise HTTPException(
            status_code=413,
            detail=f"Image too large. Maximum size is {MAX_IMAGE_SIZE_MB}MB"
        )
    if len(image_bytes) < 1000:
        raise HTTPException(status_code=400, detail="Image file appears to be empty or corrupt")

    # Save image to disk for later use
    ext = os.path.splitext(file.filename or "image.jpg")[1].lower() or ".jpg"
    unique_name = f"cam_{uuid.uuid4().hex}{ext}"
    save_path = os.path.join(settings.ORIGINAL_IMG_DIR, unique_name)

    with open(save_path, "wb") as f:
        f.write(image_bytes)

    # Try Gemini Vision first
    gemini_result = None
    gemini_error = None
    api_key = _get_gemini_key()

    if api_key:
        try:
            gemini_result = await _call_gemini_vision(image_bytes, file.content_type or "image/jpeg")
        except Exception as e:
            gemini_error = str(e)

    if gemini_result:
        # Use Gemini result
        is_civic = gemini_result.get("is_civic_issue", False)
        category = gemini_result.get("issue_category", "Other")
        confidence = float(gemini_result.get("confidence", 0.80))
        severity = gemini_result.get("severity", "Medium")
        title = gemini_result.get("issue_title", "Civic Infrastructure Issue")
        description = gemini_result.get("description", "")
        department = gemini_result.get("suggested_department", "Municipal Works Department")
        visual_evidence = gemini_result.get("visual_evidence", "")
        not_civic_reason = gemini_result.get("not_civic_reason", "")
        ai_engine = "Gemini 1.5 Flash Vision"
    else:
        # Fallback to existing CV-based analyzer
        cv_result = analyze_issue_image(save_path)
        is_civic = True
        category = cv_result.get("issue_type", "Pothole")
        # Map internal type to display category
        reverse_map = {v: k for k, v in {
            "Pothole": IssueType.POTHOLE.value,
            "Road Damage": IssueType.ROAD_DAMAGE.value,
            "Garbage Accumulation": IssueType.GARBAGE.value,
            "Overflowing Dustbin": IssueType.OVERFLOWING_DUSTBIN.value,
            "Water Leakage": IssueType.WATER_LEAKAGE.value,
            "Drainage Blockage": IssueType.DRAINAGE_BLOCKAGE.value,
            "Waterlogging": IssueType.WATERLOGGING.value,
            "Damaged Streetlight": IssueType.STREETLIGHT.value,
            "Electrical Wire Hazard": IssueType.ELECTRICAL_WIRE.value,
            "Open Manhole": IssueType.MANHOLE.value,
            "Infrastructure Damage": IssueType.INFRASTRUCTURE_DAMAGE.value,
        }.items()}
        category = reverse_map.get(category, "Other")
        confidence = float(cv_result.get("confidence", 0.80))
        sev_val = cv_result.get("severity", SeverityLevel.MODERATE.value)
        sev_map = {
            SeverityLevel.LOW.value: "Low",
            SeverityLevel.MODERATE.value: "Medium",
            SeverityLevel.HIGH.value: "High",
            SeverityLevel.CRITICAL.value: "Critical",
        }
        severity = sev_map.get(sev_val, "Medium")
        title = f"{category} Detected"
        description = f"AI detected a {category.lower()} issue with {int(confidence * 100)}% confidence."
        department = cv_result.get("recommended_department", "Municipal Works Department")
        visual_evidence = "Detected via computer vision edge/color analysis"
        not_civic_reason = ""
        ai_engine = "NagarSetu CV Analyzer (fallback)"

    return {
        "success": True,
        "temp_image_filename": unique_name,
        "image_url": f"/uploads/original/{unique_name}",
        "ai_engine": ai_engine,
        "gemini_available": api_key is not None,
        "gemini_error": gemini_error,
        "analysis": {
            "is_civic_issue": is_civic,
            "issue_category": category,
            "issue_title": title,
            "description": description,
            "severity": severity,
            "confidence": confidence,
            "confidence_percent": int(confidence * 100),
            "suggested_department": department,
            "visual_evidence": visual_evidence,
            "not_civic_reason": not_civic_reason,
        }
    }


# ─────────────────────────────────────────────────────────────────────────────
# ENDPOINT 2: Find Nearby Duplicate Issues
# ─────────────────────────────────────────────────────────────────────────────
@router.get("/nearby-issues", summary="Find similar/duplicate civic issues near GPS coordinates")
def find_nearby_issues(
    latitude: float = Query(..., ge=-90, le=90),
    longitude: float = Query(..., ge=-180, le=180),
    category: Optional[str] = Query(None),
    radius_meters: float = Query(default=100.0, le=500.0),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Returns existing open/in-progress civic issues within the given radius.
    Used for duplicate detection before creating a new report.
    """
    # Query all active issues
    active_issues = db.query(Issue).filter(
        Issue.status.in_([IssueStatus.OPEN, IssueStatus.ACCEPTED, IssueStatus.IN_PROGRESS]),
        Issue.latitude.isnot(None),
        Issue.longitude.isnot(None)
    ).all()

    nearby = []
    for issue in active_issues:
        try:
            dist = calculate_haversine_distance(
                latitude, longitude,
                float(issue.latitude), float(issue.longitude)
            )
        except Exception:
            continue

        if dist <= radius_meters:
            # Category similarity score
            cat_match = False
            if category:
                issue_cat = (issue.issue_type or "").lower().replace("_", " ")
                search_cat = category.lower().replace("_", " ")
                cat_match = (
                    issue_cat == search_cat or
                    issue_cat in search_cat or
                    search_cat in issue_cat
                )

            # First image
            first_image = None
            if issue.images:
                first_image = f"/uploads/original/{issue.images[0].filename}"

            nearby.append({
                "id": issue.id,
                "display_id": issue.display_id or f"NG-{issue.id}",
                "title": issue.title,
                "issue_type": issue.issue_type,
                "status": issue.status.value if issue.status else "open",
                "latitude": float(issue.latitude),
                "longitude": float(issue.longitude),
                "address": issue.address or "",
                "distance_meters": round(dist, 1),
                "distance_text": f"{int(dist)}m away" if dist < 1000 else f"{dist/1000:.1f}km away",
                "report_count": issue.report_count or 1,
                "image_url": first_image,
                "created_at": issue.created_at.isoformat() if issue.created_at else None,
                "category_match": cat_match,
                "similarity_score": round(
                    (1 - dist / radius_meters) * 0.7 + (0.3 if cat_match else 0), 2
                )
            })

    # Sort by similarity score descending
    nearby.sort(key=lambda x: x["similarity_score"], reverse=True)

    return {
        "count": len(nearby),
        "radius_meters": radius_meters,
        "nearby_issues": nearby[:5]  # Top 5 most similar
    }


# ─────────────────────────────────────────────────────────────────────────────
# ENDPOINT 3: Submit New Report from Smart Camera
# ─────────────────────────────────────────────────────────────────────────────
@router.post("/submit", summary="Submit a new civic report from Smart Camera")
def submit_camera_report(
    title: str = Form(...),
    description: str = Form(...),
    category: str = Form(...),
    severity: str = Form(...),
    latitude: float = Form(...),
    longitude: float = Form(...),
    address: str = Form(default=""),
    temp_image_filename: str = Form(...),
    ai_confidence: float = Form(default=0.0),
    ai_engine: str = Form(default=""),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Creates a new civic issue from a Smart Camera report.
    Links the already-uploaded temp image to the new issue.
    """
    # Validate the temp image exists
    image_path = os.path.join(settings.ORIGINAL_IMG_DIR, temp_image_filename)
    if not os.path.exists(image_path):
        raise HTTPException(status_code=400, detail="Uploaded image not found. Please re-upload.")

    # Map category and severity to internal types
    issue_type = _category_to_issue_type(category)
    severity_level = _severity_to_level(severity)

    # Route to department
    department = route_issue_to_department(issue_type, db)

    # Priority scoring
    priority_data = calculate_priority_score_with_explanation(
        issue_type=issue_type,
        confidence=ai_confidence or 0.80,
        defect_area_ratio=0.10,
        duplicate_count=0,
        age_hours=0,
    )

    # Generate display ID
    issue_code = f"NS-{uuid.uuid4().hex[:6].upper()}"

    # Create the issue
    new_issue = Issue(
        display_id=issue_code,
        title=title[:200],
        description=description[:2000],
        issue_type=issue_type,
        severity=severity_level,
        severity_level=severity_level,
        severity_score={"Low": 25, "Medium": 50, "High": 75, "Critical": 95}.get(severity, 50),
        status=IssueStatus.OPEN,
        latitude=latitude,
        longitude=longitude,
        address=address[:300] if address else f"GPS ({latitude:.4f}, {longitude:.4f})",
        reporter_id=current_user.id,
        department_id=department.id if department else None,
        ai_confidence=ai_confidence,
        ai_analysis_engine=ai_engine or "NagarSetu Smart Camera",
        priority_score=priority_data.get("priority_score", 50.0),
        priority_level=priority_data.get("priority_level", "MODERATE"),
        report_count=1,
        created_at=datetime.utcnow(),
        updated_at=datetime.utcnow(),
    )

    db.add(new_issue)
    db.flush()  # Get ID without committing

    # Attach image
    image_record = IssueImage(
        issue_id=new_issue.id,
        filename=temp_image_filename,
        original_filename=temp_image_filename,
        file_path=image_path,
        uploaded_by_id=current_user.id,
        created_at=datetime.utcnow(),
    )
    db.add(image_record)
    db.commit()
    db.refresh(new_issue)

    return {
        "success": True,
        "message": "Report submitted successfully via Smart Camera",
        "issue": {
            "id": new_issue.id,
            "display_id": new_issue.display_id,
            "title": new_issue.title,
            "status": new_issue.status.value,
            "priority_score": new_issue.priority_score,
            "department": department.name if department else "Municipal Works",
            "created_at": new_issue.created_at.isoformat(),
        }
    }


# ─────────────────────────────────────────────────────────────────────────────
# ENDPOINT 4: Add Supporting Evidence to Existing Issue
# ─────────────────────────────────────────────────────────────────────────────
@router.post("/support-issue/{issue_id}", summary="Add supporting evidence to existing issue")
def add_supporting_evidence(
    issue_id: int,
    temp_image_filename: str = Form(...),
    note: str = Form(default=""),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    When user confirms "this is the same issue", increment report count
    and optionally attach new photo evidence. Atomic update to prevent race conditions.
    """
    issue = db.query(Issue).filter(Issue.id == issue_id).with_for_update().first()
    if not issue:
        raise HTTPException(status_code=404, detail="Issue not found")

    # Validate image if provided
    image_path = os.path.join(settings.ORIGINAL_IMG_DIR, temp_image_filename)
    if temp_image_filename and os.path.exists(image_path):
        image_record = IssueImage(
            issue_id=issue.id,
            filename=temp_image_filename,
            original_filename=temp_image_filename,
            file_path=image_path,
            uploaded_by_id=current_user.id,
            created_at=datetime.utcnow(),
        )
        db.add(image_record)

    # Atomic increment
    old_count = issue.report_count or 1
    issue.report_count = old_count + 1
    issue.updated_at = datetime.utcnow()

    db.commit()
    db.refresh(issue)

    return {
        "success": True,
        "message": f"Your report added as supporting evidence. This issue now has {issue.report_count} reports.",
        "issue_id": issue.id,
        "display_id": issue.display_id,
        "new_report_count": issue.report_count,
    }
