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

abstract class Notification
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Notification._({
    this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.notificationType,
    this.relatedIssueId,
    required this.isRead,
    required this.createdAt,
  });

  factory Notification({
    int? id,
    required int userId,
    required String title,
    required String message,
    required String notificationType,
    int? relatedIssueId,
    required bool isRead,
    required DateTime createdAt,
  }) = _NotificationImpl;

  factory Notification.fromJson(Map<String, dynamic> jsonSerialization) {
    return Notification(
      id: jsonSerialization['id'] as int?,
      userId: jsonSerialization['userId'] as int,
      title: jsonSerialization['title'] as String,
      message: jsonSerialization['message'] as String,
      notificationType: jsonSerialization['notificationType'] as String,
      relatedIssueId: jsonSerialization['relatedIssueId'] as int?,
      isRead: _isc.BoolJsonExtension.fromJson(jsonSerialization['isRead']),
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

  String title;

  String message;

  String notificationType;

  int? relatedIssueId;

  bool isRead;

  DateTime createdAt;

  /// Returns a shallow copy of this [Notification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Notification copyWith({
    int? id,
    int? userId,
    String? title,
    String? message,
    String? notificationType,
    int? relatedIssueId,
    bool? isRead,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Notification',
      if (id != null) 'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'notificationType': notificationType,
      if (relatedIssueId != null) 'relatedIssueId': relatedIssueId,
      'isRead': isRead,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Notification',
      if (id != null) 'id': id,
      'userId': userId,
      'title': title,
      'message': message,
      'notificationType': notificationType,
      if (relatedIssueId != null) 'relatedIssueId': relatedIssueId,
      'isRead': isRead,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationImpl extends Notification {
  _NotificationImpl({
    int? id,
    required int userId,
    required String title,
    required String message,
    required String notificationType,
    int? relatedIssueId,
    required bool isRead,
    required DateTime createdAt,
  }) : super._(
         id: id,
         userId: userId,
         title: title,
         message: message,
         notificationType: notificationType,
         relatedIssueId: relatedIssueId,
         isRead: isRead,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Notification]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Notification copyWith({
    Object? id = _Undefined,
    int? userId,
    String? title,
    String? message,
    String? notificationType,
    Object? relatedIssueId = _Undefined,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return Notification(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      message: message ?? this.message,
      notificationType: notificationType ?? this.notificationType,
      relatedIssueId: relatedIssueId is int?
          ? relatedIssueId
          : this.relatedIssueId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
