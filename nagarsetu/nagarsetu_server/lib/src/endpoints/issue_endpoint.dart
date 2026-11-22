import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/issue_service.dart';

class IssueEndpoint extends Endpoint {
  /// Retrieves paginated civic issues with optional filtering by status, category, or priority level
  Future<List<CivicIssue>> getAllIssues(
    Session session, {
    int page = 1,
    int limit = 20,
    String? status,
    String? category,
    String? priorityLevel,
  }) async {
    return await IssueService.getAllIssues(
      session: session,
      page: page,
      limit: limit,
      status: status,
      category: category,
      priorityLevel: priorityLevel,
    );
  }

  /// Retrieves a specific civic issue by its ID
  Future<CivicIssue?> getIssueById(
    Session session,
    int id,
  ) async {
    return await IssueService.getIssueById(
      session: session,
      id: id,
    );
  }

  /// Spatial search: returns issues within radiusMeters of coordinates, sorted by proximity
  Future<List<CivicIssue>> getNearbyIssues(
    Session session, {
    required double latitude,
    required double longitude,
    double radiusMeters = 500.0,
    String? category,
  }) async {
    return await IssueService.getNearbyIssues(
      session: session,
      latitude: latitude,
      longitude: longitude,
      radiusMeters: radiusMeters,
      category: category,
    );
  }

  /// Public civic feed for citizens
  Future<List<CivicIssue>> getPublicIssues(
    Session session, {
    int page = 1,
    int limit = 20,
  }) async {
    return await IssueService.getPublicIssues(
      session: session,
      page: page,
      limit: limit,
    );
  }

  /// Retrieves complete audit and event timeline for a civic issue
  Future<List<IssueTimelineItem>> getIssueTimeline(
    Session session,
    int issueId,
  ) async {
    return await IssueService.getIssueTimeline(
      session: session,
      issueId: issueId,
    );
  }
}
