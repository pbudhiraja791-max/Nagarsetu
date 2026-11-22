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

abstract class ReportCountHistory
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ReportCountHistory._({
    this.id,
    required this.issueId,
    required this.reportId,
    required this.previousCount,
    required this.newCount,
    required this.actionType,
    required this.createdAt,
  });

  factory ReportCountHistory({
    int? id,
    required int issueId,
    required int reportId,
    required int previousCount,
    required int newCount,
    required String actionType,
    required DateTime createdAt,
  }) = _ReportCountHistoryImpl;

  factory ReportCountHistory.fromJson(Map<String, dynamic> jsonSerialization) {
    return ReportCountHistory(
      id: jsonSerialization['id'] as int?,
      issueId: jsonSerialization['issueId'] as int,
      reportId: jsonSerialization['reportId'] as int,
      previousCount: jsonSerialization['previousCount'] as int,
      newCount: jsonSerialization['newCount'] as int,
      actionType: jsonSerialization['actionType'] as String,
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

  int reportId;

  int previousCount;

  int newCount;

  String actionType;

  DateTime createdAt;

  /// Returns a shallow copy of this [ReportCountHistory]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ReportCountHistory copyWith({
    int? id,
    int? issueId,
    int? reportId,
    int? previousCount,
    int? newCount,
    String? actionType,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ReportCountHistory',
      if (id != null) 'id': id,
      'issueId': issueId,
      'reportId': reportId,
      'previousCount': previousCount,
      'newCount': newCount,
      'actionType': actionType,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ReportCountHistory',
      if (id != null) 'id': id,
      'issueId': issueId,
      'reportId': reportId,
      'previousCount': previousCount,
      'newCount': newCount,
      'actionType': actionType,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ReportCountHistoryImpl extends ReportCountHistory {
  _ReportCountHistoryImpl({
    int? id,
    required int issueId,
    required int reportId,
    required int previousCount,
    required int newCount,
    required String actionType,
    required DateTime createdAt,
  }) : super._(
         id: id,
         issueId: issueId,
         reportId: reportId,
         previousCount: previousCount,
         newCount: newCount,
         actionType: actionType,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ReportCountHistory]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ReportCountHistory copyWith({
    Object? id = _Undefined,
    int? issueId,
    int? reportId,
    int? previousCount,
    int? newCount,
    String? actionType,
    DateTime? createdAt,
  }) {
    return ReportCountHistory(
      id: id is int? ? id : this.id,
      issueId: issueId ?? this.issueId,
      reportId: reportId ?? this.reportId,
      previousCount: previousCount ?? this.previousCount,
      newCount: newCount ?? this.newCount,
      actionType: actionType ?? this.actionType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
