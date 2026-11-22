import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../middleware/rbac_middleware.dart';
import '../services/officer_service.dart';

class OfficerEndpoint extends Endpoint {
  /// Fetches issues assigned to the authenticated municipal officer
  Future<List<CivicIssue>> getAssignedIssues(Session session) async {
    final user = await RbacMiddleware.requireRole(session, ['Officer', 'Admin']);
    
    // Find officer record linked to this user
    final officer = await Officer.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(user.id ?? -1),
    );

    final officerId = officer?.id ?? user.id ?? 1;

    return await CivicIssue.db.find(
      session,
      where: (t) => t.assignedOfficerId.equals(officerId),
      orderBy: (t) => t.priorityScore.desc(),
    );
  }

  /// Officer acknowledges receipt and transitions issue to IN_PROGRESS
  Future<CivicIssue> acceptAssignment(
    Session session, {
    required int issueId,
  }) async {
    final user = await RbacMiddleware.requireRole(session, ['Officer', 'Admin']);
    return await OfficerService.acceptAssignment(
      session: session,
      issueId: issueId,
      officerUserId: user.id ?? 1,
    );
  }

  /// Submits completion evidence with mandatory after-repair photo
  Future<ResolutionRecord> submitResolution(
    Session session, {
    required int issueId,
    required String description,
    required String afterImageReference,
    String? beforeImageReference,
    double? latitude,
    double? longitude,
  }) async {
    final user = await RbacMiddleware.requireRole(session, ['Officer', 'Admin']);
    final officer = await Officer.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(user.id ?? -1),
    );
    final officerId = officer?.id ?? user.id ?? 1;

    return await OfficerService.submitResolution(
      session: session,
      issueId: issueId,
      officerId: officerId,
      description: description,
      afterImageReference: afterImageReference,
      beforeImageReference: beforeImageReference,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
