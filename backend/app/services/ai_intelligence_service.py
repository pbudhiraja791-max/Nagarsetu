import os
import json
import logging
from typing import Dict, Any, Optional, List
from app.models.issue import IssueType, SeverityLevel
from app.services.priority_service import CATEGORY_BASE_RISK, calculate_category_risk

logger = logging.getLogger("nagarsetu.ai_intelligence")

# Dangerous/Critical keywords that elevate public risk
CRITICAL_HAZARD_KEYWORDS = [
    "sparking", "shock", "live wire", "open manhole", "fatal", "accident", "collapsed",
    "deep pit", "high current", "fire", "emergency", "flood", "electrocution"
]

ESCALATION_KEYWORDS = [
    "spreading", "worsened", "expanding", "overflowing onto road", "blocking traffic",
    "blocking pedestrian", "pedestrians slipping", "bigger hole", "crater expanded",
    "smell unbearable", "spilled everywhere", "flooding houses", "road submerged"
]

DEESCALATION_KEYWORDS = [
    "partially cleared", "repaired", "barricade installed", "water receding",
    "dumpster emptied", "patch applied", "improved", "danger reduced"
]


def _call_external_llm(system_prompt: str, user_prompt: str) -> Optional[str]:
    """Attempts to call Anthropic or OpenAI API if configured in environment."""
    anthropic_key = os.getenv("ANTHROPIC_API_KEY")
    if anthropic_key:
        try:
            import httpx
            model = os.getenv("CLAUDE_MODEL", "claude-3-5-sonnet-20241022")
            headers = {
                "x-api-key": anthropic_key,
                "anthropic-version": "2023-06-01",
                "content-type": "application/json"
            }
            payload = {
                "model": model,
                "max_tokens": 1000,
                "system": system_prompt,
                "messages": [{"role": "user", "content": user_prompt}]
            }
            with httpx.Client(timeout=10.0) as client:
                res = client.post("https://api.anthropic.com/v1/messages", json=payload, headers=headers)
                if res.status_code == 200:
                    data = res.json()
                    return data["content"][0]["text"]
        except Exception as e:
            logger.warning(f"External Claude API call failed, using deterministic fallback: {e}")

    openai_key = os.getenv("OPENAI_API_KEY")
    if openai_key:
        try:
            import httpx
            headers = {
                "Authorization": f"Bearer {openai_key}",
                "Content-Type": "application/json"
            }
            payload = {
                "model": "gpt-4o-mini",
                "messages": [
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": user_prompt}
                ],
                "response_format": {"type": "json_object"}
            }
            with httpx.Client(timeout=10.0) as client:
                res = client.post("https://api.openai.com/v1/chat/completions", json=payload, headers=headers)
                if res.status_code == 200:
                    data = res.json()
                    return data["choices"][0]["message"]["content"]
        except Exception as e:
            logger.warning(f"External OpenAI API call failed, using deterministic fallback: {e}")

    return None


