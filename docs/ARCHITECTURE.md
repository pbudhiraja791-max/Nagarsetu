# NagarSetu (नगरसेतु) — Architecture & Technical Specifications

**Tagline:** Bridging Citizens. Empowering Cities.  
**Hindi Identity:** नागरिकों और प्रशासन के बीच एक सेतु  
**Product Category:** AI-Powered Civic Intelligence, Public Infrastructure Monitoring & Municipal Accountability Platform

---

## 1. High-Level System Architecture

NagarSetu is built on a decoupled, enterprise-grade architecture connecting citizens, field officers, and municipal leadership into a closed-loop accountability system.

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           NAGARSETU FRONTEND (REACT 18 + TS)                    │
│   • Responsive SaaS UI (Tailwind CSS, Lucide Icons, Glassmorphic Navy Theme)    │
│   • Web Speech API Multilingual Voice Interface (Hindi, Punjabi, English)       │
│   • Interactive Leaflet Map with Geospatial Clustering & Predictive Rings       │
│   • Citizen-Verified Resolution & Ground Comparison Workbench                   │
└────────────────────────────────────────┬────────────────────────────────────────┘
                                         │ REST API (JSON / Multipart HTTPS)
                                         ▼
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           FASTAPI 2.0 APPLICATION CORE                          │
│   • OAuth2 JWT Bearer Authentication & RBAC (Citizen, Officer, Admin)           │
│   • Pydantic v2 Schema Validation & Error Envelopes                             │
│   • Configurable Department SLA Tracker (24h / 48h / 120h / 168h)               │
└──────────────────┬─────────────────────┬──────────────────────┬─────────────────┘
                   │                     │                      │
                   ▼                     ▼                      ▼
┌───────────────────────┐ ┌────────────────────────┐ ┌───────────────────────────┐
│ COMPUTER VISION & NLP │ │  SPATIAL & PREDICTIVE  │ │    RELATIONAL DATABASE    │
│ • OpenCV Defect Canny │ │ • Haversine 50m Dupe   │ │ • Users (Citizen/Officer) │
│ • YOLO Model Loader   │ │ • Recurrence Hotspots  │ │ • 6 NagarSetu Departments │
│ • Multilingual NLP    │ │ • Density Clustering   │ │ • Complaints & History    │
│ • Ground Comparison   │ │ • Public Scorecards    │ │ • ComplaintSupports & Rel │
└───────────────────────┘ └────────────────────────┘ └───────────────────────────┘
```

---

## 2. Explainable 0–100 Priority Scoring Engine

Priority scores are mathematically calculated to ensure complete operational transparency:

$$P = \min\left(100, \text{Round}\left( w_{\text{cat}} \cdot S_{\text{cat}} + w_{\text{conf}} \cdot S_{\text{conf}} + w_{\text{area}} \cdot S_{\text{area}} + w_{\text{dup}} \cdot S_{\text{dup}} + w_{\text{age}} \cdot S_{\text{age}} + E_{\text{env}} \right)\right)$$

### Factor Weights:
- **Category Base Risk ($w_{\text{cat}} = 0.35$):** Life-safety hazard (e.g. Exposed Wire = 96, Open Manhole = 95, Waterlogging = 82, Pothole = 72).
- **AI Confidence ($w_{\text{conf}} = 0.15$):** Vision model classification certainty (0–100).
- **Defect Area Ratio ($w_{\text{area}} = 0.15$):** Geometric area of defect relative to visual frame.
- **Community Endorsement ($w_{\text{dup}} = 0.20$):** Number of nearby citizen supports / verified duplicates ($S_{\text{dup}} = \min(100, N \cdot 18)$).
- **Complaint Aging Backlog ($w_{\text{age}} = 0.15$):** Elapsed hours without resolution ($S_{\text{age}} = \min(100, H \cdot 1.25)$).
- **Environmental Multiplier ($E_{\text{env}}$):** Historical recurrence hotspot (+8) and school/hospital zone (+10).

### NagarSetu Severity Classification & SLA Commitments:
- **0–24 (Low):** Scheduled routine maintenance window within **168 hours (7 days)**.
- **25–49 (Moderate):** Regular maintenance queue within **120 hours (5 days)**.
- **50–74 (High):** Expedited work order dispatch within **48 hours (2 days)**.
- **75–100 (Critical):** Immediate emergency response and barricading within **24 hours**.

---

## 3. Intelligent 50m Spatial Deduplication

When a citizen reports or views an issue at coordinates $(\phi_1, \lambda_1)$:
1. Query active non-resolved complaints created within time window $T = 72\text{ hours}$.
2. Compute great-circle distance $D$ using the Haversine formula:
   $$D = 2R \cdot \arcsin\left(\sqrt{\sin^2\left(\frac{\Delta\phi}{2}\right) + \cos(\phi_1)\cos(\phi_2)\sin^2\left(\frac{\Delta\lambda}{2}\right)}\right)$$
3. If $D \le 50.0\text{ meters}$ and category matches, candidate is flagged for review.
4. **Community Endorsement:** Citizens can click **"Support this issue (+1 Vote)"** to endorse the existing ticket instead of creating redundant clutter, dynamically boosting the original ticket's priority score.

---

## 4. Citizen-Verified Ground Resolution Workflow

Tickets cannot be marked resolved simply by officer status modification:
1. Field officer completes repair and uploads after-repair proof photograph.
2. AI Ground Comparison calculates color correlation and structural edge difference:
   $$\text{Confidence}_{\text{repair}} = 0.5 \cdot \text{HistCorrelation} + 0.5 \cdot \min(1.0, 4 \cdot \text{EdgeChangeRatio})$$
3. Ticket transitions to `RESOLUTION_SUBMITTED` / `CITIZEN_VERIFICATION`.
4. The reporting citizen receives the before/after photos and AI assessment notes.
5. If verified fixed on ground, the citizen clicks **Confirm Fixed** $\rightarrow$ `RESOLVED`.
6. If the defect persists, citizen clicks **Reopen Complaint** $\rightarrow$ `REOPENED` with recorded ground reason.

---

## 5. Predictive Civic Intelligence & Recurrence Forecasting

The geospatial analytics module clusters issues within 200m radius and computes statistical recurrence risk:
- **Frequency Factor (40%):** Density of historical failures in cluster.
- **Unresolved Ratio (30%):** Percentage of complaints still pending.
- **Critical Density (20%):** Prevalence of high-hazard defects.
- **Reopen Factor (10%):** Frequency of citizen-rejected repairs.
- **Risk Indicators:**
  - **Red Ring (Risk $\ge 65$):** High recurrence risk within next 14 days. Pre-emptive clearing required.
  - **Orange Ring ($35 \le \text{Risk} < 65$):** Medium recurrence risk within 30 days.
  - **Green Ring (Risk $< 35$):** Low risk within 60 days.

---

## 6. Official NagarSetu Municipal Departments

1. **Road Maintenance & Paving Department (`DEPT_ROAD`)** — Potholes, road fissures, asphalt repairs.
2. **Sanitation & Waste Management Department (`DEPT_SAN`)** — Illegal garbage dumping, overflowing dustbins.
3. **Water Supply & Distribution Department (`DEPT_WATER`)** — Pipeline bursts, potable water loss.
4. **Drainage & Stormwater Department (`DEPT_DRAIN`)** — Open manholes, urban waterlogging, sewer blockage.
5. **Electrical Infrastructure Department (`DEPT_ELEC`)** — Dangling live wires, streetlights, transformer safety.
6. **Public Works Department (`DEPT_PWD`)** — Broken railings, collapsed footpaths, bridges, municipal assets.
