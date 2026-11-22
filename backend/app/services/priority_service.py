from typing import Dict, Any, Tuple
from app.models.issue import IssueType, SeverityLevel
from app.core.config import settings

# Inherent Public Safety Risk Base Score (0 - 100)
CATEGORY_BASE_RISK = {
    IssueType.ELECTRICAL_WIRE: 96.0,       # Electrocution risk, life-critical
    IssueType.MANHOLE: 95.0,              # Fatal fall hazard for pedestrians / vehicles
    IssueType.WATERLOGGING: 82.0,         # Flash flood, submerged obstacles, disease
    IssueType.WATER_LEAKAGE: 78.0,        # Potable water loss, road erosion risk
    IssueType.POTHOLE: 72.0,              # Two-wheeler skid/accident risk
    IssueType.ROAD_DAMAGE: 68.0,          # Traffic disruption, structural damage
    IssueType.DRAINAGE_BLOCKAGE: 64.0,    # Vector breeding, sewage backflow
    IssueType.STREETLIGHT: 55.0,          # Nighttime crime and collision hazard
    IssueType.INFRASTRUCTURE_DAMAGE: 58.0,# Structural degradation
    IssueType.OVERFLOWING_DUSTBIN: 48.0,  # Public hygiene hazard
    IssueType.GARBAGE: 45.0,              # Sanitation and smell nuisance
    IssueType.OTHER: 40.0,
}

def calculate_category_risk(issue_type: str) -> float:
    for key, score in CATEGORY_BASE_RISK.items():
        if key.value.lower() == str(issue_type).lower() or key.name.lower() == str(issue_type).lower():
            return score
    return 50.0

