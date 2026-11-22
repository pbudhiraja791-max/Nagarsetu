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

abstract class CitizenVerification
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CitizenVerification._({
    this.id,
    required this.issueId,
    required this.citizenId,
    required this.verificationStatus,
    this.remarks,
    this.imageReference,
    required this.createdAt,
  });

  factory CitizenVerification({
    int? id,
    required int issueId,
    required int citizenId,
    required String verificationStatus,
    String? remarks,
    String? imageReference,
    required DateTime createdAt,
  }) = _CitizenVerificationImpl;

  factory CitizenVerification.fromJson(Map<String, dynamic> jsonSerialization) {
    return CitizenVerification(
      id: jsonSerialization['id'] as int?,
      issueId: jsonSerialization['issueId'] as int,
      citizenId: jsonSerialization['citizenId'] as int,
      verificationStatus: jsonSerialization['verificationStatus'] as String,
      remarks: jsonSerialization['remarks'] as String?,
      imageReference: jsonSerialization['imageReference'] as String?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int issueId;

  int citizenId;

  String verificationStatus;

  String? remarks;

  String? imageReference;

  DateTime createdAt;

  /// Returns a shallow copy of this [CitizenVerification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CitizenVerification copyWith({
    int? id,
    int? issueId,
    int? citizenId,
    String? verificationStatus,
    String? remarks,
    String? imageReference,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CitizenVerification',
      if (id != null) 'id': id,
      'issueId': issueId,
      'citizenId': citizenId,
      'verificationStatus': verificationStatus,
      if (remarks != null) 'remarks': remarks,
      if (imageReference != null) 'imageReference': imageReference,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CitizenVerification',
      if (id != null) 'id': id,
      'issueId': issueId,
      'citizenId': citizenId,
      'verificationStatus': verificationStatus,
      if (remarks != null) 'remarks': remarks,
      if (imageReference != null) 'imageReference': imageReference,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CitizenVerificationImpl extends CitizenVerification {
  _CitizenVerificationImpl({
    int? id,
    required int issueId,
    required int citizenId,
    required String verificationStatus,
    String? remarks,
    String? imageReference,
    required DateTime createdAt,
  }) : super._(
         id: id,
         issueId: issueId,
         citizenId: citizenId,
         verificationStatus: verificationStatus,
         remarks: remarks,
         imageReference: imageReference,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [CitizenVerification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CitizenVerification copyWith({
    Object? id = _Undefined,
    int? issueId,
    int? citizenId,
    String? verificationStatus,
    Object? remarks = _Undefined,
    Object? imageReference = _Undefined,
    DateTime? createdAt,
  }) {
    return CitizenVerification(
      id: id is int? ? id : this.id,
      issueId: issueId ?? this.issueId,
      citizenId: citizenId ?? this.citizenId,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      remarks: remarks is String? ? remarks : this.remarks,
      imageReference: imageReference is String?
          ? imageReference
          : this.imageReference,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
