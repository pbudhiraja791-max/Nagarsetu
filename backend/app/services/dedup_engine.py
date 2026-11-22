import json
import logging
from datetime import datetime, timedelta
from typing import List, Dict, Any, Optional, Tuple
from sqlalchemy.orm import Session
from app.models.issue import Issue, IssueStatus
from app.models.intelligence import DedupConfig, Report, ReportMedia
from app.services.duplicate_service import calculate_haversine_distance, compute_text_similarity
from app.services.image_similarity_service import (
    calculate_image_similarity, calculate_sha256, calculate_dhash
)
from app.services.ai_intelligence_service import classify_duplicate_with_ai

logger = logging.getLogger("nagarsetu.dedup_engine")

DEFAULT_CATEGORY_RADII = {
    "Pothole": 30.0,
    "Damaged Road": 40.0,
    "Garbage Accumulation": 75.0,
    "Overflowing Dustbin": 50.0,
    "Water Leakage": 40.0,
    "Drainage Blockage": 50.0,
    "Waterlogging": 60.0,
    "Damaged Streetlight": 20.0,
    "Exposed Electrical Wire": 30.0,
    "Open Manhole": 25.0,
    "Broken Public Infrastructure": 40.0,
    "Other Civic Problem": 40.0,
}


def get_dedup_config(db: Session) -> DedupConfig:
    """Retrieves dynamic duplicate detection configuration from database."""
    config = db.query(DedupConfig).first()
    if not config:
        config = DedupConfig()
        db.add(config)
        db.commit()
        db.refresh(config)
    return config


def get_category_radius(category: str, config: Optional[DedupConfig] = None) -> float:
    """Returns category-specific geographical radius in meters."""
    if config and config.category_radii_json:
        try:
            radii_map = json.loads(config.category_radii_json)
            for cat_key, rad in radii_map.items():
                if cat_key.lower() == str(category).lower():
                    return float(rad)
        except Exception:
            pass

    for cat_key, rad in DEFAULT_CATEGORY_RADII.items():
        if cat_key.lower() == str(category).lower():
            return rad
    return 40.0


def retrieve_candidate_issues(
    db: Session,
    latitude: float,
    longitude: float,
    category: str,
    gps_accuracy: float = 10.0,
    exclude_issue_id: Optional[int] = None,
    config: Optional[DedupConfig] = None
) -> List[Tuple[Issue, float]]:
    """
    Step 4: Geographical Candidate Retrieval.
    Retrieves potential candidate issues matching:
    1. Same problem category (Hard gate: different categories never merged).
    2. Proximity within category radius (accounting for GPS accuracy).
    3. Status is open or resolved within configured reopening window.
    """
    if config is None:
        config = get_dedup_config(db)

    cat_radius = get_category_radius(category, config)
    effective_radius = max(cat_radius, gps_accuracy)
    reopen_cutoff = datetime.utcnow() - timedelta(hours=config.reopening_window_hours or 72.0)

    # Query issues matching category and active or recently resolved
    query = db.query(Issue).filter(
        Issue.issue_type == category,
        (Issue.status.notin_([IssueStatus.RESOLVED, IssueStatus.CLOSED, IssueStatus.REJECTED])) |
        (Issue.resolved_at >= reopen_cutoff)
    )

    if exclude_issue_id:
        query = query.filter(Issue.id != exclude_issue_id)

    candidates = query.all()
    matched_candidates: List[Tuple[Issue, float]] = []

    for cand in candidates:
        dist = calculate_haversine_distance(latitude, longitude, cand.latitude, cand.longitude)
        if dist <= effective_radius:
            matched_candidates.append((cand, dist))

    # Sort by closest distance first and take top N
    matched_candidates.sort(key=lambda x: x[1])
    max_c = config.max_candidates or 5
    return matched_candidates[:max_c]