def calculate_priority_score_with_explanation(
    issue_type: str,
    ai_confidence: float,
    defect_area_ratio: float = 0.0,
    duplicate_count: int = 0,
    support_count: int = 1,
    hours_unresolved: float = 0.0,
    is_recurring: bool = False,
    is_school_or_hospital_zone: bool = False
) -> Tuple[float, SeverityLevel, str, Dict[str, float]]:
    """
    Computes transparent, explainable 0-100 NagarSetu Priority Score
    with comprehensive reasoning and recommended SLA action.
    """
    # 1. Category Hazard / Public Safety Risk Factor (0 - 100)
    s_cat = calculate_category_risk(issue_type)
    
    # 2. AI Confidence Factor (0 - 100)
    s_conf = min(100.0, max(0.0, ai_confidence * 100.0 if ai_confidence <= 1.0 else ai_confidence))
    
    # 3. Defect Surface Area Ratio Factor (0 - 100)
    s_area = min(100.0, max(0.0, (defect_area_ratio * 100.0 if defect_area_ratio <= 1.0 else defect_area_ratio) * 1.5))
    
    # 4. Citizen Voice & Density Support Factor (0 - 100)
    # Combines community upvotes and nearby duplicate confirmations
    community_signals = max(0, support_count - 1) + duplicate_count
    s_dup = min(100.0, community_signals * 18.0)
    
    # 5. Complaint Aging / SLA Escalation Factor (0 - 100)
    s_age = min(100.0, hours_unresolved * 1.25)

    # 6. Environmental Multipliers (Recurrence & Vulnerable Zone)
    environmental_boost = 0.0
    if is_recurring:
        environmental_boost += 8.0
    if is_school_or_hospital_zone:
        environmental_boost += 10.0

    raw_score = (
        settings.WEIGHT_CATEGORY * s_cat +
        settings.WEIGHT_CONFIDENCE * s_conf +
        settings.WEIGHT_DEFECT_AREA * s_area +
        settings.WEIGHT_DUPLICATES * s_dup +
        settings.WEIGHT_AGING * s_age +
        environmental_boost
    )

    final_score = round(min(100.0, max(0.0, raw_score)), 1)
    severity = get_severity_from_priority(final_score)

    # Generate Human-Readable Transparent Explanation
    reasons = []
    if s_cat >= 80:
        reasons.append(f"High public safety hazard for category '{issue_type}' (Life & safety risk index: {int(s_cat)}/100).")
    elif s_cat >= 60:
        reasons.append(f"Significant infrastructure disruption risk for category '{issue_type}' ({int(s_cat)}/100).")
    else:
        reasons.append(f"Routine public amenity issue for '{issue_type}' ({int(s_cat)}/100).")

    if s_conf >= 85:
        reasons.append(f"High-confidence computer vision detection ({round(s_conf, 1)}% certainty).")

    if defect_area_ratio > 0.15:
        reasons.append(f"Large visible defect footprint ({round(defect_area_ratio * 100, 1)}% of inspected frame).")

    if community_signals > 0:
        reasons.append(f"Confirmed by {community_signals} citizen report(s) / nearby community support endorsement(s).")

    if hours_unresolved > 48:
        reasons.append(f"Pending without resolution for {int(hours_unresolved)} hours, triggering aging escalation.")

    if is_recurring:
        reasons.append("Identified historically as a recurring civic defect hotspot.")

    if is_school_or_hospital_zone:
        reasons.append("Proximity to vulnerable public sector infrastructure (hospital/school pedestrian zone).")

    # Recommended Operational Action
    if final_score >= 75:
        recommended_action = "IMMEDIATE INSPECTION & DISPATCH: High-priority barricading or emergency repair crew within 24 hours."
    elif final_score >= 50:
        recommended_action = "EXPEDITED ACTION: Field engineer assessment and work order allocation within 48 hours."
    elif final_score >= 25:
        recommended_action = "SCHEDULED REPAIR: Queued in standard departmental maintenance roster within 5 business days."
    else:
        recommended_action = "MONITOR & ROUTINE BATCH: Low severity maintenance window within 7 calendar days."

    bullet_points = "\n".join([f"• {r}" for r in reasons])
    explanation = f"Priority Score: {final_score}/100 ({severity.value})\n\nScoring Breakdown Reasons:\n{bullet_points}\n\nRecommended Action:\n{recommended_action}"

    components = {
        "category_risk": s_cat,
        "ai_confidence": s_conf,
        "defect_area": s_area,
        "community_signals": s_dup,
        "aging_factor": s_age,
        "environmental_boost": environmental_boost,
    }

    return final_score, severity, explanation, components

def calculate_priority_score(
    issue_type: str,
    ai_confidence: float,
    defect_area_ratio: float = 0.0,
    duplicate_count: int = 0,
    hours_unresolved: float = 0.0
) -> float:
    """Backward-compatible helper returning single float score."""
    score, _, _, _ = calculate_priority_score_with_explanation(
        issue_type=issue_type,
        ai_confidence=ai_confidence,
        defect_area_ratio=defect_area_ratio,
        duplicate_count=duplicate_count,
        hours_unresolved=hours_unresolved
    )
    return score

def get_severity_from_priority(priority_score: float) -> SeverityLevel:
    """
    Standard NagarSetu Classification:
    0–24: Low
    25–49: Moderate / Medium
    50–74: High
    75–100: Critical
    """
    if priority_score < 25.0:
        return SeverityLevel.LOW
    elif priority_score < 50.0:
        return SeverityLevel.MODERATE
    elif priority_score < 75.0:
        return SeverityLevel.HIGH
    else:
        return SeverityLevel.CRITICAL

def get_sla_hours_from_priority(priority_score: float) -> int:
    """Calculates SLA target hours based on priority score."""
    if priority_score >= 75.0:
        return settings.SLA_CRITICAL_HOURS  # 24h
    elif priority_score >= 50.0:
        return settings.SLA_HIGH_HOURS      # 48h
    elif priority_score >= 25.0:
        return settings.SLA_MODERATE_HOURS  # 120h (5 days)
    else:
        return settings.SLA_LOW_HOURS       # 168h (7 days)
