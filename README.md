# NagarSetu (नगरसेतु) 🌉🇮🇳

### Bridging Citizens. Empowering Cities.
**नागरिकों और प्रशासन के बीच एक सेतु**

**Product Category:** AI-Powered Civic Intelligence, Public Infrastructure Monitoring & Municipal Accountability Platform.

---

## 🌟 Executive Summary

**NagarSetu** is an intelligent civic-tech digital infrastructure platform that closes the critical gap between citizens reporting public infrastructure defects and municipal authorities resolving them with verifiable ground proof.

Unlike traditional complaint portals that act as unmonitored ticket black holes, NagarSetu introduces:
1. **Multilingual Voice-First & Visual Defect Reporting** in Hindi, Punjabi, and English.
2. **Computer Vision & Spatial Defect Localization** with automated bounding box mapping across 11 defect categories.
3. **Explainable 0–100 Priority Scoring Engine** factoring category public hazard (35%), AI confidence (15%), defect area footprint (15%), community endorsements (20%), and aging backlog (15%).
4. **Intelligent 50-Meter Spatial Deduplication** that prevents municipal ticket clutter while boosting urgency via citizen upvoting.
5. **Configurable Service Level Agreements (SLAs)** with automated overdue escalation (Critical: 24h, High: 48h, Moderate: 5d, Low: 7d).
6. **Citizen-Verified Ground Resolution Workflow** where tickets cannot be closed until officers upload photographic repair proof, AI assesses remediation, and the reporting citizen confirms the ground fix.
7. **Predictive Civic Intelligence & Geospatial Analytics** forecasting defect recurrence hotspots via spatial kernel clustering.
8. **Public Accountability Dashboard** publishing transparent municipal response rates without exposing citizen personal identification data (PII).

---

## 🏛️ Supported Stakeholders & Roles

### A. Citizens
- **Voice & Photo Lodging**: Speak complaints naturally in Hindi/Punjabi/English or upload defect photos with GPS capture.
- **50m Duplicate Endorsements**: Upvote existing neighborhood complaints to boost urgency without duplicate clutter.
- **Real-Time Lifecycle Tracking**: Live status progression across all 13 lifecycle milestones.
- **Citizen Ground Verification**: Review before-and-after repair photographs with AI remediation confidence; confirm resolution or reopen tickets if defects persist.

### B. Department Field Officers
- **Department-Specific Queues**: Assigned tickets filtered to Road, Sanitation, Water, Drainage, Electrical, or PWD.
- **SLA Countdown & Overdue Alerts**: Real-time tracking of deadlines (24h/48h/120h/168h) with escalation tags.
- **Repair Proof Upload**: Capture after-repair photos and remediation summaries for automated AI comparison.
- **Progress Tracking**: Commit estimated completion dates, record field notes, and manage work orders.

### C. Municipal Administrators
- **Cross-Departmental Oversight**: City-wide KPI scorecards, department resolution rates, and overdue backlog.
- **Predictive Civic Hotspots**: Geospatial cluster forecast identifying recurring failure zones and preventive maintenance actions.
- **Priority Override & Independent Audits**: Adjust priority scores with recorded justifications and dispatch independent inspectors.

---

## 🎯 11 Supported Infrastructure Defect Categories

| Category | Description | Routing Department | Base Safety Hazard |
| :--- | :--- | :--- | :--- |
| **Potholes** | Road cratering, two-wheeler skid hazard | Road Maintenance (`DEPT_ROAD`) | 72 / 100 |
| **Damaged Roads** | Fissures, broken asphalt, pavement erosion | Road Maintenance (`DEPT_ROAD`) | 68 / 100 |
| **Garbage Accumulation** | Illegal waste dumping, rotting trash piles | Sanitation (`DEPT_SAN`) | 45 / 100 |
| **Overflowing Dustbins** | Spillover from public municipal containers | Sanitation (`DEPT_SAN`) | 48 / 100 |
| **Water Leakage** | Pipeline burst, clean potable water loss | Water Supply (`DEPT_WATER`) | 78 / 100 |
| **Drainage Blockages** | Choked stormwater drains, sewer backflow | Drainage (`DEPT_DRAIN`) | 64 / 100 |
| **Waterlogging** | Underpass flooding, submerged road lanes | Drainage (`DEPT_DRAIN`) | 82 / 100 |
| **Damaged Streetlights** | Non-functional luminaire creating dark zones | Electrical (`DEPT_ELEC`) | 55 / 100 |
| **Exposed Electrical Wires** | Dangling live cables, electrocution risk | Electrical (`DEPT_ELEC`) | 96 / 100 (Critical) |
| **Open Manholes** | Missing storm chamber lids, fatal fall hazard | Drainage (`DEPT_DRAIN`) | 95 / 100 (Critical) |
| **Broken Public Infrastructure** | Broken railings, collapsed footpaths, bridges | Public Works (`DEPT_PWD`) | 58 / 100 |

