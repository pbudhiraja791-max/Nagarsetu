import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../middleware/rbac_middleware.dart';
import '../services/verification_service.dart';

class VerificationEndpoint extends Endpoint {
  /// Admin reviews resolution evidence submitted by officer
  Future<CivicIssue> adminVerifyResolution(
    Session session, {
    required int issueId,
    required bool approved,
    String? rejectionReason,
  }) async {
    final user = await RbacMiddleware.requireRole(session, ['Admin']);
    return await VerificationService.adminVerifyResolution(
      session: session,
      issueId: issueId,
      adminUserId: user.id ?? 1,
      approved: approved,
      rejectionReason: rejectionReason,
    );
  }

  /// Citizen reviews remediation on ground (confirms fixed or reopens)
  Future<CivicIssue> citizenVerifyResolution(
    Session session, {
    required int issueId,
    required bool confirmedFixed,
    String? remarks,
    String? imageReference,
  }) async {
    final user = await RbacMiddleware.requireUser(session);
    return await VerificationService.citizenVerifyResolution(
      session: session,
      issueId: issueId,
      citizenId: user.id ?? 1,
      confirmedFixed: confirmedFixed,
      remarks: remarks,
      imageReference: imageReference,
    );
  }
}
