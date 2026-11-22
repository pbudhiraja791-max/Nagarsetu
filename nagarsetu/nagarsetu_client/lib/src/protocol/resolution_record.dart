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

abstract class ResolutionRecord
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ResolutionRecord._({
    this.id,
    required this.issueId,
    required this.officerId,
    required this.resolutionDescription,
    this.beforeImageReference,
    this.afterImageReference,
    this.latitude,
    this.longitude,
    required this.submittedAt,
    required this.verificationStatus,
    this.verifiedBy,
    this.verifiedAt,
    this.rejectionReason,
  });

  factory ResolutionRecord({
    int? id,
    required int issueId,
    required int officerId,
    required String resolutionDescription,
    String? beforeImageReference,
    String? afterImageReference,
    double? latitude,
    double? longitude,
    required DateTime submittedAt,
    required String verificationStatus,
    int? verifiedBy,
    DateTime? verifiedAt,
    String? rejectionReason,
  }) = _ResolutionRecordImpl;

  factory ResolutionRecord.fromJson(Map<String, dynamic> jsonSerialization) {
    return ResolutionRecord(
      id: jsonSerialization['id'] as int?,
      issueId: jsonSerialization['issueId'] as int,
      officerId: jsonSerialization['officerId'] as int,
      resolutionDescription:
          jsonSerialization['resolutionDescription'] as String,
      beforeImageReference:
          jsonSerialization['beforeImageReference'] as String?,
      afterImageReference: jsonSerialization['afterImageReference'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      submittedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['submittedAt'],
      ),
      verificationStatus: jsonSerialization['verificationStatus'] as String,
      verifiedBy: jsonSerialization['verifiedBy'] as int?,
      verifiedAt: jsonSerialization['verifiedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['verifiedAt'],
            ),
      rejectionReason: jsonSerialization['rejectionReason'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int issueId;

  int officerId;

  String resolutionDescription;

  String? beforeImageReference;

  String? afterImageReference;

  double? latitude;

  double? longitude;

  DateTime submittedAt;

  String verificationStatus;

  int? verifiedBy;

  DateTime? verifiedAt;

  String? rejectionReason;

  /// Returns a shallow copy of this [ResolutionRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ResolutionRecord copyWith({
    int? id,
    int? issueId,
    int? officerId,
    String? resolutionDescription,
    String? beforeImageReference,
    String? afterImageReference,
    double? latitude,
    double? longitude,
    DateTime? submittedAt,
    String? verificationStatus,
    int? verifiedBy,
    DateTime? verifiedAt = const _isc.$UndefinedDateTime(),
    String? rejectionReason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ResolutionRecord',
      if (id != null) 'id': id,
      'issueId': issueId,
      'officerId': officerId,
      'resolutionDescription': resolutionDescription,
      if (beforeImageReference != null)
        'beforeImageReference': beforeImageReference,
      if (afterImageReference != null)
        'afterImageReference': afterImageReference,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'submittedAt': submittedAt.toJson(),
      'verificationStatus': verificationStatus,
      if (verifiedBy != null) 'verifiedBy': verifiedBy,
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ResolutionRecord',
      if (id != null) 'id': id,
      'issueId': issueId,
      'officerId': officerId,
      'resolutionDescription': resolutionDescription,
      if (beforeImageReference != null)
        'beforeImageReference': beforeImageReference,
      if (afterImageReference != null)
        'afterImageReference': afterImageReference,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'submittedAt': submittedAt.toJson(),
      'verificationStatus': verificationStatus,
      if (verifiedBy != null) 'verifiedBy': verifiedBy,
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      if (rejectionReason != null) 'rejectionReason': rejectionReason,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResolutionRecordImpl extends ResolutionRecord {
  _ResolutionRecordImpl({
    int? id,
    required int issueId,
    required int officerId,
    required String resolutionDescription,
    String? beforeImageReference,
    String? afterImageReference,
    double? latitude,
    double? longitude,
    required DateTime submittedAt,
    required String verificationStatus,
    int? verifiedBy,
    DateTime? verifiedAt,
    String? rejectionReason,
  }) : super._(
         id: id,
         issueId: issueId,
         officerId: officerId,
         resolutionDescription: resolutionDescription,
         beforeImageReference: beforeImageReference,
         afterImageReference: afterImageReference,
         latitude: latitude,
         longitude: longitude,
         submittedAt: submittedAt,
         verificationStatus: verificationStatus,
         verifiedBy: verifiedBy,
         verifiedAt: verifiedAt,
         rejectionReason: rejectionReason,
       );

  /// Returns a shallow copy of this [ResolutionRecord]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ResolutionRecord copyWith({
    Object? id = _Undefined,
    int? issueId,
    int? officerId,
    String? resolutionDescription,
    Object? beforeImageReference = _Undefined,
    Object? afterImageReference = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    DateTime? submittedAt,
    String? verificationStatus,
    Object? verifiedBy = _Undefined,
    DateTime? verifiedAt = const _isc.$UndefinedDateTime(),
    Object? rejectionReason = _Undefined,
  }) {
    return ResolutionRecord(
      id: id is int? ? id : this.id,
      issueId: issueId ?? this.issueId,
      officerId: officerId ?? this.officerId,
      resolutionDescription:
          resolutionDescription ?? this.resolutionDescription,
      beforeImageReference: beforeImageReference is String?
          ? beforeImageReference
          : this.beforeImageReference,
      afterImageReference: afterImageReference is String?
          ? afterImageReference
          : this.afterImageReference,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      submittedAt: submittedAt ?? this.submittedAt,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      verifiedBy: verifiedBy is int? ? verifiedBy : this.verifiedBy,
      verifiedAt: verifiedAt is _isc.UndefinedSentinel
          ? this.verifiedAt
          : verifiedAt,
      rejectionReason: rejectionReason is String?
          ? rejectionReason
          : this.rejectionReason,
    );
  }
}
