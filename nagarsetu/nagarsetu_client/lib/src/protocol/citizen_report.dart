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

abstract class CitizenReport
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CitizenReport._({
    this.id,
    required this.citizenId,
    this.issueId,
    required this.description,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.address,
    this.imageReference,
    this.audioReference,
    this.aiDetectedCategory,
    this.aiConfidence,
    this.duplicateDetectionScore,
    required this.duplicateDetectionStatus,
    required this.submissionStatus,
    this.idempotencyKey,
    required this.counted,
    this.linkMethod,
    required this.repeatReporter,
    required this.createdAt,
  });

  factory CitizenReport({
    int? id,
    required int citizenId,
    int? issueId,
    required String description,
    required String category,
    required double latitude,
    required double longitude,
    String? address,
    String? imageReference,
    String? audioReference,
    String? aiDetectedCategory,
    double? aiConfidence,
    double? duplicateDetectionScore,
    required String duplicateDetectionStatus,
    required String submissionStatus,
    String? idempotencyKey,
    required bool counted,
    String? linkMethod,
    required bool repeatReporter,
    required DateTime createdAt,
  }) = _CitizenReportImpl;

  factory CitizenReport.fromJson(Map<String, dynamic> jsonSerialization) {
    return CitizenReport(
      id: jsonSerialization['id'] as int?,
      citizenId: jsonSerialization['citizenId'] as int,
      issueId: jsonSerialization['issueId'] as int?,
      description: jsonSerialization['description'] as String,
      category: jsonSerialization['category'] as String,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      address: jsonSerialization['address'] as String?,
      imageReference: jsonSerialization['imageReference'] as String?,
      audioReference: jsonSerialization['audioReference'] as String?,
      aiDetectedCategory: jsonSerialization['aiDetectedCategory'] as String?,
      aiConfidence: (jsonSerialization['aiConfidence'] as num?)?.toDouble(),
      duplicateDetectionScore:
          (jsonSerialization['duplicateDetectionScore'] as num?)?.toDouble(),
      duplicateDetectionStatus:
          jsonSerialization['duplicateDetectionStatus'] as String,
      submissionStatus: jsonSerialization['submissionStatus'] as String,
      idempotencyKey: jsonSerialization['idempotencyKey'] as String?,
      counted: _isc.BoolJsonExtension.fromJson(jsonSerialization['counted']),
      linkMethod: jsonSerialization['linkMethod'] as String?,
      repeatReporter: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['repeatReporter'],
      ),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int citizenId;

  int? issueId;

  String description;

  String category;

  double latitude;

  double longitude;

  String? address;

  String? imageReference;

  String? audioReference;

  String? aiDetectedCategory;

  double? aiConfidence;

  double? duplicateDetectionScore;

  String duplicateDetectionStatus;

  String submissionStatus;

  String? idempotencyKey;

  bool counted;

  String? linkMethod;

  bool repeatReporter;

  DateTime createdAt;

  /// Returns a shallow copy of this [CitizenReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CitizenReport copyWith({
    int? id,
    int? citizenId,
    int? issueId,
    String? description,
    String? category,
    double? latitude,
    double? longitude,
    String? address,
    String? imageReference,
    String? audioReference,
    String? aiDetectedCategory,
    double? aiConfidence,
    double? duplicateDetectionScore,
    String? duplicateDetectionStatus,
    String? submissionStatus,
    String? idempotencyKey,
    bool? counted,
    String? linkMethod,
    bool? repeatReporter,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CitizenReport',
      if (id != null) 'id': id,
      'citizenId': citizenId,
      if (issueId != null) 'issueId': issueId,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      if (address != null) 'address': address,
      if (imageReference != null) 'imageReference': imageReference,
      if (audioReference != null) 'audioReference': audioReference,
      if (aiDetectedCategory != null) 'aiDetectedCategory': aiDetectedCategory,
      if (aiConfidence != null) 'aiConfidence': aiConfidence,
      if (duplicateDetectionScore != null)
        'duplicateDetectionScore': duplicateDetectionScore,
      'duplicateDetectionStatus': duplicateDetectionStatus,
      'submissionStatus': submissionStatus,
      if (idempotencyKey != null) 'idempotencyKey': idempotencyKey,
      'counted': counted,
      if (linkMethod != null) 'linkMethod': linkMethod,
      'repeatReporter': repeatReporter,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CitizenReport',
      if (id != null) 'id': id,
      'citizenId': citizenId,
      if (issueId != null) 'issueId': issueId,
      'description': description,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      if (address != null) 'address': address,
      if (imageReference != null) 'imageReference': imageReference,
      if (audioReference != null) 'audioReference': audioReference,
      if (aiDetectedCategory != null) 'aiDetectedCategory': aiDetectedCategory,
      if (aiConfidence != null) 'aiConfidence': aiConfidence,
      if (duplicateDetectionScore != null)
        'duplicateDetectionScore': duplicateDetectionScore,
      'duplicateDetectionStatus': duplicateDetectionStatus,
      'submissionStatus': submissionStatus,
      if (idempotencyKey != null) 'idempotencyKey': idempotencyKey,
      'counted': counted,
      if (linkMethod != null) 'linkMethod': linkMethod,
      'repeatReporter': repeatReporter,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CitizenReportImpl extends CitizenReport {
  _CitizenReportImpl({
    int? id,
    required int citizenId,
    int? issueId,
    required String description,
    required String category,
    required double latitude,
    required double longitude,
    String? address,
    String? imageReference,
    String? audioReference,
    String? aiDetectedCategory,
    double? aiConfidence,
    double? duplicateDetectionScore,
    required String duplicateDetectionStatus,
    required String submissionStatus,
    String? idempotencyKey,
    required bool counted,
    String? linkMethod,
    required bool repeatReporter,
    required DateTime createdAt,
  }) : super._(
         id: id,
         citizenId: citizenId,
         issueId: issueId,
         description: description,
         category: category,
         latitude: latitude,
         longitude: longitude,
         address: address,
         imageReference: imageReference,
         audioReference: audioReference,
         aiDetectedCategory: aiDetectedCategory,
         aiConfidence: aiConfidence,
         duplicateDetectionScore: duplicateDetectionScore,
         duplicateDetectionStatus: duplicateDetectionStatus,
         submissionStatus: submissionStatus,
         idempotencyKey: idempotencyKey,
         counted: counted,
         linkMethod: linkMethod,
         repeatReporter: repeatReporter,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CitizenReport]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CitizenReport copyWith({
    Object? id = _Undefined,
    int? citizenId,
    Object? issueId = _Undefined,
    String? description,
    String? category,
    double? latitude,
    double? longitude,
    Object? address = _Undefined,
    Object? imageReference = _Undefined,
    Object? audioReference = _Undefined,
    Object? aiDetectedCategory = _Undefined,
    Object? aiConfidence = _Undefined,
    Object? duplicateDetectionScore = _Undefined,
    String? duplicateDetectionStatus,
    String? submissionStatus,
    Object? idempotencyKey = _Undefined,
    bool? counted,
    Object? linkMethod = _Undefined,
    bool? repeatReporter,
    DateTime? createdAt,
  }) {
    return CitizenReport(
      id: id is int? ? id : this.id,
      citizenId: citizenId ?? this.citizenId,
      issueId: issueId is int? ? issueId : this.issueId,
      description: description ?? this.description,
      category: category ?? this.category,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address is String? ? address : this.address,
      imageReference: imageReference is String?
          ? imageReference
          : this.imageReference,
      audioReference: audioReference is String?
          ? audioReference
          : this.audioReference,
      aiDetectedCategory: aiDetectedCategory is String?
          ? aiDetectedCategory
          : this.aiDetectedCategory,
      aiConfidence: aiConfidence is double? ? aiConfidence : this.aiConfidence,
      duplicateDetectionScore: duplicateDetectionScore is double?
          ? duplicateDetectionScore
          : this.duplicateDetectionScore,
      duplicateDetectionStatus:
          duplicateDetectionStatus ?? this.duplicateDetectionStatus,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      idempotencyKey: idempotencyKey is String?
          ? idempotencyKey
          : this.idempotencyKey,
      counted: counted ?? this.counted,
      linkMethod: linkMethod is String? ? linkMethod : this.linkMethod,
      repeatReporter: repeatReporter ?? this.repeatReporter,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
