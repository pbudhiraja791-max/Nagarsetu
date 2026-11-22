import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../utils/geo_utils.dart';

class IssueService {
  /// Fetches paginated issues with optional status, category, and priority filters
  static Future<List<CivicIssue>> getAllIssues({
    required Session session,
    int page = 1,
    int limit = 20,
    String? status,
    String? category,
    String? priorityLevel,
  }) async {
    final offset = (page - 1) * limit;

    return await CivicIssue.db.find(
      session,
      where: (t) {
        Expression? expr;
        if (status != null && status.isNotEmpty) {
          expr = t.status.equals(status);
        }
        if (category != null && category.isNotEmpty) {
          final catExpr = t.category.equals(category);
          expr = expr == null ? catExpr : (expr & catExpr);
        }
        if (priorityLevel != null && priorityLevel.isNotEmpty) {
          final prioExpr = t.priorityLevel.equals(priorityLevel);
          expr = expr == null ? prioExpr : (expr & prioExpr);
        }
        return expr ?? Constant.bool(true);
      },
      orderBy: (t) => t.priorityScore.desc(),
      limit: limit,
      offset: offset,
    );
  }

  /// Retrieves a specific issue by its ID
  static Future<CivicIssue?> getIssueById({
    required Session session,
    required int id,
  }) async {
    return await CivicIssue.db.findById(session, id);
  }

  /// Retrieves issues near given coordinates within radiusMeters using Haversine calculation
  static Future<List<CivicIssue>> getNearbyIssues({
    required Session session,
    required double latitude,
    required double longitude,
    double radiusMeters = 500.0,
    String? category,
  }) async {
    // Spatial candidate pre-filter (rough bounding box ~ 1 deg ≈ 111 km)
    final latDelta = radiusMeters / 111000.0;
    final lonDelta = radiusMeters / (111000.0 * 0.7); // Cosine approximation

    final candidates = await CivicIssue.db.find(
      session,
      where: (t) {
        var expr = (t.latitude >= (latitude - latDelta)) &
            (t.latitude <= (latitude + latDelta)) &
            (t.longitude >= (longitude - lonDelta)) &
            (t.longitude <= (longitude + lonDelta));
        if (category != null && category.isNotEmpty) {
          expr = expr & t.category.equals(category);
        }
        return expr;
      },
    );

    // Exact Haversine filter
    final nearby = <CivicIssue>[];
    for (final issue in candidates) {
      final dist = GeoUtils.haversineDistance(
        latitude,
        longitude,
        issue.latitude,
        issue.longitude,
      );
      if (dist <= radiusMeters) {
        nearby.add(issue);
      }
    }

    // Sort by proximity
    nearby.sort((a, b) {
      final distA = GeoUtils.haversineDistance(latitude, longitude, a.latitude, a.longitude);
      final distB = GeoUtils.haversineDistance(latitude, longitude, b.latitude, b.longitude);
      return distA.compareTo(distB);
    });

    return nearby;
  }

  /// Anonymized public list of issues for citizens (excludes sensitive reporter info)
  static Future<List<CivicIssue>> getPublicIssues({
    required Session session,
    int page = 1,
    int limit = 20,
  }) async {
    final offset = (page - 1) * limit;
    return await CivicIssue.db.find(
      session,
      orderBy: (t) => t.lastReportedAt.desc(),
      limit: limit,
      offset: offset,
    );
  }

  /// Builds a unified, chronological timeline of an issue from reports, assignments, resolutions, and reviews
  static Future<List<IssueTimelineItem>> getIssueTimeline({
    required Session session,
    required int issueId,
  }) async {
    final items = <IssueTimelineItem>[];

    final issue = await CivicIssue.db.findById(session, issueId);
    if (issue == null) return items;

    // 1. Initial creation
    items.add(
      IssueTimelineItem(
        eventType: 'ISSUE_CREATED',
        title: 'Civic Issue Registered',
        description: 'Problem logged under category "${issue.category}" at ${issue.address ?? issue.locationName ?? "designated coordinates"}.',
        timestamp: issue.firstReportedAt,
        actorName: 'System',
        dataJson: jsonEncode({'priorityLevel': issue.priorityLevel, 'priorityScore': issue.priorityScore}),
      ),
    );

    // 2. Citizen reports
    final reports = await CitizenReport.db.find(
      session,
      where: (t) => t.issueId.equals(issueId),
      orderBy: (t) => t.createdAt,
    );
    for (final rep in reports) {
      items.add(
        IssueTimelineItem(
          eventType: 'CITIZEN_REPORT',
          title: 'Citizen Report Submitted',
          description: rep.description,
          timestamp: rep.createdAt,
          actorName: 'Citizen #${rep.citizenId}',
          dataJson: jsonEncode({
            'reportId': rep.id,
            'status': rep.submissionStatus,
            'duplicateStatus': rep.duplicateDetectionStatus,
            'hasImage': rep.imageReference != null,
          }),
        ),
      );
    }

    // 3. Count history changes
    final countHistory = await ReportCountHistory.db.find(
      session,
      where: (t) => t.issueId.equals(issueId),
      orderBy: (t) => t.createdAt,
    );
    for (final ch in countHistory) {
      items.add(
        IssueTimelineItem(
          eventType: 'COUNT_UPDATED',
          title: 'Report Counter Increment (${ch.actionType})',
          description: 'Report count updated from ${ch.previousCount} to ${ch.newCount}.',
          timestamp: ch.createdAt,
          actorName: 'System / Admin',
        ),
      );
    }

    // 4. Assignments
    final assignments = await IssueAssignment.db.find(
      session,
      where: (t) => t.issueId.equals(issueId),
      orderBy: (t) => t.assignedAt,
    );
    for (final asg in assignments) {
      items.add(
        IssueTimelineItem(
          eventType: 'OFFICER_ASSIGNED',
          title: 'Assigned to Field Team',
          description: 'Assigned to Officer #${asg.officerId} (Dept #${asg.departmentId}). Status: ${asg.assignmentStatus}. Remarks: ${asg.remarks ?? "None"}',
          timestamp: asg.assignedAt,
          actorName: 'Admin #${asg.assignedBy}',
        ),
      );
    }

    // 5. Resolutions
    final resolutions = await ResolutionRecord.db.find(
      session,
      where: (t) => t.issueId.equals(issueId),
      orderBy: (t) => t.submittedAt,
    );
    for (final res in resolutions) {
      items.add(
        IssueTimelineItem(
          eventType: 'RESOLUTION_SUBMITTED',
          title: 'Remediation Submitted',
          description: res.resolutionDescription,
          timestamp: res.submittedAt,
          actorName: 'Officer #${res.officerId}',
          dataJson: jsonEncode({
            'verificationStatus': res.verificationStatus,
            'afterImage': res.afterImageReference,
          }),
        ),
      );
    }

    // 6. Citizen Verifications
    final verifications = await CitizenVerification.db.find(
      session,
      where: (t) => t.issueId.equals(issueId),
      orderBy: (t) => t.createdAt,
    );
    for (final ver in verifications) {
      items.add(
        IssueTimelineItem(
          eventType: 'CITIZEN_VERIFICATION',
          title: ver.verificationStatus == 'CONFIRMED_FIXED' ? 'Citizen Verified Resolution' : 'Citizen Reopened Defect',
          description: ver.remarks ?? 'Citizen inspected remediation.',
          timestamp: ver.createdAt,
          actorName: 'Citizen #${ver.citizenId}',
          dataJson: jsonEncode({'status': ver.verificationStatus}),
        ),
      );
    }

    // Sort all timeline items chronologically
    items.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return items;
  }
}
