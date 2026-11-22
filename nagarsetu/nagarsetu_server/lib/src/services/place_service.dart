import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../validators/input_validator.dart';

class PlaceService {
  /// Registers a new landmark or municipal zone
  static Future<Place> createPlace({
    required Session session,
    required String name,
    String? description,
    String? address,
    String? category,
    required double latitude,
    required double longitude,
  }) async {
    if (!InputValidator.isValidCoordinates(latitude, longitude)) {
      throw ArgumentError('Invalid latitude or longitude coordinates.');
    }

    final place = Place(
      name: name.trim(),
      description: description,
      address: address,
      category: category,
      latitude: latitude,
      longitude: longitude,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    return await Place.db.insertRow(session, place);
  }

  /// Lists all municipal places/zones
  static Future<List<Place>> getPlaces({
    required Session session,
    int page = 1,
    int limit = 50,
  }) async {
    final offset = (page - 1) * limit;
    return await Place.db.find(
      session,
      orderBy: (t) => t.name,
      limit: limit,
      offset: offset,
    );
  }

  /// Retrieves a specific place by ID
  static Future<Place?> getPlaceById({
    required Session session,
    required int id,
  }) async {
    return await Place.db.findById(session, id);
  }

  /// Publishes a community story or civic update attached to a place
  static Future<Story> createStory({
    required Session session,
    required int placeId,
    required int authorId,
    required String title,
    required String description,
    String? imageReference,
    String? audioReference,
    int? relatedIssueId,
    String visibility = 'PUBLIC',
  }) async {
    final place = await Place.db.findById(session, placeId);
    if (place == null) {
      throw ArgumentError('Place #$placeId not found.');
    }

    final story = Story(
      placeId: placeId,
      authorId: authorId,
      title: title.trim(),
      description: description.trim(),
      imageReference: imageReference,
      audioReference: audioReference,
      relatedIssueId: relatedIssueId,
      visibility: visibility,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    return await Story.db.insertRow(session, story);
  }

  /// Retrieves stories for a given place
  static Future<List<Story>> getStoriesByPlace({
    required Session session,
    required int placeId,
    int limit = 20,
  }) async {
    return await Story.db.find(
      session,
      where: (t) => t.placeId.equals(placeId) & t.visibility.equals('PUBLIC'),
      orderBy: (t) => t.createdAt.desc(),
      limit: limit,
    );
  }
}
