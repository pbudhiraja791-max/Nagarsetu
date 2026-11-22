import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../validators/input_validator.dart';
import '../utils/code_generator.dart';
import '../middleware/rbac_middleware.dart';
import '../services/duplicate_detection_service.dart';
import '../services/report_counter_service.dart';
import '../services/priority_calculation_service.dart';
import '../services/notification_service.dart';

class ReportEndpoint extends Endpoint {
  final _duplicateService = DuplicateDetectionService();

  /// Submits a citizen report with AI duplicate detection, atomic counters, and idempotency protection
  Future<SubmitReportResponse> submitReport(
    Session session, {
    required String description,
    required String category,
    required double latitude,
    required double longitude,
    String? address,
    String? imageReference,
    String? audioReference,
    String? idempotencyKey,
  }) async {
    // 1. Validate inputs
    InputValidator.validateReportInput(
      description: description,
      category: category,
      latitude: latitude,
      longitude: longitude,
    );

    // 2. Idempotency check: prevent duplicate processing on network retries
    if (idempotencyKey != null && idempotencyKey.trim().isNotEmpty) {
      final existingReport = await CitizenReport.db.findFirstRow(
        session,
        where: (t) => t.idempotencyKey.equals(idempotencyKey.trim()),
      );
      if (existingReport != null) {
        CivicIssue? existingIssue;
        if (existingReport.issueId != null) {
          existingIssue = await CivicIssue.db.findById(session, existingReport.issueId!);
        }
        return SubmitReportResponse(
          reportId: existingReport.id!,
          issueId: existingReport.issueId,
          issueCode: existingIssue?.issueCode,
          totalReports: existingIssue?.totalReports ?? 1,
          uniqueCitizens: existingIssue?.uniqueCitizens ?? 1,
          duplicateDetected: existingReport.duplicateDetectionStatus == 'AUTO_LINKED',
          status: existingReport.submissionStatus,
          trackingId: CodeGenerator.generateTrackingId(existingReport.id),
        );
      }
    }

    // 3. Resolve user identity
    final currentUser = await RbacMiddleware.getCurrentUser(session);
    final citizenId = currentUser?.id ?? 1; // Default to initial citizen if session pending

    // 4. Run AI Multi-Factor Duplicate Detection
    final dedupResult = await _duplicateService.evaluateDuplicate(
      session: session,
      category: category,
      description: description,
      latitude: latitude,
      longitude: longitude,
      imageReference: imageReference,
    );

    // 5. Handle decision tree
    int? finalIssueId;
    String? finalIssueCode;
    int finalTotalReports = 1;
    int finalUniqueCitizens = 1;
    String duplicateStatus;
    String submissionStatus;
    String linkMethod = 'original_report';

    if (dedupResult.decision == 'HIGH_CONFIDENCE' && dedupResult.candidateIssueId != null) {
      // HIGH CONFIDENCE: Auto-link to existing civic issue
      final candidateIssue = await CivicIssue.db.findById(session, dedupResult.candidateIssueId!);
      if (candidateIssue != null) {
        duplicateStatus = 'AUTO_LINKED';
        submissionStatus = 'accepted';
        linkMethod = 'auto_ai';

        final newReport = await CitizenReport.db.insertRow(
          session,
          CitizenReport(
            citizenId: citizenId,
            issueId: candidateIssue.id,
            description: description,
            category: category,
            latitude: latitude,
            longitude: longitude,
            address: address,
            imageReference: imageReference,
            audioReference: audioReference,
            aiDetectedCategory: category,
            aiConfidence: dedupResult.confidence / 100.0,
            duplicateDetectionScore: dedupResult.combinedScore,
            duplicateDetectionStatus: duplicateStatus,
            submissionStatus: submissionStatus,
            idempotencyKey: idempotencyKey,
            counted: false, // will be counted via counter service
            linkMethod: linkMethod,
            repeatReporter: false,
            createdAt: DateTime.now().toUtc(),
          ),
        );

        // Atomically link and update totalReports / uniqueCitizens
        final updatedIssue = await ReportCounterService.linkReportToIssue(
          session: session,
          issue: candidateIssue,
          report: newReport,
          actionType: 'AUTO_LINKED',
        );

        finalIssueId = updatedIssue.id;
        finalIssueCode = updatedIssue.issueCode;
        finalTotalReports = updatedIssue.totalReports;
        finalUniqueCitizens = updatedIssue.uniqueCitizens;

        // Record Match Telemetry
        await IssueMatchHistory.db.insertRow(
          session,
          IssueMatchHistory(
            reportId: newReport.id!,
            matchedIssueId: updatedIssue.id,
            geographicSimilarity: dedupResult.geoSimilarity,
            imageSimilarity: dedupResult.imageSimilarity,
            descriptionSimilarity: dedupResult.descriptionSimilarity,
            categorySimilarity: dedupResult.categorySimilarity,
            temporalSimilarity: dedupResult.temporalSimilarity,
            combinedSimilarityScore: dedupResult.combinedScore,
            matchingDecision: dedupResult.decision,
            decisionReason: dedupResult.reasoning,
            createdAt: DateTime.now().toUtc(),
          ),
        );

        return SubmitReportResponse(
          reportId: newReport.id!,
          issueId: finalIssueId,
          issueCode: finalIssueCode,
          totalReports: finalTotalReports,
          uniqueCitizens: finalUniqueCitizens,
          duplicateDetected: true,
          status: submissionStatus,
          trackingId: CodeGenerator.generateTrackingId(newReport.id),
        );
      }
    }

    if (dedupResult.decision == 'MEDIUM_CONFIDENCE' && dedupResult.candidateIssueId != null) {
      // MEDIUM CONFIDENCE: Hold in pending_review queue for admin inspection
      duplicateStatus = 'PENDING_REVIEW';
      submissionStatus = 'pending_review';
      linkMethod = 'pending_admin_review';

      final pendingReport = await CitizenReport.db.insertRow(
        session,
        CitizenReport(
          citizenId: citizenId,
          issueId: dedupResult.candidateIssueId,
          description: description,
          category: category,
          latitude: latitude,
          longitude: longitude,
          address: address,
          imageReference: imageReference,
          audioReference: audioReference,
          aiDetectedCategory: category,
          aiConfidence: dedupResult.confidence / 100.0,
          duplicateDetectionScore: dedupResult.combinedScore,
          duplicateDetectionStatus: duplicateStatus,
          submissionStatus: submissionStatus,
          idempotencyKey: idempotencyKey,
          counted: false,
          linkMethod: linkMethod,
          repeatReporter: false,
          createdAt: DateTime.now().toUtc(),
        ),
      );

      // Record match telemetry for admin review
      await IssueMatchHistory.db.insertRow(
        session,
        IssueMatchHistory(
          reportId: pendingReport.id!,
          matchedIssueId: dedupResult.candidateIssueId,
          geographicSimilarity: dedupResult.geoSimilarity,
          imageSimilarity: dedupResult.imageSimilarity,
          descriptionSimilarity: dedupResult.descriptionSimilarity,
          categorySimilarity: dedupResult.categorySimilarity,
          temporalSimilarity: dedupResult.temporalSimilarity,
          combinedSimilarityScore: dedupResult.combinedScore,
          matchingDecision: dedupResult.decision,
          decisionReason: dedupResult.reasoning,
          createdAt: DateTime.now().toUtc(),
        ),
      );

      return SubmitReportResponse(
        reportId: pendingReport.id!,
        issueId: dedupResult.candidateIssueId,
        issueCode: 'PENDING-REVIEW',
        totalReports: 0,
        uniqueCitizens: 0,
        duplicateDetected: true,
        status: submissionStatus,
        trackingId: CodeGenerator.generateTrackingId(pendingReport.id),
      );
    }

    // LOW CONFIDENCE: Create a new CivicIssue
    final priorityRes = PriorityCalculationService.calculatePriority(
      totalReports: 1,
      uniqueCitizens: 1,
      severityScore: 50.0,
      category: category,
      firstReportedAt: DateTime.now().toUtc(),
      reopenedCount: 0,
    );

    final newIssue = await CivicIssue.db.insertRow(
      session,
      CivicIssue(
        issueCode: CodeGenerator.generateIssueCode(0),
        title: '$category at ${address ?? "Reported Area"}',
        category: category,
        descriptionSummary: description,
        locationName: address,
        address: address,
        latitude: latitude,
        longitude: longitude,
        status: 'SUBMITTED',
        priorityScore: priorityRes.score,
        priorityLevel: priorityRes.level,
        priorityExplanation: priorityRes.explanation,
        totalReports: 1,
        uniqueCitizens: 1,
        firstReportedAt: DateTime.now().toUtc(),
        lastReportedAt: DateTime.now().toUtc(),
        reopenedCount: 0,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ),
    );

    final newReport = await CitizenReport.db.insertRow(
      session,
      CitizenReport(
        citizenId: citizenId,
        issueId: newIssue.id,
        description: description,
        category: category,
        latitude: latitude,
        longitude: longitude,
        address: address,
        imageReference: imageReference,
        audioReference: audioReference,
        aiDetectedCategory: category,
        aiConfidence: 0.90,
        duplicateDetectionScore: dedupResult.combinedScore,
        duplicateDetectionStatus: 'NEW_ISSUE',
        submissionStatus: 'accepted',
        idempotencyKey: idempotencyKey,
        counted: true,
        linkMethod: 'original_report',
        repeatReporter: false,
        createdAt: DateTime.now().toUtc(),
      ),
    );

    await NotificationService.sendNotification(
      session: session,
      userId: citizenId,
      title: 'Report Registered',
      message: 'New civic problem ${newIssue.issueCode} registered successfully.',
      notificationType: 'REPORT_SUBMITTED',
      relatedIssueId: newIssue.id,
    );

    return SubmitReportResponse(
      reportId: newReport.id!,
      issueId: newIssue.id,
      issueCode: newIssue.issueCode,
      totalReports: 1,
      uniqueCitizens: 1,
      duplicateDetected: false,
      status: 'accepted',
      trackingId: CodeGenerator.generateTrackingId(newReport.id),
    );
  }

  /// Retrieves details for a specific citizen report
  Future<CitizenReport?> getReportById(Session session, int reportId) async {
    return await CitizenReport.db.findById(session, reportId);
  }

  /// Retrieves reports submitted by the current authenticated citizen
  Future<List<CitizenReport>> getMyReports(Session session) async {
    final user = await RbacMiddleware.requireUser(session);
    return await CitizenReport.db.find(
      session,
      where: (t) => t.citizenId.equals(user.id!),
      orderBy: (t) => t.createdAt.desc(),
    );
  }

  /// Retrieves all citizen reports consolidated under a civic issue
  Future<List<CitizenReport>> getReportsByIssue(Session session, int issueId) async {
    return await CitizenReport.db.find(
      session,
      where: (t) => t.issueId.equals(issueId) & t.counted.equals(true),
      orderBy: (t) => t.createdAt.desc(),
    );
  }
}