def evaluate_duplicate_matches(
    db: Session,
    new_report_data: Dict[str, Any],
    candidate_issues: List[Tuple[Issue, float]],
    config: Optional[DedupConfig] = None
) -> List[Dict[str, Any]]:
    """
    Step 5: Multi-Factor Similarity Scoring.
    Calculates:
      A. Geographical Similarity (0 - 1)
      B. Textual Similarity (0 - 1)
      C. Visual Similarity (0 - 1)
      D. Contextual Similarity (0 - 1)
      E. AI Same-Problem Classification

    Returns evaluated candidates with scores and decisions.
    """
    if config is None:
        config = get_dedup_config(db)

    weights = {"geo": 0.30, "visual": 0.30, "text": 0.20, "context": 0.20}
    if config.weights_json:
        try:
            weights = json.loads(config.weights_json)
        except Exception:
            pass

    evaluated_candidates = []
    category = new_report_data.get("selected_category", "")
    new_desc = new_report_data.get("description", "")
    new_img_path = new_report_data.get("image_path", "")
    new_img_sha = new_report_data.get("image_hash")
    new_img_phash = new_report_data.get("perceptual_hash")
    cat_radius = get_category_radius(category, config)

    for issue, dist in candidate_issues:
        # A. Geographical Similarity (1.0 at 0m, decaying to 0.0 at radius boundary)
        geo_sim = max(0.0, 1.0 - (dist / (cat_radius * 1.25)))

        # B. Textual Similarity
        issue_text = f"{issue.title} {issue.summary or ''} {issue.description or ''}".strip()
        text_sim = compute_text_similarity(new_desc, issue_text)

        # C. Visual Similarity against issue images
        visual_sim = 0.5
        visual_match_type = "NO_IMAGE"

        # Check existing images on the issue
        cand_img_path = None
        cand_img_sha = None
        cand_img_phash = None
        if issue.images:
            cand_img_path = issue.images[0].original_image_path
        
        # Also check reports media on the issue
        first_rep_media = db.query(ReportMedia).join(Report).filter(Report.issue_id == issue.id).first()
        if first_rep_media:
            cand_img_sha = first_rep_media.image_hash
            cand_img_phash = first_rep_media.perceptual_hash
            if not cand_img_path:
                cand_img_path = first_rep_media.image_url

        has_new_image = bool(new_img_path or new_img_sha or new_img_phash)
        has_cand_image = bool(cand_img_path or cand_img_sha or cand_img_phash)

        if has_new_image and has_cand_image:
            v_score, m_type = calculate_image_similarity(
                image_path1=new_img_path or "",
                image_path2=cand_img_path or "",
                phash1=new_img_phash,
                phash2=cand_img_phash,
                sha1=new_img_sha,
                sha2=cand_img_sha
            )
            visual_sim = v_score
            visual_match_type = m_type
            effective_weights = weights
        else:
            # Rebalance weights when visual comparison is not available
            effective_weights = {"geo": 0.40, "visual": 0.0, "text": 0.35, "context": 0.25}

        # D. Contextual Similarity
        reporter_id = new_report_data.get("reporter_id")
        is_citizen_repeat = False
        if reporter_id:
            is_citizen_repeat = db.query(Report).filter(
                Report.issue_id == issue.id,
                Report.reporter_id == reporter_id,
                Report.status == "accepted"
            ).first() is not None

        same_cat = str(category).lower() == getattr(issue.issue_type, 'value', str(issue.issue_type)).lower()
        context_sim = 1.0 if same_cat else 0.0
        if issue.status in [IssueStatus.RESOLVED, IssueStatus.CLOSED]:
            context_sim *= 0.7  # Recently resolved slightly lower contextual score

        # E. AI Same-Problem Classification
        ai_classification = classify_duplicate_with_ai(
            new_report=new_report_data,
            existing_issue={
                "id": issue.id,
                "title": issue.title,
                "issue_type": getattr(issue.issue_type, 'value', str(issue.issue_type)),
                "address": issue.address,
                "description": issue.description or issue.title
            },
            visual_sim=visual_sim,
            text_sim=text_sim,
            geo_dist=dist
        )

        # Compute Final Similarity Score Formula:
        final_score = round(
            (effective_weights.get("geo", 0.30) * geo_sim) +
            (effective_weights.get("visual", 0.0) * visual_sim) +
            (effective_weights.get("text", 0.35) * text_sim) +
            (effective_weights.get("context", 0.25) * context_sim),
            3
        )

        # Boost if AI confirms same problem in close proximity or citizen is re-reporting same issue nearby
        if (ai_classification.get("same_problem") and ai_classification.get("confidence", 0) >= 0.80 and dist <= 25.0) or (is_citizen_repeat and dist <= cat_radius):
            final_score = max(final_score, 0.85)

        # Apply AI Override Gate: If AI strongly says it's a different problem, cap score to prevent false merge
        if not ai_classification.get("same_problem") and ai_classification.get("confidence", 0) >= 0.75:
            final_score = min(final_score, 0.45)

        # Step 6: Duplicate Decision
        auto_link_thresh = config.auto_link_threshold or 0.80
        review_thresh = config.manual_review_threshold or 0.55

        if final_score >= auto_link_thresh:
            decision = "HIGH"   # Auto-link to existing issue
        elif final_score >= review_thresh:
            decision = "MEDIUM" # Send for administrator review
        else:
            decision = "LOW"    # Create a new civic issue

        evaluated_candidates.append({
            "issue_id": issue.id,
            "display_id": issue.display_id,
            "title": issue.title,
            "category": getattr(issue.issue_type, 'value', str(issue.issue_type)),
            "distance_meters": round(dist, 1),
            "geo_similarity": round(geo_sim, 3),
            "text_similarity": round(text_sim, 3),
            "visual_similarity": round(visual_sim, 3),
            "visual_match_type": visual_match_type,
            "context_similarity": round(context_sim, 3),
            "final_score": final_score,
            "decision": decision,
            "ai_confidence": ai_classification.get("confidence", 0.85),
            "ai_reasoning": ai_classification.get("reasoning", ""),
            "ai_model": ai_classification.get("model_name", "nagarsetu-dedup-v1"),
            "raw_ai_response": ai_classification.get("raw_response", ""),
            "total_reports": issue.total_reports or 1,
            "unique_citizens": issue.unique_citizens or 1,
            "status": getattr(issue.status, 'value', str(issue.status))
        })

    # Sort candidates by final score descending
    evaluated_candidates.sort(key=lambda x: x["final_score"], reverse=True)
    return evaluated_candidates
