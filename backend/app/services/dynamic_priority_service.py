import json
from datetime import datetime
from typing import Dict, Any, Tuple, Optional
from app.models.issue import SeverityLevel
from app.services.priority_service import calculate_category_risk


def calculate_dynamic_priority(
    severity_score: float,
    category: str,
    unique_citizens: int = 1,
    first_reported_at: Optional[datetime] = None,
    is_escalated: bool = False,
    is_arterial_or_market: bool = False,
    weights: Optional[Dict[str, float]] = None
) -> Tuple[float, str, Dict[str, Any], str]:
    """
    Computes dynamic priority score (0 - 100) and structured priority_breakdown according to:
    PRIORITY SCORE =
      (Severity × 0.35) +
      (Safety Risk × 0.25) +
      (Affected Population × 0.15) +
      (Duration × 0.10) +
      (Unique Citizen Reports × 0.10) +
      (Escalation Trend × 0.05)

    Returns:
      (final_score: float, priority_level: str, breakdown: dict, explanation: str)
    """
    if weights is None:
        weights = {
            "severity": 0.35,
            "safety_risk": 0.25,
            "affected_population": 0.15,
            "duration": 0.10,
            "unique_citizens": 0.10,
            "escalation_trend": 0.05,
        }

    # 1. Severity Factor (0.0 - 1.0)
    norm_severity = min(1.0, max(0.0, severity_score / 100.0))

    # 2. Public Safety Risk Factor (0.0 - 1.0)
    cat_risk = calculate_category_risk(category)
    norm_safety = min(1.0, max(0.0, cat_risk / 100.0))

    # 3. Affected Population Factor (0.0 - 1.0)
    # Combines baseline public exposure, area type, and unique citizen density
    base_pop = 0.50 if is_arterial_or_market else 0.30
    citizen_density = min(0.50, (unique_citizens - 1) * 0.035)
    norm_population = min(1.0, base_pop + citizen_density)

    # 4. Issue Duration Factor (0.0 - 1.0)
    # Older unresolved problems gradually receive additional priority (up to 7 days = 168 hours)
    if first_reported_at:
        hours_old = max(0.0, (datetime.utcnow() - first_reported_at).total_seconds() / 3600.0)
    else:
        hours_old = 0.0
    norm_duration = min(1.0, hours_old / 168.0)

    # 5. Unique Citizen Reports Factor (0.0 - 1.0)
    # Evaluates genuinely distinct affected citizens (normalized up to 15 unique citizens)
    norm_unique_citizens = min(1.0, unique_citizens / 15.0)

    # 6. Escalation Trend Factor (0.0 - 1.0)
    norm_escalation = 1.0 if is_escalated else 0.20

    # Composite Weighted Calculation
    raw_score = (
        weights["severity"] * norm_severity +
        weights["safety_risk"] * norm_safety +
        weights["affected_population"] * norm_population +
        weights["duration"] * norm_duration +
        weights["unique_citizens"] * norm_unique_citizens +
        weights["escalation_trend"] * norm_escalation
    ) * 100.0

    final_score = round(max(0.0, min(100.0, raw_score)), 1)

    # Priority Level Mapping
    if final_score >= 75.0:
        priority_level = "CRITICAL"
    elif final_score >= 50.0:
        priority_level = "HIGH"
    elif final_score >= 25.0:
        priority_level = "MEDIUM"
    else:
        priority_level = "LOW"

    # Breakdown Dictionary
    breakdown = {
        "final_priority_score": final_score,
        "priority_level": priority_level,
        "weights": weights,
        "factors": {
            "severity": {
                "raw_value": severity_score,
                "normalized": round(norm_severity, 3),
                "weighted_contribution": round(weights["severity"] * norm_severity * 100, 1),
                "weight_percent": int(weights["severity"] * 100)
            },
            "safety_risk": {
                "raw_value": cat_risk,
                "normalized": round(norm_safety, 3),
                "weighted_contribution": round(weights["safety_risk"] * norm_safety * 100, 1),
                "weight_percent": int(weights["safety_risk"] * 100)
            },
            "affected_population": {
                "normalized": round(norm_population, 3),
                "weighted_contribution": round(weights["affected_population"] * norm_population * 100, 1),
                "weight_percent": int(weights["affected_population"] * 100)
            },
            "duration": {
                "hours_unresolved": round(hours_old, 1),
                "normalized": round(norm_duration, 3),
                "weighted_contribution": round(weights["duration"] * norm_duration * 100, 1),
                "weight_percent": int(weights["duration"] * 100)
            },
            "unique_citizens": {
                "count": unique_citizens,
                "normalized": round(norm_unique_citizens, 3),
                "weighted_contribution": round(weights["unique_citizens"] * norm_unique_citizens * 100, 1),
                "weight_percent": int(weights["unique_citizens"] * 100)
            },
            "escalation_trend": {
                "is_escalated": is_escalated,
                "normalized": round(norm_escalation, 3),
                "weighted_contribution": round(weights["escalation_trend"] * norm_escalation * 100, 1),
                "weight_percent": int(weights["escalation_trend"] * 100)
            }
        }
    }

    # Human-Readable Explanation
    explanation_lines = [
        f"Priority Score: {final_score}/100 ({priority_level})",
        f"• Severity Factor ({weights['severity']*100:.0f}%): {severity_score:.1f}/100 contributing {weights['severity'] * norm_severity * 100:.1f} pts.",
        f"• Public Safety Hazard ({weights['safety_risk']*100:.0f}%): Baseline risk index {cat_risk:.0f}/100 for category '{category}'.",
        f"• Unique Citizen Endorsements ({weights['unique_citizens']*100:.0f}%): Confirmed by {unique_citizens} distinct citizen(s).",
    ]
    if hours_old > 24:
        explanation_lines.append(f"• Backlog Aging ({weights['duration']*100:.0f}%): Unresolved for {hours_old:.1f} hours.")
    if is_escalated:
        explanation_lines.append("• Condition Escalation: Active physical damage expansion detected by AI.")

    explanation = "\n".join(explanation_lines)
    return final_score, priority_level, breakdown, explanation
