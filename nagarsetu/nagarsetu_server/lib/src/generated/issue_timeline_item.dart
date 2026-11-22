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
import 'package:serverpod/serverpod.dart' as _is;

abstract class IssueTimelineItem
    implements _is.SerializableModel, _is.ProtocolSerialization {
  IssueTimelineItem._({
    required this.eventType,
    required this.title,
    required this.description,
    required this.timestamp,
    this.actorName,
    this.dataJson,
  });

  factory IssueTimelineItem({
    required String eventType,
    required String title,
    required String description,
    required DateTime timestamp,
    String? actorName,
    String? dataJson,
  }) = _IssueTimelineItemImpl;

  factory IssueTimelineItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return IssueTimelineItem(
      eventType: jsonSerialization['eventType'] as String,
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      timestamp: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      actorName: jsonSerialization['actorName'] as String?,
      dataJson: jsonSerialization['dataJson'] as String?,
    );
  }

  String eventType;

  String title;

  String description;

  DateTime timestamp;

  String? actorName;

  String? dataJson;

  /// Returns a shallow copy of this [IssueTimelineItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  IssueTimelineItem copyWith({
    String? eventType,
    String? title,
    String? description,
    DateTime? timestamp,
    String? actorName,
    String? dataJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'IssueTimelineItem',
      'eventType': eventType,
      'title': title,
      'description': description,
      'timestamp': timestamp.toJson(),
      if (actorName != null) 'actorName': actorName,
      if (dataJson != null) 'dataJson': dataJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'IssueTimelineItem',
      'eventType': eventType,
      'title': title,
      'description': description,
      'timestamp': timestamp.toJson(),
      if (actorName != null) 'actorName': actorName,
      if (dataJson != null) 'dataJson': dataJson,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _IssueTimelineItemImpl extends IssueTimelineItem {
  _IssueTimelineItemImpl({
    required String eventType,
    required String title,
    required String description,
    required DateTime timestamp,
    String? actorName,
    String? dataJson,
  }) : super._(
         eventType: eventType,
         title: title,
         description: description,
         timestamp: timestamp,
         actorName: actorName,
         dataJson: dataJson,
       );

  /// Returns a shallow copy of this [IssueTimelineItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  IssueTimelineItem copyWith({
    String? eventType,
    String? title,
    String? description,
    DateTime? timestamp,
    Object? actorName = _Undefined,
    Object? dataJson = _Undefined,
  }) {
    return IssueTimelineItem(
      eventType: eventType ?? this.eventType,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      actorName: actorName is String? ? actorName : this.actorName,
      dataJson: dataJson is String? ? dataJson : this.dataJson,
    );
  }
}
