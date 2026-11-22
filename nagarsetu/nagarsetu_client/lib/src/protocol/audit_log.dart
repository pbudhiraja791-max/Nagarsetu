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

abstract class AuditLog
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AuditLog._({
    this.id,
    this.actorId,
    this.actorRole,
    required this.action,
    required this.entityType,
    this.entityId,
    this.oldValues,
    this.newValues,
    required this.createdAt,
  });

  factory AuditLog({
    int? id,
    int? actorId,
    String? actorRole,
    required String action,
    required String entityType,
    int? entityId,
    String? oldValues,
    String? newValues,
    required DateTime createdAt,
  }) = _AuditLogImpl;

  factory AuditLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuditLog(
      id: jsonSerialization['id'] as int?,
      actorId: jsonSerialization['actorId'] as int?,
      actorRole: jsonSerialization['actorRole'] as String?,
      action: jsonSerialization['action'] as String,
      entityType: jsonSerialization['entityType'] as String,
      entityId: jsonSerialization['entityId'] as int?,
      oldValues: jsonSerialization['oldValues'] as String?,
      newValues: jsonSerialization['newValues'] as String?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int? actorId;

  String? actorRole;

  String action;

  String entityType;

  int? entityId;

  String? oldValues;

  String? newValues;

  DateTime createdAt;

  /// Returns a shallow copy of this [AuditLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AuditLog copyWith({
    int? id,
    int? actorId,
    String? actorRole,
    String? action,
    String? entityType,
    int? entityId,
    String? oldValues,
    String? newValues,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditLog',
      if (id != null) 'id': id,
      if (actorId != null) 'actorId': actorId,
      if (actorRole != null) 'actorRole': actorRole,
      'action': action,
      'entityType': entityType,
      if (entityId != null) 'entityId': entityId,
      if (oldValues != null) 'oldValues': oldValues,
      if (newValues != null) 'newValues': newValues,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuditLog',
      if (id != null) 'id': id,
      if (actorId != null) 'actorId': actorId,
      if (actorRole != null) 'actorRole': actorRole,
      'action': action,
      'entityType': entityType,
      if (entityId != null) 'entityId': entityId,
      if (oldValues != null) 'oldValues': oldValues,
      if (newValues != null) 'newValues': newValues,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuditLogImpl extends AuditLog {
  _AuditLogImpl({
    int? id,
    int? actorId,
    String? actorRole,
    required String action,
    required String entityType,
    int? entityId,
    String? oldValues,
    String? newValues,
    required DateTime createdAt,
  }) : super._(
         id: id,
         actorId: actorId,
         actorRole: actorRole,
         action: action,
         entityType: entityType,
         entityId: entityId,
         oldValues: oldValues,
         newValues: newValues,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [AuditLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AuditLog copyWith({
    Object? id = _Undefined,
    Object? actorId = _Undefined,
    Object? actorRole = _Undefined,
    String? action,
    String? entityType,
    Object? entityId = _Undefined,
    Object? oldValues = _Undefined,
    Object? newValues = _Undefined,
    DateTime? createdAt,
  }) {
    return AuditLog(
      id: id is int? ? id : this.id,
      actorId: actorId is int? ? actorId : this.actorId,
      actorRole: actorRole is String? ? actorRole : this.actorRole,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId is int? ? entityId : this.entityId,
      oldValues: oldValues is String? ? oldValues : this.oldValues,
      newValues: newValues is String? ? newValues : this.newValues,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
