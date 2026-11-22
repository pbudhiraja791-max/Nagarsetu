import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../utils/code_generator.dart';
import 'report_counter_service.dart';
import 'priority_calculation_service.dart';
import 'notification_service.dart';

class AdminService {
  /// Confirms that a pending report is a duplicate of an existing issue
  static Future<CivicIssue> confirmDuplicate({
    required Session session,
    required int reportId,
    required int adminUserId,
    String? remarks,
  }) async {
    final report = await CitizenReport.db.findById(session, reportId);
    if (report == null) {
      throw ArgumentError('Citizen report #$reportId not found');
    }

    if (report.issueId == null) {
      throw StateError('Report has no suggested issue candidate to link to.');
    }

    // Double-confirmation protection: if already accepted and counted, return early
    if (report.submissionStatus == 'accepted' && report.counted) {
      final existingIssue = await CivicIssue.db.findById(session, report.issueId!);
      if (existingIssue != null) return existingIssue;
    }

    final targetIssue = await CivicIssue.db.findById(session, report.issueId!);
    if (targetIssue == null) {
      throw ArgumentError('Target civic issue #${report.issueId} not found.');
    }

    // Atomically link and increment counts
    final updatedIssue = await ReportCounterService.linkReportToIssue(
      session: session,
      issue: targetIssue,
      report: report,
      actionType: 'ADMIN_CONFIRMED',
    );

    // Record admin review history
    await AuditLog.db.insertRow(
      session,
      AuditLog(
        actorId: adminUserId,
        actorRole: 'Admin',
        action: 'DUPLICATE_CONFIRMED',
        entityType: 'CitizenReport',
        entityId: report.id,
        newValues: jsonEncode({
          'targetIssueId': updatedIssue.id,
          'remarks': remarks ?? 'Confirmed duplicate by administrator',
          'totalReports': updatedIssue.totalReports,
        }),
        createdAt: DateTime.now().toUtc(),
      ),
    );

    // Notify citizen
    await NotificationService.sendNotification(
      session: session,
      userId: report.citizenId,
      title: 'Report Consolidated',
      message: 'Your report #${report.id} was verified and linked to civic problem ${updatedIssue.issueCode}.',
      notificationType: 'DUPLICATE_CONFIRMED',
      relatedIssueId: updatedIssue.id,
    );

    return updatedIssue;
  }

  /// Rejects duplicate suggestion and creates a new independent CivicIssue
  static Future<CivicIssue> rejectDuplicate({
    required Session session,
    required int reportId,
    required int adminUserId,
    String? remarks,
  }) async {
    final report = await CitizenReport.db.findById(session, reportId);
    if (report == null) {
      throw ArgumentError('Report #$reportId not found');
    }

    // Calculate priority for the new independent issue
    final priorityRes = PriorityCalculationService.calculatePriority(
      totalReports: 1,
      uniqueCitizens: 1,
      severityScore: 50.0,
      category: report.category,
      firstReportedAt: report.createdAt,
      reopenedCount: 0,
    );

    // Create new civic issue
    final newIssue = CivicIssue(
      issueCode: CodeGenerator.generateIssueCode(0),
      title: '${report.category} at ${report.address ?? "Reported Area"}',
      category: report.category,
      descriptionSummary: report.description,
      locationName: report.address,
      address: report.address,
      latitude: report.latitude,
      longitude: report.longitude,
      status: 'SUBMITTED',
      priorityScore: priorityRes.score,
      priorityLevel: priorityRes.level,
      priorityExplanation: priorityRes.explanation,
      totalReports: 1,
      uniqueCitizens: 1,
      firstReportedAt: report.createdAt,
      lastReportedAt: report.createdAt,
      reopenedCount: 0,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    final createdIssue = await CivicIssue.db.insertRow(session, newIssue);

    // Update report to point to new issue
    report.issueId = createdIssue.id;
    report.submissionStatus = 'accepted';
    report.counted = true;
    report.linkMethod = 'admin_rejected_duplicate';
    await CitizenReport.db.updateRow(session, report);

    await AuditLog.db.insertRow(
      session,
      AuditLog(
        actorId: adminUserId,
        actorRole: 'Admin',
        action: 'DUPLICATE_REJECTED',
        entityType: 'CitizenReport',
        entityId: report.id,
        newValues: jsonEncode({
          'newIssueId': createdIssue.id,
          'issueCode': createdIssue.issueCode,
          'remarks': remarks ?? 'Rejected duplicate: distinct physical problem.',
        }),
        createdAt: DateTime.now().toUtc(),
      ),
    );

    return createdIssue;
  }

  /// Assigns issue to department and field officer
  static Future<CivicIssue> assignIssue({
    required Session session,
    required int issueId,
    required int departmentId,
    required int adminUserId,
    int? officerId,
    DateTime? deadline,
    String? remarks,
  }) async {
    final issue = await CivicIssue.db.findById(session, issueId);
    if (issue == null) {
      throw ArgumentError('Issue #$issueId not found');
    }

    issue.assignedDepartmentId = departmentId;
    issue.assignedOfficerId = officerId;
    issue.status = 'ASSIGNED';
    issue.updatedAt = DateTime.now().toUtc();
    final updated = await CivicIssue.db.updateRow(session, issue);

    await IssueAssignment.db.insertRow(
      session,
      IssueAssignment(
        issueId: issueId,
        departmentId: departmentId,
        officerId: officerId,
        assignedBy: adminUserId,
        assignedAt: DateTime.now().toUtc(),
        deadline: deadline,
        assignmentStatus: 'ASSIGNED',
        remarks: remarks,
      ),
    );

    if (officerId != null) {
      final officer = await Officer.db.findById(session, officerId);
      if (officer != null) {
        await NotificationService.sendNotification(
          session: session,
          userId: officer.userId,
          title: 'New Issue Assignment',
          message: 'You have been assigned issue ${issue.issueCode}: ${issue.title}.',
          notificationType: 'ISSUE_ASSIGNED',
          relatedIssueId: issue.id,
        );
      }
    }

    return updated;
  }

  /// Manually overrides priority score and level for an issue
  static Future<CivicIssue> overridePriority({
    required Session session,
    required int issueId,
    required double manualScore,
    required String manualLevel,
    required int adminUserId,
    required String reason,
  }) async {
    final issue = await CivicIssue.db.findById(session, issueId);
    if (issue == null) {
      throw ArgumentError('Issue #$issueId not found');
    }

    final oldScore = issue.priorityScore;
    final oldLevel = issue.priorityLevel;

    issue.priorityScore = manualScore;
    issue.priorityLevel = manualLevel;
    issue.priorityExplanation = 'Admin override: $reason';
    issue.updatedAt = DateTime.now().toUtc();
    final updated = await CivicIssue.db.updateRow(session, issue);

    await AuditLog.db.insertRow(
      session,
      AuditLog(
        actorId: adminUserId,
        actorRole: 'Admin',
        action: 'PRIORITY_OVERRIDDEN',
        entityType: 'CivicIssue',
        entityId: issue.id,
        oldValues: jsonEncode({'score': oldScore, 'level': oldLevel}),
        newValues: jsonEncode({'score': manualScore, 'level': manualLevel, 'reason': reason}),
        createdAt: DateTime.now().toUtc(),
      ),
    );

    return updated;
  }
}
