from typing import Optional, Dict
from sqlalchemy.orm import Session
from app.models.issue import IssueType, Issue, IssueStatus
from app.models.department import Department

# Department Routing Matrix mapping each IssueType to a Department Code
DEPARTMENT_ROUTING_MAP = {
    IssueType.POTHOLE: "DEPT_ROAD",
    IssueType.ROAD_DAMAGE: "DEPT_ROAD",
    IssueType.GARBAGE: "DEPT_SAN",
    IssueType.OVERFLOWING_DUSTBIN: "DEPT_SAN",
    IssueType.WATER_LEAKAGE: "DEPT_WATER",
    IssueType.DRAINAGE_BLOCKAGE: "DEPT_DRAIN",
    IssueType.WATERLOGGING: "DEPT_DRAIN",
    IssueType.MANHOLE: "DEPT_DRAIN",
    IssueType.STREETLIGHT: "DEPT_ELEC",
    IssueType.ELECTRICAL_WIRE: "DEPT_ELEC",
    IssueType.INFRASTRUCTURE_DAMAGE: "DEPT_PWD",
    IssueType.OTHER: "DEPT_PWD",
}

DEPARTMENT_METADATA = {
    "DEPT_ROAD": {
        "name": "Road Maintenance & Paving Department",
        "description": "Responsible for arterial roads, pothole resurfacing, and pavement safety.",
        "email": "roads@nagarsetu.gov.in"
    },
    "DEPT_SAN": {
        "name": "Sanitation & Waste Management Department",
        "description": "Handles solid waste collection, municipal dumpsters, and illegal garbage dumping.",
        "email": "sanitation@nagarsetu.gov.in"
    },
    "DEPT_WATER": {
        "name": "Water Supply & Distribution Department",
        "description": "Manages potable water mains, pipeline bursts, leakages, and pressure monitoring.",
        "email": "water@nagarsetu.gov.in"
    },
    "DEPT_DRAIN": {
        "name": "Drainage & Stormwater Department",
        "description": "Maintains stormwater drains, sewer lines, manholes, and urban waterlogging prevention.",
        "email": "drainage@nagarsetu.gov.in"
    },
    "DEPT_ELEC": {
        "name": "Electrical Infrastructure Department",
        "description": "Maintains municipal lighting, exposed electric cables, and transformer safety.",
        "email": "electrical@nagarsetu.gov.in"
    },
    "DEPT_PWD": {
        "name": "Public Works Department (PWD)",
        "description": "Oversees public infrastructure, municipal buildings, bridges, and general civic assets.",
        "email": "pwd@nagarsetu.gov.in"
    },
}

def get_recommended_department_code(issue_type: str) -> str:
    """Returns department code based on issue type string or Enum."""
    clean_type = str(issue_type).strip()
    for key, dept_code in DEPARTMENT_ROUTING_MAP.items():
        if key.value.lower() == clean_type.lower() or key.name.lower() == clean_type.lower():
            return dept_code
    return "DEPT_PWD"

def get_recommended_department_name(issue_type: str) -> str:
    code = get_recommended_department_code(issue_type)
    return DEPARTMENT_METADATA.get(code, {}).get("name", "Public Works Department (PWD)")

def route_issue_to_department(db: Session, issue_type: str) -> Optional[Department]:
    """
    Finds the appropriate Department record from the database based on the AI category recommendation.
    Falls back to PWD or any first department if exact match isn't found.
    """
    code = get_recommended_department_code(issue_type)
    dept = db.query(Department).filter(Department.code == code).first()
    if not dept:
        # Fallback to PWD or any department
        dept = db.query(Department).filter(Department.code == "DEPT_PWD").first()
    if not dept:
        dept = db.query(Department).first()
    return dept

def get_department_workload(db: Session, department_id: int) -> Dict[str, int]:
    """Calculates active backlog for a specific department."""
    active_count = db.query(Issue).filter(
        Issue.department_id == department_id,
        Issue.status.in_([
            IssueStatus.SUBMITTED,
            IssueStatus.REPORTED,
            IssueStatus.AI_ANALYZED,
            IssueStatus.UNDER_REVIEW,
            IssueStatus.ASSIGNED,
            IssueStatus.ACCEPTED,
            IssueStatus.IN_PROGRESS,
            IssueStatus.AWAITING_INSPECTION,
            IssueStatus.REOPENED,
        ])
    ).count()

    resolved_count = db.query(Issue).filter(
        Issue.department_id == department_id,
        Issue.status.in_([IssueStatus.RESOLVED, IssueStatus.CLOSED])
    ).count()

    return {
        "active_workload": active_count,
        "resolved_total": resolved_count
    }
