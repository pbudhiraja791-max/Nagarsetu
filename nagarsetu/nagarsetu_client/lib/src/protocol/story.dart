/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class Story
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Story._({
    this.id,
    required this.placeId,
    required this.authorId,
    required this.title,
    required this.description,
    this.imageReference,
    this.audioReference,
    this.relatedIssueId,
    required this.visibility,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Story({
    int? id,
    required int placeId,
    required int authorId,
    required String title,
    required String description,
    String? imageReference,
    String? audioReference,
    int? relatedIssueId,
    required String visibility,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _StoryImpl;

  factory Story.fromJson(Map<String, dynamic> jsonSerialization) {
    return Story(
      id: jsonSerialization['id'] as int?,
      placeId: jsonSerialization['placeId'] as int,
      authorId: jsonSerialization['authorId'] as int,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      imageReference: jsonSerialization['imageReference'] as String?,
      audioReference: jsonSerialization['audioReference'] as String?,
      relatedIssueId: jsonSerialization['relatedIssueId'] as int?,
      visibility: jsonSerialization['visibility'] as String,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int placeId;

  int authorId;

  String title;

  String description;

  String? imageReference;

  String? audioReference;

  int? relatedIssueId;

  String visibility;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Story]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Story copyWith({
    int? id,
    int? placeId,
    int? authorId,
    String? title,
    String? description,
    String? imageReference,
    String? audioReference,
    int? relatedIssueId,
    String? visibility,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Story',
      if (id != null) 'id': id,
      'placeId': placeId,
      'authorId': authorId,
      'title': title,
      'description': description,
      if (imageReference != null) 'imageReference': imageReference,
      if (audioReference != null) 'audioReference': audioReference,
      if (relatedIssueId != null) 'relatedIssueId': relatedIssueId,
      'visibility': visibility,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Story',
      if (id != null) 'id': id,
      'placeId': placeId,
      'authorId': authorId,
      'title': title,
      'description': description,
      if (imageReference != null) 'imageReference': imageReference,
      if (audioReference != null) 'audioReference': audioReference,
      if (relatedIssueId != null) 'relatedIssueId': relatedIssueId,
      'visibility': visibility,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _StoryImpl extends Story {
  _StoryImpl({
    int? id,
    required int placeId,
    required int authorId,
    required String title,
    required String description,
    String? imageReference,
    String? audioReference,
    int? relatedIssueId,
    required String visibility,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         placeId: placeId,
         authorId: authorId,
         title: title,
         description: description,
         imageReference: imageReference,
         audioReference: audioReference,
         relatedIssueId: relatedIssueId,
         visibility: visibility,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Story]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Story copyWith({
    Object? id = _Undefined,
    int? placeId,
    int? authorId,
    String? title,
    String? description,
    Object? imageReference = _Undefined,
    Object? audioReference = _Undefined,
    Object? relatedIssueId = _Undefined,
    String? visibility,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Story(
      id: id is int? ? id : this.id,
      placeId: placeId ?? this.placeId,
      authorId: authorId ?? this.authorId,
      title: title ?? this.title,
      description: description ?? this.description,
      imageReference: imageReference is String?
          ? imageReference
          : this.imageReference,
      audioReference: audioReference is String?
          ? audioReference
          : this.audioReference,
      relatedIssueId: relatedIssueId is int?
          ? relatedIssueId
          : this.relatedIssueId,
      visibility: visibility ?? this.visibility,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
