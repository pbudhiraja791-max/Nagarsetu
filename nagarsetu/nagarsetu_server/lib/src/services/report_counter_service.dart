import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'priority_calculation_service.dart';

class ReportCounterService {
  /// Links an accepted citizen report to a CivicIssue, updating counters atomically
  static Future<CivicIssue> linkReportToIssue({
    required Session session,
    required CivicIssue issue,
    required CitizenReport report,
    required String actionType, // 'AUTO_LINKED', 'ADMIN_CONFIRMED', 'ORIGINAL_CREATION'
  }) async {
    final prevCount = issue.totalReports;

    // Check if citizen has previously reported this specific issue
    final previousReportsByCitizen = await CitizenReport.db.find(
      session,
      where: (t) => t.issueId.equals(issue.id!) & t.citizenId.equals(report.citizenId) & t.counted.equals(true),
    );

    final isNewCitizen = previousReportsByCitizen.isEmpty;

    // Mark report as counted and accepted
    report.issueId = issue.id;
    report.counted = true;
    report.submissionStatus = 'accepted';
    report.repeatReporter = !isNewCitizen;
    await CitizenReport.db.updateRow(session, report);

    // Update issue counts atomically
    final newTotalReports = issue.totalReports + 1;
    final newUniqueCitizens = isNewCitizen ? (issue.uniqueCitizens + 1) : issue.uniqueCitizens;

    // Recalculate priority dynamically with new counts
    final priorityResult = PriorityCalculationService.calculatePriority(
      totalReports: newTotalReports,
      uniqueCitizens: newUniqueCitizens,
      severityScore: issue.priorityScore, // Base severity
      category: issue.category,
      firstReportedAt: issue.firstReportedAt,
      reopenedCount: issue.reopenedCount,
    );

    issue.totalReports = newTotalReports;
    issue.uniqueCitizens = newUniqueCitizens;
    issue.priorityScore = priorityResult.score;
    issue.priorityLevel = priorityResult.level;
    issue.priorityExplanation = priorityResult.explanation;
    issue.lastReportedAt = DateTime.now().toUtc();
    issue.updatedAt = DateTime.now().toUtc();

    final updatedIssue = await CivicIssue.db.updateRow(session, issue);

    // Record count history audit log
    await ReportCountHistory.db.insertRow(
      session,
      ReportCountHistory(
        issueId: issue.id!,
        reportId: report.id!,
        previousCount: prevCount,
        newCount: newTotalReports,
        actionType: actionType,
        createdAt: DateTime.now().toUtc(),
      ),
    );

    return updatedIssue;
  }

  /// Recomputes counts from ground truth database records and resolves any discrepancies
  static Future<Map<String, int>> recomputeAndUpdateCounters(
    Session session,
    int issueId,
  ) async {
    final issue = await CivicIssue.db.findById(session, issueId);
    if (issue == null) {
      throw ArgumentError('Issue #$issueId not found');
    }

    final acceptedReports = await CitizenReport.db.find(
      session,
      where: (t) => t.issueId.equals(issueId) & t.counted.equals(true) & t.submissionStatus.equals('accepted'),
    );

    final exactTotalReports = acceptedReports.length;
    final uniqueCitizenIds = acceptedReports.map((r) => r.citizenId).toSet();
    final exactUniqueCitizens = uniqueCitizenIds.length;

    if (issue.totalReports != exactTotalReports || issue.uniqueCitizens != exactUniqueCitizens) {
      issue.totalReports = exactTotalReports;
      issue.uniqueCitizens = exactUniqueCitizens;
      issue.updatedAt = DateTime.now().toUtc();
      await CivicIssue.db.updateRow(session, issue);
    }

    return {
      'totalReports': exactTotalReports,
      'uniqueCitizens': exactUniqueCitizens,
    };
  }

  /// Reconciles all civic issues across the database, returning audit telemetry
  static Future<Map<String, dynamic>> reconcileAllIssues(Session session) async {
    final allIssues = await CivicIssue.db.find(session);
    int checkedCount = 0;
    int fixedDiscrepancies = 0;

    for (final issue in allIssues) {
      checkedCount++;
      final acceptedReports = await CitizenReport.db.find(
        session,
        where: (t) => t.issueId.equals(issue.id!) & t.counted.equals(true) & t.submissionStatus.equals('accepted'),
      );

      final exactTotal = acceptedReports.length;
      final exactUnique = acceptedReports.map((r) => r.citizenId).toSet().length;

      if (issue.totalReports != exactTotal || issue.uniqueCitizens != exactUnique) {
        issue.totalReports = exactTotal;
        issue.uniqueCitizens = exactUnique;
        issue.updatedAt = DateTime.now().toUtc();
        await CivicIssue.db.updateRow(session, issue);
        fixedDiscrepancies++;
      }
    }

    return {
      'issuesChecked': checkedCount,
      'discrepanciesFound': fixedDiscrepancies,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
  }
}