---

## 🔄 Complete 13-Stage Lifecycle Flow

```
SUBMITTED ➔ AI_ANALYZED ➔ UNDER_REVIEW ➔ ASSIGNED ➔ ACCEPTED ➔ IN_PROGRESS
    ➔ AWAITING_INSPECTION ➔ RESOLUTION_SUBMITTED ➔ CITIZEN_VERIFICATION
         ├── [Confirmed Fixed] ➔ RESOLVED ➔ CLOSED
         └── [Ground Defect Persists] ➔ REOPENED ➔ IN_PROGRESS
```

---

## 🛠️ Technology Stack

| Component | Technologies |
| :--- | :--- |
| **Frontend** | React 18, Vite 5, TypeScript, Tailwind CSS, Leaflet & React-Leaflet, Lucide Icons, Axios |
| **Backend** | Python 3.10+, FastAPI 2.0, Pydantic v2, SQLAlchemy ORM, SQLite / PostgreSQL |
| **AI / Vision** | OpenCV (Headless), NumPy, Pillow, Ultralytics YOLO inference adapter |
| **NLP & Speech** | Web Speech API, Multilingual Semantic Keyword Parser (Hindi, Punjabi, English) |
| **Spatial Engine** | Haversine Great-Circle Spatial Proximity & Density Cluster Engine |
| **Security** | OAuth2 Bearer Tokens (HS256 JWT) with PBKDF2 Password Hashing & RBAC |

---

## 🚀 Quick Start Guide

### 1. Prerequisites
- Python 3.10+
- Node.js 18+ and npm

### 2. Backend Setup
```bash
# Navigate to project directory
cd CivicSense-AI

# Install dependencies (or use active venv)
pip install -r backend/requirements.txt

# Run Database Migrations & Seed NagarSetu Data
$env:PYTHONPATH="backend"
python backend/app/seed.py

# Verify All 7 NagarSetu Backend Engine Modules
python backend/app/test_nagarsetu_suite.py

# Start FastAPI Backend Server
python -m uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```
- Swagger API Documentation: `http://127.0.0.1:8000/api/v1/docs`

### 3. Frontend Setup
```bash
cd frontend

# Install dependencies
npm install

# Start Vite Development Server
npm run dev

# Or build for production
npm run build
```
- Web Application: `http://localhost:5173`

---

## 🔐 Pre-Configured Demo Credentials

| Role | Email | Password | Responsibilities |
| :--- | :--- | :--- | :--- |
| **Verified Citizen** | `citizen@nagarsetu.gov.in` | `Citizen@123` | File voice/photo complaints, endorse nearby issues, verify ground repairs |
| **Municipal Administrator** | `admin@nagarsetu.gov.in` | `Admin@123` | Command center, predictive hotspots, SLA monitoring, priority overrides |
| **Road Department Officer** | `road.officer@nagarsetu.gov.in` | `Officer@123` | Road repair queue, pothole work orders, upload asphalt repair evidence |
| **Sanitation Officer** | `sanitation.officer@nagarsetu.gov.in` | `Officer@123` | Waste dumping orders, compactor dispatch, bin remediation proof |
| **Water Supply Officer** | `water.officer@nagarsetu.gov.in` | `Officer@123` | Pipeline bursts, potable supply leakages, water main repairs |
| **Drainage Officer** | `drainage.officer@nagarsetu.gov.in` | `Officer@123` | Open manhole covers, storm waterlogging, drain unblocking |
| **Electrical Officer** | `electrical.officer@nagarsetu.gov.in` | `Officer@123` | Live exposed wire emergencies, streetlight luminaire maintenance |

*(Legacy demo emails `admin@civicsense.ai`, `pwd.officer@civicsense.ai`, and `citizen@civicsense.ai` remain active for seamless backward compatibility).*

---

## 📄 License & Attribution
Designed and built for intelligent municipal infrastructure management under modern Digital India open civic governance principles.
© 2026 NagarSetu. All rights reserved.
