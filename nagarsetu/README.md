# NagarSetu – AI-Powered Civic Intelligence Backend
## Flutter + Serverpod (Dart) + PostgreSQL (PostGIS) + AI Integration

This directory contains the production-ready **Serverpod backend** and **companion Flutter client library** for **NagarSetu**, an intelligent civic problem reporting and municipal grievance remediation platform.

---

## 1. System Architecture

```
┌────────────────────────────────────────────────────────┐
│                   Flutter Client App                   │
│           (Uses nagarsetu_client via RPC)              │
└──────────────────────────┬─────────────────────────────┘
                           │ (Serverpod WebSockets / HTTP)
┌──────────────────────────▼─────────────────────────────┐
│           NagarSetu Serverpod Server (Port 8080)        │
│                                                        │
│  [Endpoints Layer]                                     │
│  ├── AuthEndpoint (Register, Login, Password)          │
│  ├── ReportEndpoint (Submit, Tracking, User Reports)   │
│  ├── IssueEndpoint (Nearby, Filtered, Public, Timeline)│
│  ├── AdminEndpoint (Deduplication, Assign, Audit)      │
│  ├── OfficerEndpoint (Assigned Tasks, Submit Proof)    │
│  ├── VerificationEndpoint (Citizen Confirm/Reopen)     │
│  ├── PlacesEndpoint (Landmarks, Community Stories)     │
│  ├── AnalyticsEndpoint (Civic Performance Metrics)     │
│  └── StorageEndpoint (Base64 Image & Audio Ingestion)  │
│                                                        │
│  [Services & Business Logic Layer]                     │
│  ├── DuplicateDetectionService (5-Factor Hybrid Engine)│
│  ├── PriorityCalculationService (Dynamic 0-100 Formula)│
│  ├── ReportCounterService (Atomic Counters & Invariant)│
│  ├── AdminService, OfficerService, VerificationService │
│  └── StorageService (SHA-256 Hashes, File Storage)     │
│                                                        │
│  [Middleware & Security Layer]                         │
│  ├── RbacMiddleware (Citizen, Officer, Admin Guards)   │
│  └── InputValidator (Sanitization, GPS & File Checks)  │
└────────────┬─────────────────────────────┬─────────────┘
             │                             │
┌────────────▼────────────┐   ┌────────────▼─────────────┐
│ PostgreSQL 15+ / PostGIS│   │  Python AI Microservice  │
│  - Spatial Indexes      │   │  (FastAPI on Port 8000)  │
│  - Relational Integrity │   │  - YOLO Object Detection │
│  - Invariant Counters   │   │  - Perceptual Similarity │
│  - Audit Logs           │   │  - Indic NLP (Hi/Pa/En)  │
└─────────────────────────┘   └──────────────────────────┘
```

---

## 2. Core Architectural Invariants

### One Real-World Civic Problem = One Civic Issue, Multiple Citizen Reports
- **`CivicIssue` Table**: Represents the physical defect on the ground (e.g. pothole, garbage dump, broken streetlight).
- **`CitizenReport` Table**: Represents individual submissions made by citizens.
- **Strict Invariant**:
  $$\text{totalReports} = \text{Count}(\text{accepted citizen reports for issue})$$
  $$\text{uniqueCitizens} = \text{Count}(\text{distinct citizenId for issue})$$
- Counter updates are managed exclusively through `ReportCounterService.linkReportToIssue()` and recorded in `ReportCountHistory` for full auditability.

---

## 3. AI-Powered Duplicate Detection (5-Factor Scoring)

When a citizen submits a report, the backend evaluates candidate issues within a category-specific radius (e.g. 30m for Potholes, 75m for Garbage, 50m for Drainage).

Candidates are evaluated across 5 weighted factors:

| Factor | Weight | Evaluation Method |
|---|---|---|
| **Geographical Proximity** | 35% | Haversine distance with non-linear exponential decay |
| **Visual Similarity** | 25% | Deep CNN / YOLO embeddings via Python AI microservice |
| **Description Similarity** | 20% | Semantic cosine similarity via Python AI microservice |
| **Category Consistency** | 15% | Category match (hard gate: 0% match if mismatch) |
| **Temporal Proximity** | 5% | Recency decay curve |