def classify_duplicate_with_ai(
    new_report: Dict[str, Any],
    existing_issue: Dict[str, Any],
    visual_sim: float,
    text_sim: float,
    geo_dist: float
) -> Dict[str, Any]:
    """
    Evaluates whether a new citizen report describes the exact same real-world civic issue
    as an existing issue record.
    Uses Vision-LLM when available, with a deterministic civic intelligence fallback.
    """
    category_match = (
        str(new_report.get("selected_category", "")).lower() ==
        str(existing_issue.get("issue_type", "")).lower()
    )
    
    # Hard Category Gate: Different categories are NEVER the same problem
    if not category_match:
        return {
            "same_problem": False,
            "confidence": 0.99,
            "visual_match": visual_sim,
            "text_match": text_sim,
            "context_match": 0.0,
            "reasoning": f"Category mismatch: new report is '{new_report.get('selected_category')}' while existing issue is '{existing_issue.get('issue_type')}'. Hard gate prevents cross-category merging.",
            "model_name": "nagarsetu-dedup-gate",
            "raw_response": json.dumps({"same_problem": False, "reason": "category_mismatch"})
        }

    # Attempt External LLM Call
    system_prompt = (
        "You are NagarSetu's Civic Issue Deduplication AI. Compare a new citizen complaint against an existing civic issue. "
        "Determine if they describe the EXACT SAME underlying physical defect (e.g. the same pothole, same garbage pile, same leak). "
        "Output ONLY a JSON object with keys: same_problem (bool), confidence (float 0-1), visual_match (float 0-1), text_match (float 0-1), "
        "context_match (float 0-1), reasoning (string)."
    )
    user_prompt = f"""
Existing Issue:
- Title: {existing_issue.get('title')}
- Category: {existing_issue.get('issue_type')}
- Address: {existing_issue.get('address')}
- Summary/Description: {existing_issue.get('description')}

New Report:
- Category: {new_report.get('selected_category')}
- Description: {new_report.get('description')}
- Address: {new_report.get('address')}
- Distance to Existing: {geo_dist:.1f} meters
- Computed Visual Similarity: {visual_sim:.2f}
- Computed Text Similarity: {text_sim:.2f}
"""

    llm_output = _call_external_llm(system_prompt, user_prompt)
    if llm_output:
        try:
            parsed = json.loads(llm_output.strip())
            return {
                "same_problem": bool(parsed.get("same_problem")),
                "confidence": float(parsed.get("confidence", 0.85)),
                "visual_match": float(parsed.get("visual_match", visual_sim)),
                "text_match": float(parsed.get("text_match", text_sim)),
                "context_match": float(parsed.get("context_match", 0.8)),
                "reasoning": str(parsed.get("reasoning", "AI classified complaint match")),
                "model_name": "nagarsetu-llm-dedup",
                "raw_response": llm_output
            }
        except Exception:
            pass

    # Deterministic Civic Intelligence Fallback
    # Context score considers category match, address proximity, and distance decay
    context_score = 1.0 if geo_dist <= 25.0 else max(0.2, 1.0 - (geo_dist / 100.0))
    geo_sim = max(0.0, 1.0 - (geo_dist / 60.0))
    
    # Combined heuristic score
    composite_score = round(
        0.35 * geo_sim + 0.25 * visual_sim + 0.20 * text_sim + 0.20 * context_score, 3
    )

    same_problem = composite_score >= 0.50
    if geo_dist <= 25.0 and text_sim >= 0.30:
        confidence = round(min(0.96, 0.60 + geo_sim * 0.25 + text_sim * 0.20), 2)
    else:
        confidence = round(min(0.98, max(0.60, composite_score + 0.10 if same_problem else 1.0 - composite_score)), 2)
    
    reasoning_parts = []
    if geo_dist <= 25.0:
        reasoning_parts.append(f"Immediate physical proximity ({geo_dist:.1f}m away)")
    else:
        reasoning_parts.append(f"Located {geo_dist:.1f}m from existing issue")

    if visual_sim >= 0.70:
        reasoning_parts.append(f"high photographic visual correlation ({int(visual_sim * 100)}%)")
    elif visual_sim >= 0.40:
        reasoning_parts.append(f"moderate visual match ({int(visual_sim * 100)}%)")
    else:
        reasoning_parts.append("distinct visual angle or photographic variation")

    if text_sim >= 0.40:
        reasoning_parts.append(f"matching description semantic keywords ({int(text_sim * 100)}%)")

    reasoning = f"Deterministic evaluation determined {'same civic problem' if same_problem else 'distinct civic defect'}: " + "; ".join(reasoning_parts) + f". Overall composite similarity: {composite_score:.2f}."

    return {
        "same_problem": same_problem,
        "confidence": confidence,
        "visual_match": visual_sim,
        "text_match": text_sim,
        "context_match": round(context_score, 2),
        "reasoning": reasoning,
        "model_name": "nagarsetu-deterministic-dedup-v1",
        "raw_response": json.dumps({"composite_score": composite_score, "same_problem": same_problem, "geo_dist": geo_dist})
    }


