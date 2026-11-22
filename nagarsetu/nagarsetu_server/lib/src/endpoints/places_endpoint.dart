import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../middleware/rbac_middleware.dart';
import '../services/place_service.dart';

class PlacesEndpoint extends Endpoint {
  /// Creates a new municipal landmark or place
  Future<Place> createPlace(
    Session session, {
    required String name,
    String? description,
    String? address,
    String? category,
    required double latitude,
    required double longitude,
  }) async {
    await RbacMiddleware.requireRole(session, ['Admin', 'Officer']);
    return await PlaceService.createPlace(
      session: session,
      name: name,
      description: description,
      address: address,
      category: category,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Lists all municipal places
  Future<List<Place>> getPlaces(
    Session session, {
    int page = 1,
    int limit = 50,
  }) async {
    return await PlaceService.getPlaces(
      session: session,
      page: page,
      limit: limit,
    );
  }

  /// Retrieves details of a specific place
  Future<Place?> getPlaceById(
    Session session,
    int id,
  ) async {
    return await PlaceService.getPlaceById(
      session: session,
      id: id,
    );
  }

  /// Publishes a community story or civic news item for a place
  Future<Story> createStory(
    Session session, {
    required int placeId,
    required String title,
    required String description,
    String? imageReference,
    String? audioReference,
    int? relatedIssueId,
    String visibility = 'PUBLIC',
  }) async {
    final user = await RbacMiddleware.requireUser(session);
    return await PlaceService.createStory(
      session: session,
      placeId: placeId,
      authorId: user.id ?? 1,
      title: title,
      description: description,
      imageReference: imageReference,
      audioReference: audioReference,
      relatedIssueId: relatedIssueId,
      visibility: visibility,
    );
  }

  /// Retrieves community stories associated with a place
  Future<List<Story>> getStoriesByPlace(
    Session session, {
    required int placeId,
    int limit = 20,
  }) async {
    return await PlaceService.getStoriesByPlace(
      session: session,
      placeId: placeId,
      limit: limit,
    );
  }
}
