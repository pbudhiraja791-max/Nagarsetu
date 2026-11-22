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

abstract class IssueAssignment
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  IssueAssignment._({
    this.id,
    required this.issueId,
    required this.departmentId,
    this.officerId,
    required this.assignedBy,
    required this.assignedAt,
    this.deadline,
    required this.assignmentStatus,
    this.remarks,
  });

  factory IssueAssignment({
    int? id,
    required int issueId,
    required int departmentId,
    int? officerId,
    required int assignedBy,
    required DateTime assignedAt,
    DateTime? deadline,
    required String assignmentStatus,
    String? remarks,
  }) = _IssueAssignmentImpl;

  factory IssueAssignment.fromJson(Map<String, dynamic> jsonSerialization) {
    return IssueAssignment(
      id: jsonSerialization['id'] as int?,
      issueId: jsonSerialization['issueId'] as int,
      departmentId: jsonSerialization['departmentId'] as int,
      officerId: jsonSerialization['officerId'] as int?,
      assignedBy: jsonSerialization['assignedBy'] as int,
      assignedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['assignedAt'],
      ),
      deadline: jsonSerialization['deadline'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['deadline']),
      assignmentStatus: jsonSerialization['assignmentStatus'] as String,
      remarks: jsonSerialization['remarks'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int issueId;

  int departmentId;

  int? officerId;

  int assignedBy;

  DateTime assignedAt;

  DateTime? deadline;

  String assignmentStatus;

  String? remarks;

  /// Returns a shallow copy of this [IssueAssignment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  IssueAssignment copyWith({
    int? id,
    int? issueId,
    int? departmentId,
    int? officerId,
    int? assignedBy,
    DateTime? assignedAt,
    DateTime? deadline = const _isc.$UndefinedDateTime(),
    String? assignmentStatus,
    String? remarks,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IssueAssignment',
      if (id != null) 'id': id,
      'issueId': issueId,
      'departmentId': departmentId,
      if (officerId != null) 'officerId': officerId,
      'assignedBy': assignedBy,
      'assignedAt': assignedAt.toJson(),
      if (deadline != null) 'deadline': deadline?.toJson(),
      'assignmentStatus': assignmentStatus,
      if (remarks != null) 'remarks': remarks,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IssueAssignment',
      if (id != null) 'id': id,
      'issueId': issueId,
      'departmentId': departmentId,
      if (officerId != null) 'officerId': officerId,
      'assignedBy': assignedBy,
      'assignedAt': assignedAt.toJson(),
      if (deadline != null) 'deadline': deadline?.toJson(),
      'assignmentStatus': assignmentStatus,
      if (remarks != null) 'remarks': remarks,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IssueAssignmentImpl extends IssueAssignment {
  _IssueAssignmentImpl({
    int? id,
    required int issueId,
    required int departmentId,
    int? officerId,
    required int assignedBy,
    required DateTime assignedAt,
    DateTime? deadline,
    required String assignmentStatus,
    String? remarks,
  }) : super._(
         id: id,
         issueId: issueId,
         departmentId: departmentId,
         officerId: officerId,
         assignedBy: assignedBy,
         assignedAt: assignedAt,
         deadline: deadline,
         assignmentStatus: assignmentStatus,
         remarks: remarks,
       );

  /// Returns a shallow copy of this [IssueAssignment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  IssueAssignment copyWith({
    Object? id = _Undefined,
    int? issueId,
    int? departmentId,
    Object? officerId = _Undefined,
    int? assignedBy,
    DateTime? assignedAt,
    DateTime? deadline = const _isc.$UndefinedDateTime(),
    String? assignmentStatus,
    Object? remarks = _Undefined,
  }) {
    return IssueAssignment(
      id: id is int? ? id : this.id,
      issueId: issueId ?? this.issueId,
      departmentId: departmentId ?? this.departmentId,
      officerId: officerId is int? ? officerId : this.officerId,
      assignedBy: assignedBy ?? this.assignedBy,
      assignedAt: assignedAt ?? this.assignedAt,
      deadline: deadline is _isc.UndefinedSentinel ? this.deadline : deadline,
      assignmentStatus: assignmentStatus ?? this.assignmentStatus,
      remarks: remarks is String? ? remarks : this.remarks,
    );
  }
}