def assess_severity_with_ai(
    report_data: Dict[str, Any],
    existing_issue: Optional[Dict[str, Any]] = None,
    current_severity_score: Optional[float] = None
) -> Dict[str, Any]:
    """
    Evaluates physical severity (0 - 100) and severity level (LOW, MEDIUM, HIGH, CRITICAL).
    For existing issues with new evidence, compares before & after to detect genuine worsening
    (escalation) or improvement (de-escalation).
    Prevents artificial inflation from repeated reports describing unchanged conditions.
    """
    category = report_data.get("selected_category") or report_data.get("issue_type") or "Other Civic Problem"
    desc = (report_data.get("description") or "").lower()
    
    # 1. Base Inherent Risk from Category
    base_risk = calculate_category_risk(category)

    # 2. Check for Critical Emergency Hazard Triggers
    has_critical_hazard = any(k in desc for k in CRITICAL_HAZARD_KEYWORDS)
    if "exposed electrical wire" in category.lower() or "open manhole" in category.lower():
        base_risk = max(base_risk, 90.0)

    # 3. Detect Evidence-Based Escalation / De-escalation
    has_escalation_evidence = any(k in desc for k in ESCALATION_KEYWORDS)
    has_deescalation_evidence = any(k in desc for k in DEESCALATION_KEYWORDS)
    
    # 4. Physical Area & Obstruction Impact
    area_ratio = float(report_data.get("defect_area_ratio", 0.08))
    area_boost = min(15.0, area_ratio * 50.0)

    # 5. External LLM Attempt
    system_prompt = (
        "You are NagarSetu's Civic Defect Physical Severity Evaluator. Assess the actual real-world physical danger "
        "and disruption caused by this defect. Rate severity strictly on a 0-100 scale: "
        "LOW (1-25), MEDIUM (26-50), HIGH (51-75), CRITICAL (76-100). "
        "CRITICAL RULE: NEVER increase severity merely because multiple citizens reported the same problem. "
        "Only change severity if the physical damage or danger has genuinely expanded or worsened. "
        "Output ONLY a JSON object with: severity_score (float), severity_level (LOW|MEDIUM|HIGH|CRITICAL), "
        "confidence (float 0-1), risk_factors (list of strings), explanation (string), is_escalation (bool), is_deescalation (bool)."
    )
    user_prompt = f"""
Problem Category: {category}
Citizen Description: {report_data.get('description')}
Defect Area Ratio: {area_ratio}
Previous Severity Score (if existing issue): {current_severity_score}
"""
    llm_output = _call_external_llm(system_prompt, user_prompt)
    if llm_output:
        try:
            parsed = json.loads(llm_output.strip())
            score = float(parsed.get("severity_score", 50.0))
            score = max(1.0, min(100.0, score))
            level = parsed.get("severity_level", "MEDIUM")
            return {
                "severity_score": round(score, 1),
                "severity_level": level,
                "confidence": float(parsed.get("confidence", 0.88)),
                "risk_factors": parsed.get("risk_factors", ["physical_defect"]),
                "explanation": str(parsed.get("explanation", "AI physical severity evaluation")),
                "supporting_evidence": {"area_ratio": area_ratio, "description_evidence": desc[:100]},
                "is_escalation": bool(parsed.get("is_escalation", False)),
                "is_deescalation": bool(parsed.get("is_deescalation", False)),
                "model_name": "nagarsetu-llm-severity",
                "raw_response": llm_output
            }
        except Exception:
            pass

    # Deterministic Severity Calculation Engine
    risk_factors = []
    is_escalation = False
    is_deescalation = False

    # Calculate initial score based on physical characteristics
    calc_score = base_risk * 0.70 + area_boost

    if has_critical_hazard:
        calc_score = max(calc_score, 85.0)
        risk_factors.append("immediate_public_safety_hazard")

    if "school" in desc or "hospital" in desc:
        calc_score += 8.0
        risk_factors.append("vulnerable_institutional_zone")

    if "blocking" in desc or "traffic" in desc or "pedestrian" in desc:
        calc_score += 6.0
        risk_factors.append("public_right_of_way_obstruction")

    # If this is an existing issue being reassessed with new evidence:
    if current_severity_score is not None:
        if has_escalation_evidence:
            # Verified worsening: increase severity by 10 - 25 points
            calc_score = max(current_severity_score + 15.0, calc_score)
            is_escalation = True
            risk_factors.append("physical_damage_expansion")
            explanation = f"New citizen evidence demonstrates worsening conditions ({', '.join(k for k in ESCALATION_KEYWORDS if k in desc)}). Severity escalated from {current_severity_score:.1f} to {calc_score:.1f}."
        elif has_deescalation_evidence:
            # Verified improvement: decrease severity
            calc_score = min(current_severity_score - 20.0, calc_score)
            is_deescalation = True
            risk_factors.append("verified_condition_improvement")
            explanation = f"New evidence verifies ground remediation ({', '.join(k for k in DEESCALATION_KEYWORDS if k in desc)}). Severity de-escalated from {current_severity_score:.1f} to {calc_score:.1f}."
        else:
            # Unchanged conditions: STABLE. Do not artificially inflate severity!
            calc_score = current_severity_score
            explanation = f"New report confirms ongoing condition without evidence of expansion. Physical severity maintained at {current_severity_score:.1f}."
    else:
        explanation = f"Initial AI severity assessment for category '{category}' based on baseline safety risk ({int(base_risk)}/100) and defect footprint."

    final_score = round(max(1.0, min(100.0, calc_score)), 1)
    
    # Map to Severity Level
    if final_score >= 76.0:
        level = "CRITICAL"
    elif final_score >= 51.0:
        level = "HIGH"
    elif final_score >= 26.0:
        level = "MEDIUM"
    else:
        level = "LOW"

    return {
        "severity_score": final_score,
        "severity_level": level,
        "confidence": 0.90 if has_critical_hazard or current_severity_score else 0.85,
        "risk_factors": risk_factors,
        "explanation": explanation,
        "supporting_evidence": {
            "category": category,
            "base_risk": base_risk,
            "area_ratio": area_ratio,
            "has_critical_hazard": has_critical_hazard,
            "is_escalation": is_escalation,
            "is_deescalation": is_deescalation
        },
        "is_escalation": is_escalation,
        "is_deescalation": is_deescalation,
        "model_name": "nagarsetu-deterministic-severity-v1",
        "raw_response": json.dumps({"severity_score": final_score, "severity_level": level, "risk_factors": risk_factors})
    }
