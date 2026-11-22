import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import 'priority_calculation_service.dart';

class VerificationService {
  /// Admin approves or rejects resolution evidence submitted by officer
  static Future<CivicIssue> adminVerifyResolution({
    required Session session,
    required int issueId,
    required int adminUserId,
    required bool approved,
    String? rejectionReason,
  }) async {
    final issue = await CivicIssue.db.findById(session, issueId);
    if (issue == null) {
      throw ArgumentError('Issue #$issueId not found');
    }

    final latestResolution = await ResolutionRecord.db.findFirstRow(
      session,
      where: (t) => t.issueId.equals(issueId),
      orderBy: (t) => t.submittedAt.desc(),
    );

    if (approved) {
      if (latestResolution != null) {
        latestResolution.verificationStatus = 'AWAITING_CITIZEN';
        latestResolution.verifiedBy = adminUserId;
        latestResolution.verifiedAt = DateTime.now().toUtc();
        await ResolutionRecord.db.updateRow(session, latestResolution);
      }
      issue.status = 'AWAITING_CITIZEN_VERIFICATION';
    } else {
      if (latestResolution != null) {
        latestResolution.verificationStatus = 'REJECTED';
        latestResolution.rejectionReason = rejectionReason ?? 'Evidence insufficient.';
        latestResolution.verifiedBy = adminUserId;
        latestResolution.verifiedAt = DateTime.now().toUtc();
        await ResolutionRecord.db.updateRow(session, latestResolution);
      }
      issue.status = 'IN_PROGRESS'; // Sent back to field team
    }

    issue.updatedAt = DateTime.now().toUtc();
    return await CivicIssue.db.updateRow(session, issue);
  }

  /// Citizen confirms fixed or reopens if defect persists
  static Future<CivicIssue> citizenVerifyResolution({
    required Session session,
    required int issueId,
    required int citizenId,
    required bool confirmedFixed,
    String? remarks,
    String? imageReference,
  }) async {
    final issue = await CivicIssue.db.findById(session, issueId);
    if (issue == null) {
      throw ArgumentError('Issue #$issueId not found');
    }

    await CitizenVerification.db.insertRow(
      session,
      CitizenVerification(
        issueId: issueId,
        citizenId: citizenId,
        verificationStatus: confirmedFixed ? 'CONFIRMED_FIXED' : 'REOPENED_UNRESOLVED',
        remarks: remarks,
        imageReference: imageReference,
        createdAt: DateTime.now().toUtc(),
      ),
    );

    if (confirmedFixed) {
      issue.status = 'RESOLVED';
      issue.resolvedAt = DateTime.now().toUtc();
    } else {
      // Reopen issue
      issue.reopenedCount += 1;
      issue.status = 'REOPENED';

      // Recalculate priority to escalate reopened defect
      final prio = PriorityCalculationService.calculatePriority(
        totalReports: issue.totalReports,
        uniqueCitizens: issue.uniqueCitizens,
        severityScore: issue.priorityScore,
        category: issue.category,
        firstReportedAt: issue.firstReportedAt,
        reopenedCount: issue.reopenedCount,
      );
      issue.priorityScore = prio.score;
      issue.priorityLevel = prio.level;
      issue.priorityExplanation = 'Reopened by citizen: ${remarks ?? "Defect persists."}';
    }

    issue.updatedAt = DateTime.now().toUtc();
    return await CivicIssue.db.updateRow(session, issue);
  }
}
