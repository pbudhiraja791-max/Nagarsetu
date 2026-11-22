import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class OfficerService {
  /// Accepts assigned issue and marks work in progress
  static Future<CivicIssue> acceptAssignment({
    required Session session,
    required int issueId,
    required int officerUserId,
  }) async {
    final issue = await CivicIssue.db.findById(session, issueId);
    if (issue == null) {
      throw ArgumentError('Issue #$issueId not found');
    }

    issue.status = 'IN_PROGRESS';
    issue.updatedAt = DateTime.now().toUtc();
    return await CivicIssue.db.updateRow(session, issue);
  }

  /// Submits completion evidence with required before and after photographs
  static Future<ResolutionRecord> submitResolution({
    required Session session,
    required int issueId,
    required int officerId,
    required String description,
    required String afterImageReference,
    String? beforeImageReference,
    double? latitude,
    double? longitude,
  }) async {
    final issue = await CivicIssue.db.findById(session, issueId);
    if (issue == null) {
      throw ArgumentError('Issue #$issueId not found');
    }

    // Require photographic proof
    if (afterImageReference.trim().isEmpty) {
      throw ArgumentError('After-repair remediation photograph is mandatory for resolution submission.');
    }

    final resolution = ResolutionRecord(
      issueId: issueId,
      officerId: officerId,
      resolutionDescription: description,
      beforeImageReference: beforeImageReference,
      afterImageReference: afterImageReference,
      latitude: latitude,
      longitude: longitude,
      submittedAt: DateTime.now().toUtc(),
      verificationStatus: 'AWAITING_ADMIN',
    );

    final createdRecord = await ResolutionRecord.db.insertRow(session, resolution);

    // Update issue state
    issue.status = 'RESOLUTION_SUBMITTED';
    issue.updatedAt = DateTime.now().toUtc();
    await CivicIssue.db.updateRow(session, issue);

    // Record audit log
    await AuditLog.db.insertRow(
      session,
      AuditLog(
        actorId: officerId,
        actorRole: 'Officer',
        action: 'RESOLUTION_SUBMITTED',
        entityType: 'ResolutionRecord',
        entityId: createdRecord.id,
        createdAt: DateTime.now().toUtc(),
      ),
    );

    return createdRecord;
  }
}
