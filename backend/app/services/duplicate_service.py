import math
import re
from datetime import datetime, timedelta
from typing import List, Dict, Any, Optional
from sqlalchemy.orm import Session
from app.models.issue import Issue, IssueStatus, ComplaintSupport
from app.models.duplicate import DuplicateIssueRelation
from app.core.config import settings

EARTH_RADIUS_METERS = 6371000.0  # Earth radius in meters

def calculate_haversine_distance(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    """Calculates great-circle distance between two GPS coordinates in meters using Haversine formula."""
    phi1 = math.radians(lat1)
    phi2 = math.radians(lat2)
    delta_phi = math.radians(lat2 - lat1)
    delta_lambda = math.radians(lon2 - lon1)

    a = (math.sin(delta_phi / 2.0) ** 2 +
         math.cos(phi1) * math.cos(phi2) * math.sin(delta_lambda / 2.0) ** 2)
    c = 2.0 * math.atan2(math.sqrt(a), math.sqrt(1.0 - a))
    
    return EARTH_RADIUS_METERS * c

def compute_text_similarity(text1: Optional[str], text2: Optional[str]) -> float:
    """
    Computes semantic text similarity using token intersection, prefix-stem matching,
    and containment ratio between a citizen report and issue record.
    """
    if not text1 or not text2:
        return 0.5  # Neutral score if one has no description
    
    raw_tokens1 = set(re.findall(r'\b\w{3,}\b', text1.lower()))
    raw_tokens2 = set(re.findall(r'\b\w{3,}\b', text2.lower()))
    
    if not raw_tokens1 or not raw_tokens2:
        return 0.5

    # Prefix stems for matching (e.g. 'accumulat' matches 'accumulation' and 'accumulating')
    stems1 = {w[:6] if len(w) > 6 else w for w in raw_tokens1}
    stems2 = {w[:6] if len(w) > 6 else w for w in raw_tokens2}
    
    intersection = stems1.intersection(stems2)
    union = stems1.union(stems2)
    
    jaccard = len(intersection) / len(union) if union else 0.0
    containment = len(intersection) / min(len(stems1), len(stems2)) if min(len(stems1), len(stems2)) > 0 else 0.0

    # Weighted combination: 35% Jaccard + 65% Containment
    score = round(0.35 * jaccard + 0.65 * containment, 3)
    return score

def find_intelligent_duplicates(
    db: Session,
    latitude: float,
    longitude: float,
    issue_type: str,
    title: Optional[str] = None,
    description: Optional[str] = None,
    radius_meters: Optional[float] = None,
    time_window_hours: Optional[float] = None,
    exclude_issue_id: Optional[int] = None
) -> List[Dict[str, Any]]:
    """
    Intelligently identifies potential duplicate complaints within the configurable radius (default: 50m)
    and time window (default: 72 hours).
    Returns list of candidate matches with distance, text similarity, and calculated match confidence.
    Does NOT automatically destroy or force-merge reports.
    """
    if radius_meters is None:
        radius_meters = settings.DUPLICATE_RADIUS_METERS
    if time_window_hours is None:
        time_window_hours = settings.DUPLICATE_TIME_WINDOW_HOURS

    cutoff_time = datetime.utcnow() - timedelta(hours=time_window_hours)

    query = db.query(Issue).filter(
        Issue.status.notin_([IssueStatus.RESOLVED, IssueStatus.CLOSED, IssueStatus.REJECTED]),
        Issue.created_at >= cutoff_time
    )

    if exclude_issue_id:
        query = query.filter(Issue.id != exclude_issue_id)

    candidates = query.all()
    duplicate_results = []

    combined_input_text = f"{title or ''} {description or ''}".strip()

    for candidate in candidates:
        dist = calculate_haversine_distance(latitude, longitude, candidate.latitude, candidate.longitude)
        if dist <= radius_meters:
            # Check category compatibility
            same_category = (
                str(candidate.issue_type).lower() == str(issue_type).lower() or
                getattr(candidate.issue_type, 'value', '').lower() == str(issue_type).lower()
            )

            candidate_text = f"{candidate.title} {candidate.description or ''}".strip()
            text_sim = compute_text_similarity(combined_input_text, candidate_text)

            # Spatial similarity score (1.0 at 0m, decaying to 0.5 at radius boundary)
            spatial_score = max(0.0, 1.0 - (dist / (radius_meters * 1.5)))
            
            # Category match weight (0.4), Spatial weight (0.4), Text similarity weight (0.2)
            category_score = 1.0 if same_category else 0.3
            overall_match_confidence = round(
                0.40 * category_score + 0.40 * spatial_score + 0.20 * text_sim, 2
            )

            # Filter if high probability duplicate
            if same_category or overall_match_confidence >= 0.55:
                img_url = candidate.images[0].original_image_path if candidate.images else None
                duplicate_results.append({
                    "id": candidate.id,
                    "title": candidate.title,
                    "issue_type": getattr(candidate.issue_type, 'value', str(candidate.issue_type)),
                    "status": getattr(candidate.status, 'value', str(candidate.status)),
                    "distance_meters": round(dist, 1),
                    "created_at": candidate.created_at.isoformat() if candidate.created_at else None,
                    "address": candidate.address,
                    "support_count": candidate.support_count or 1,
                    "match_confidence": overall_match_confidence,
                    "image_url": img_url,
                    "priority_score": candidate.priority_score
                })

    # Sort candidates by closest distance first
    duplicate_results.sort(key=lambda x: x["distance_meters"])
    return duplicate_results

def support_existing_issue(db: Session, issue_id: int, user_id: int, notes: Optional[str] = None) -> Issue:
    """
    Registers a citizen's support for an existing active civic complaint,
    incrementing community support count and recalculating priority.
    """
    issue = db.query(Issue).filter(Issue.id == issue_id).first()
    if not issue:
        raise ValueError(f"Issue with ID {issue_id} not found.")

    # Check if citizen already endorsed
    existing_support = db.query(ComplaintSupport).filter(
        ComplaintSupport.issue_id == issue_id,
        ComplaintSupport.user_id == user_id
    ).first()

    if not existing_support:
        sup = ComplaintSupport(issue_id=issue_id, user_id=user_id, notes=notes)
        db.add(sup)
        issue.support_count = (issue.support_count or 1) + 1
        
        # Boost priority score by citizen community signal
        from app.services.priority_service import calculate_priority_score_with_explanation
        new_score, new_sev, new_exp, _ = calculate_priority_score_with_explanation(
            issue_type=getattr(issue.issue_type, 'value', str(issue.issue_type)),
            ai_confidence=issue.ai_confidence or 0.85,
            duplicate_count=len(issue.duplicate_relations or []),
            support_count=issue.support_count,
            hours_unresolved=(datetime.utcnow() - issue.created_at).total_seconds() / 3600.0 if issue.created_at else 0.0
        )
        issue.priority_score = new_score
        issue.severity = new_sev
        issue.priority_explanation = new_exp
        db.commit()

    return issue