### Automated Decision Thresholds:
- **High Confidence ($\ge 85.0$)**: Auto-linked to existing `CivicIssue`. Citizen notified; issue counter and dynamic priority atomically incremented.
- **Medium Confidence ($60.0 - 84.9$)**: Held in `PENDING_REVIEW` queue for municipal administrator review with full side-by-side telemetry.
- **Low Confidence ($< 60.0$)**: Discarded as duplicate candidate; automatically creates a brand-new `CivicIssue`.

*Deterministic Fallback*: If the Python AI service is unreachable, geographic proximity and category matching provide uninterrupted fallback deduplication.

---

## 4. Dynamic Priority Calculation Engine

Priority is calculated on a 0–100 scale using a transparent 6-factor formula:

$$\text{Priority} = (W_f \times S_f) + (W_s \times S_s) + (W_{ps} \times S_{ps}) + (W_{pop} \times S_{pop}) + (W_a \times S_a) + (W_r \times S_r)$$

- **Report Frequency ($W_f = 0.30$)**: Logarithmic saturation curve based on `totalReports` and `uniqueCitizens`.
- **Severity Assessment ($W_s = 0.25$)**: Physical hazard score (pothole depth, garbage volume, etc.).
- **Public Safety ($W_{ps} = 0.15$)**: Category hazard rating (e.g. Open Manhole = 1.0, Garbage = 0.4).
- **Population Impact ($W_{pop} = 0.10$)**: Proximity to high-density municipal landmarks or schools.
- **Time Aging ($W_a = 0.10$)**: Aging escalation for unresolved issues.
- **Reopened Escalation ($W_r = 0.10$)**: Heavy penalty factor for recurring or poorly fixed defects.

Priority Levels:
- **Critical**: $\ge 80.0$
- **High**: $65.0 - 79.9$
- **Medium**: $40.0 - 64.9$
- **Low**: $< 40.0$

---

## 5. Verification & Resolution Lifecycle

1. **Submission**: Report ingested $\rightarrow$ Deduplication $\rightarrow$ Auto-linked or New Issue created.
2. **Assignment**: Administrator assigns issue to department and field officer (`IssueAssignment`).
3. **Execution**: Field officer acknowledges assignment (`IN_PROGRESS`).
4. **Resolution**: Officer completes work and submits completion proof with mandatory after-repair photograph (`ResolutionRecord`).
5. **Admin Gate**: Municipal admin verifies photographic proof (`AWAITING_CITIZEN`).
6. **Citizen Ground Truth**:
   - **Confirmed Fixed**: Status transitions to `RESOLVED`.
   - **Reopened**: Defect marked `REOPENED`, `reopenedCount` increments, and priority automatically escalates.

---

## 6. API Reference

All APIs are exposed through typed Serverpod RPC methods.

### Authentication (`auth.*`)
- `register({name, email, password, role, phone})` $\rightarrow$ `User`
- `login({email, password})` $\rightarrow$ `User`
- `getProfile()` $\rightarrow$ `User?`
- `changePassword({oldPassword, newPassword})` $\rightarrow$ `bool`

### Citizen Reports (`report.*`)
- `submitReport({description, category, latitude, longitude, imageReference, audioReference, idempotencyKey})` $\rightarrow$ `SubmitReportResponse`
- `getReportById(reportId)` $\rightarrow$ `CitizenReport?`
- `getMyReports()` $\rightarrow$ `List<CitizenReport>`
- `getReportsByIssue(issueId)` $\rightarrow$ `List<CitizenReport>`

### Civic Issues (`issue.*`)
- `getAllIssues({page, limit, status, category, priorityLevel})` $\rightarrow$ `List<CivicIssue>`
- `getIssueById(id)` $\rightarrow$ `CivicIssue?`
- `getNearbyIssues({latitude, longitude, radiusMeters, category})` $\rightarrow$ `List<CivicIssue>`
- `getPublicIssues({page, limit})` $\rightarrow$ `List<CivicIssue>`
- `getIssueTimeline(issueId)` $\rightarrow$ `List<IssueTimelineItem>`

