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

abstract class Officer
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Officer._({
    this.id,
    required this.userId,
    required this.departmentId,
    required this.employeeCode,
    this.designation,
    this.assignedArea,
    required this.isActive,
    required this.createdAt,
  });

  factory Officer({
    int? id,
    required int userId,
    required int departmentId,
    required String employeeCode,
    String? designation,
    String? assignedArea,
    required bool isActive,
    required DateTime createdAt,
  }) = _OfficerImpl;

  factory Officer.fromJson(Map<String, dynamic> jsonSerialization) {
    return Officer(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      departmentId: jsonSerialization['departmentId'] as int,
      employeeCode: jsonSerialization['employeeCode'] as String,
      designation: jsonSerialization['designation'] as String?,
      assignedArea: jsonSerialization['assignedArea'] as String?,
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userId;

  int departmentId;

  String employeeCode;

  String? designation;

  String? assignedArea;

  bool isActive;

  DateTime createdAt;

  /// Returns a shallow copy of this [Officer]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Officer copyWith({
    int? id,
    int? userId,
    int? departmentId,
    String? employeeCode,
    String? designation,
    String? assignedArea,
    bool? isActive,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Officer',
      if (id != null) 'id': id,
      'userId': userId,
      'departmentId': departmentId,
      'employeeCode': employeeCode,
      if (designation != null) 'designation': designation,
      if (assignedArea != null) 'assignedArea': assignedArea,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Officer',
      if (id != null) 'id': id,
      'userId': userId,
      'departmentId': departmentId,
      'employeeCode': employeeCode,
      if (designation != null) 'designation': designation,
      if (assignedArea != null) 'assignedArea': assignedArea,
      'isActive': isActive,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OfficerImpl extends Officer {
  _OfficerImpl({
    int? id,
    required int userId,
    required int departmentId,
    required String employeeCode,
    String? designation,
    String? assignedArea,
    required bool isActive,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         departmentId: departmentId,
         employeeCode: employeeCode,
         designation: designation,
         assignedArea: assignedArea,
         isActive: isActive,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Officer]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Officer copyWith({
    Object? id = _Undefined,
    int? userId,
    int? departmentId,
    String? employeeCode,
    Object? designation = _Undefined,
    Object? assignedArea = _Undefined,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Officer(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      departmentId: departmentId ?? this.departmentId,
      employeeCode: employeeCode ?? this.employeeCode,
      designation: designation is String? ? designation : this.designation,
      assignedArea: assignedArea is String? ? assignedArea : this.assignedArea,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
