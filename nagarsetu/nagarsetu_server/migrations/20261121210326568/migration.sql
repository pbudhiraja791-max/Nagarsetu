BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "audit_logs" (
    "id" bigserial PRIMARY KEY,
    "actorId" bigint,
    "actorRole" text,
    "action" text NOT NULL,
    "entityType" text NOT NULL,
    "entityId" bigint,
    "oldValues" text,
    "newValues" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "audit_entity_idx" ON "audit_logs" USING btree ("entityType", "entityId");
CREATE INDEX "audit_actor_idx" ON "audit_logs" USING btree ("actorId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "citizen_reports" (
    "id" bigserial PRIMARY KEY,
    "citizenId" bigint NOT NULL,
    "issueId" bigint,
    "description" text NOT NULL,
    "category" text NOT NULL,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "address" text,
    "imageReference" text,
    "audioReference" text,
    "aiDetectedCategory" text,
    "aiConfidence" double precision,
    "duplicateDetectionScore" double precision,
    "duplicateDetectionStatus" text NOT NULL,
    "submissionStatus" text NOT NULL,
    "idempotencyKey" text,
    "counted" boolean NOT NULL,
    "linkMethod" text,
    "repeatReporter" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "citizen_report_issue_idx" ON "citizen_reports" USING btree ("issueId");
CREATE INDEX "citizen_report_citizen_idx" ON "citizen_reports" USING btree ("citizenId");
CREATE UNIQUE INDEX "citizen_report_idem_idx" ON "citizen_reports" USING btree ("idempotencyKey");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "citizen_verifications" (
    "id" bigserial PRIMARY KEY,
    "issueId" bigint NOT NULL,
    "citizenId" bigint NOT NULL,
    "verificationStatus" text NOT NULL,
    "remarks" text,
    "imageReference" text,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "citizen_verif_issue_idx" ON "citizen_verifications" USING btree ("issueId");
CREATE INDEX "citizen_verif_citizen_idx" ON "citizen_verifications" USING btree ("citizenId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "civic_issues" (
    "id" bigserial PRIMARY KEY,
    "issueCode" text NOT NULL,
    "title" text NOT NULL,
    "category" text NOT NULL,
    "descriptionSummary" text,
    "locationName" text,
    "address" text,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "status" text NOT NULL,
    "priorityScore" double precision NOT NULL,
    "priorityLevel" text NOT NULL,
    "priorityExplanation" text,
    "totalReports" bigint NOT NULL,
    "uniqueCitizens" bigint NOT NULL,
    "assignedDepartmentId" bigint,
    "assignedOfficerId" bigint,
    "firstReportedAt" timestamp without time zone NOT NULL,
    "lastReportedAt" timestamp without time zone NOT NULL,
    "resolvedAt" timestamp without time zone,
    "reopenedCount" bigint NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "civic_issue_code_idx" ON "civic_issues" USING btree ("issueCode");
CREATE INDEX "civic_issue_coords_idx" ON "civic_issues" USING btree ("latitude", "longitude");
CREATE INDEX "civic_issue_status_idx" ON "civic_issues" USING btree ("status");
CREATE INDEX "civic_issue_cat_idx" ON "civic_issues" USING btree ("category");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "departments" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "contactEmail" text,
    "contactPhone" text,
    "isActive" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "department_name_idx" ON "departments" USING btree ("name");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "issue_assignments" (
    "id" bigserial PRIMARY KEY,
    "issueId" bigint NOT NULL,
    "departmentId" bigint NOT NULL,
    "officerId" bigint,
    "assignedBy" bigint NOT NULL,
    "assignedAt" timestamp without time zone NOT NULL,
    "deadline" timestamp without time zone,
    "assignmentStatus" text NOT NULL,
    "remarks" text
);

-- Indexes
CREATE INDEX "issue_assign_issue_idx" ON "issue_assignments" USING btree ("issueId");
CREATE INDEX "issue_assign_officer_idx" ON "issue_assignments" USING btree ("officerId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "issue_match_history" (
    "id" bigserial PRIMARY KEY,
    "reportId" bigint NOT NULL,
    "matchedIssueId" bigint,
    "geographicSimilarity" double precision NOT NULL,
    "imageSimilarity" double precision NOT NULL,
    "descriptionSimilarity" double precision NOT NULL,
    "categorySimilarity" double precision NOT NULL,
    "temporalSimilarity" double precision NOT NULL,
    "combinedSimilarityScore" double precision NOT NULL,
    "matchingDecision" text NOT NULL,
    "decisionReason" text,
    "reviewedBy" bigint,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "match_history_report_idx" ON "issue_match_history" USING btree ("reportId");
CREATE INDEX "match_history_issue_idx" ON "issue_match_history" USING btree ("matchedIssueId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "notifications" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "title" text NOT NULL,
    "message" text NOT NULL,
    "notificationType" text NOT NULL,
    "relatedIssueId" bigint,
    "isRead" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "notification_user_idx" ON "notifications" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "officers" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "departmentId" bigint NOT NULL,
    "employeeCode" text NOT NULL,
    "designation" text,
    "assignedArea" text,
    "isActive" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "officer_emp_code_idx" ON "officers" USING btree ("employeeCode");
CREATE INDEX "officer_user_idx" ON "officers" USING btree ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "places" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "address" text,
    "category" text,
    "latitude" double precision NOT NULL,
    "longitude" double precision NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "place_coords_idx" ON "places" USING btree ("latitude", "longitude");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "report_count_history" (
    "id" bigserial PRIMARY KEY,
    "issueId" bigint NOT NULL,
    "reportId" bigint NOT NULL,
    "previousCount" bigint NOT NULL,
    "newCount" bigint NOT NULL,
    "actionType" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "count_hist_issue_idx" ON "report_count_history" USING btree ("issueId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "resolution_records" (
    "id" bigserial PRIMARY KEY,
    "issueId" bigint NOT NULL,
    "officerId" bigint NOT NULL,
    "resolutionDescription" text NOT NULL,
    "beforeImageReference" text,
    "afterImageReference" text,
    "latitude" double precision,
    "longitude" double precision,
    "submittedAt" timestamp without time zone NOT NULL,
    "verificationStatus" text NOT NULL,
    "verifiedBy" bigint,
    "verifiedAt" timestamp without time zone,
    "rejectionReason" text
);

-- Indexes
CREATE INDEX "resolution_issue_idx" ON "resolution_records" USING btree ("issueId");
CREATE INDEX "resolution_officer_idx" ON "resolution_records" USING btree ("officerId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "stories" (
    "id" bigserial PRIMARY KEY,
    "placeId" bigint NOT NULL,
    "authorId" bigint NOT NULL,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "imageReference" text,
    "audioReference" text,
    "relatedIssueId" bigint,
    "visibility" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "story_place_idx" ON "stories" USING btree ("placeId");
CREATE INDEX "story_author_idx" ON "stories" USING btree ("authorId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "users" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "email" text NOT NULL,
    "phone" text,
    "passwordHash" text,
    "role" text NOT NULL,
    "profileImage" text,
    "isActive" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "updatedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "user_email_idx" ON "users" USING btree ("email");


--
-- MIGRATION VERSION FOR nagarsetu
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('nagarsetu', '20261121210326568', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261121210326568', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260824182259319', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182259319', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20261015164015382', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261015164015382', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260924105232991', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260924105232991', "timestamp" = now();


COMMIT;