### Administrator Actions (`admin.*`) [Role: Admin]
- `getPendingDuplicateReviews({limit})` $\rightarrow$ `List<CitizenReport>`
- `confirmDuplicate({reportId, remarks})` $\rightarrow$ `CivicIssue`
- `rejectDuplicate({reportId, remarks})` $\rightarrow$ `CivicIssue`
- `assignIssue({issueId, departmentId, officerId, deadline, remarks})` $\rightarrow$ `CivicIssue`
- `updateIssuePriority({issueId, manualScore, manualLevel, reason})` $\rightarrow$ `CivicIssue`
- `reconcileDatabase()` $\rightarrow$ `String (JSON telemetry)`
- `getAuditLogs({limit, offset})` $\rightarrow$ `List<AuditLog>`

### Municipal Field Officers (`officer.*`) [Role: Officer, Admin]
- `getAssignedIssues()` $\rightarrow$ `List<CivicIssue>`
- `acceptAssignment({issueId})` $\rightarrow$ `CivicIssue`
- `submitResolution({issueId, description, afterImageReference, beforeImageReference, latitude, longitude})` $\rightarrow$ `ResolutionRecord`

### Verification (`verification.*`)
- `adminVerifyResolution({issueId, approved, rejectionReason})` $\rightarrow$ `CivicIssue`
- `citizenVerifyResolution({issueId, confirmedFixed, remarks, imageReference})` $\rightarrow$ `CivicIssue`

### Places & Community Stories (`places.*`)
- `createPlace({name, description, address, category, latitude, longitude})` $\rightarrow$ `Place`
- `getPlaces({page, limit})` $\rightarrow$ `List<Place>`
- `getPlaceById(id)` $\rightarrow$ `Place?`
- `createStory({placeId, title, description, imageReference, audioReference, relatedIssueId, visibility})` $\rightarrow$ `Story`
- `getStoriesByPlace({placeId, limit})` $\rightarrow$ `List<Story>`

### Analytics (`analytics.*`)
- `getDashboardAnalytics()` $\rightarrow$ `DashboardAnalytics`

### Storage (`storage.*`)
- `uploadImageBase64({base64Data, fileName})` $\rightarrow$ `String` (URL reference)
- `uploadAudioBase64({base64Data, fileName})` $\rightarrow$ `String` (URL reference)

---

## 7. Flutter Client Integration Example

In your Flutter app (`pubspec.yaml`), add a dependency on `nagarsetu_client`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  nagarsetu_client:
    path: ../nagarsetu/nagarsetu_client
  serverpod_flutter: ^4.1.2
```

Initialize the client and invoke endpoints:

```dart
import 'package:flutter/material.dart';
import 'package:nagarsetu_client/nagarsetu_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

// Initialize client connected to Serverpod backend
final client = Client('http://10.0.2.2:8080/')
  ..connectivityMonitor = FlutterConnectivityMonitor();

void submitCivicReport() async {
  try {
    final response = await client.report.submitReport(
      description: 'Massive pothole near bus stand leaking mud water',
      category: 'Pothole',
      latitude: 30.4842,
      longitude: 76.5938,
      address: 'Main GT Road, Rajpura',
      imageReference: '/uploads/image/pothole_evidence.jpg',
    );

    print('Report submitted! ID: ${response.reportId}');
    print('Consolidated under Issue: ${response.issueCode}');
    print('Duplicate Detection Decision: ${response.duplicateDecision}');
  } catch (e) {
    print('Submission error: $e');
  }
}
```

---

## 8. Running the Backend Locally

### Prerequisites
- Dart SDK 3.4+
- PostgreSQL 14+ with PostGIS extension enabled
- Python 3.10+ (for Python AI microservice)

### Step 1: Start PostgreSQL with PostGIS
Ensure your PostgreSQL database is running with PostGIS enabled:
```sql
CREATE DATABASE nagarsetu;
\c nagarsetu;
CREATE EXTENSION IF NOT EXISTS postgis;
```

### Step 2: Apply Migrations & Generate Protocols
```powershell
cd nagarsetu/nagarsetu_server
serverpod generate
```

### Step 3: Run the Serverpod Server
```powershell
cd nagarsetu/nagarsetu_server
dart bin/main.dart --apply-migrations
```
The Serverpod backend will bind to `http://localhost:8080` (Web server on `8082`).

### Step 4: Run Tests
```powershell
cd nagarsetu/nagarsetu_server
dart test test/unit_test.dart
```
All unit tests run and pass without requiring external service dependencies.
