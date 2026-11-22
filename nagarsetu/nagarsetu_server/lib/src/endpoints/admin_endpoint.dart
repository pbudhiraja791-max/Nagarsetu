import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../middleware/rbac_middleware.dart';
import '../services/admin_service.dart';
import '../services/report_counter_service.dart';

class AdminEndpoint extends Endpoint {
  /// Fetches pending duplicate reports requiring human administrator review
  Future<List<CitizenReport>> getPendingDuplicateReviews(
    Session session, {
    int limit = 50,
  }) async {
    await RbacMiddleware.requireRole(session, ['Admin']);
    return await CitizenReport.db.find(
      session,
      where: (t) => t.duplicateDetectionStatus.equals('PENDING_REVIEW'),
      orderBy: (t) => t.createdAt.desc(),
      limit: limit,
    );
  }

  /// Admin manually confirms duplicate suggestion, merging report into existing issue
  Future<CivicIssue> confirmDuplicate(
    Session session, {
    required int reportId,
    String? remarks,
  }) async {
    final user = await RbacMiddleware.requireRole(session, ['Admin']);
    return await AdminService.confirmDuplicate(
      session: session,
      reportId: reportId,
      adminUserId: user.id ?? 1,
      remarks: remarks,
    );
  }

  /// Admin rejects duplicate candidate and forms a distinct new CivicIssue
  Future<CivicIssue> rejectDuplicate(
    Session session, {
    required int reportId,
    String? remarks,
  }) async {
    final user = await RbacMiddleware.requireRole(session, ['Admin']);
    return await AdminService.rejectDuplicate(
      session: session,
      reportId: reportId,
      adminUserId: user.id ?? 1,
      remarks: remarks,
    );
  }

  /// Assigns a civic issue to a municipal department and officer
  Future<CivicIssue> assignIssue(
    Session session, {
    required int issueId,
    required int departmentId,
    required int officerId,
    DateTime? deadline,
    String? remarks,
  }) async {
    final user = await RbacMiddleware.requireRole(session, ['Admin']);
    return await AdminService.assignIssue(
      session: session,
      issueId: issueId,
      departmentId: departmentId,
      officerId: officerId,
      adminUserId: user.id ?? 1,
      deadline: deadline,
      remarks: remarks,
    );
  }

  /// Manually overrides priority score and level for an issue
  Future<CivicIssue> updateIssuePriority(
    Session session, {
    required int issueId,
    required double manualScore,
    required String manualLevel,
    required String reason,
  }) async {
    final user = await RbacMiddleware.requireRole(session, ['Admin']);
    return await AdminService.overridePriority(
      session: session,
      issueId: issueId,
      manualScore: manualScore,
      manualLevel: manualLevel,
      adminUserId: user.id ?? 1,
      reason: reason,
    );
  }

  /// Reconciles database-wide report counter invariants
  Future<String> reconcileDatabase(Session session) async {
    await RbacMiddleware.requireRole(session, ['Admin']);
    final result = await ReportCounterService.reconcileAllIssues(session);
    return jsonEncode(result);
  }

  /// Fetches system audit logs for administrative oversight
  Future<List<AuditLog>> getAuditLogs(
    Session session, {
    int limit = 100,
    int offset = 0,
  }) async {
    await RbacMiddleware.requireRole(session, ['Admin']);
    return await AuditLog.db.find(
      session,
      orderBy: (t) => t.createdAt.desc(),
      limit: limit,
      offset: offset,
    );
  }
}
