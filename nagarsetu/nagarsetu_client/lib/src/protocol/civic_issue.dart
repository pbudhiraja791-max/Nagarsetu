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

abstract class CivicIssue
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CivicIssue._({
    this.id,
    required this.issueCode,
    required this.title,
    required this.category,
    this.descriptionSummary,
    this.locationName,
    this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.priorityScore,
    required this.priorityLevel,
    this.priorityExplanation,
    required this.totalReports,
    required this.uniqueCitizens,
    this.assignedDepartmentId,
    this.assignedOfficerId,
    required this.firstReportedAt,
    required this.lastReportedAt,
    this.resolvedAt,
    required this.reopenedCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CivicIssue({
    int? id,
    required String issueCode,
    required String title,
    required String category,
    String? descriptionSummary,
    String? locationName,
    String? address,
    required double latitude,
    required double longitude,
    required String status,
    required double priorityScore,
    required String priorityLevel,
    String? priorityExplanation,
    required int totalReports,
    required int uniqueCitizens,
    int? assignedDepartmentId,
    int? assignedOfficerId,
    required DateTime firstReportedAt,
    required DateTime lastReportedAt,
    DateTime? resolvedAt,
    required int reopenedCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _CivicIssueImpl;

  factory CivicIssue.fromJson(Map<String, dynamic> jsonSerialization) {
    return CivicIssue(
      id: jsonSerialization['id'] as int?,
      issueCode: jsonSerialization['issueCode'] as String,
      title: jsonSerialization['title'] as String,
      category: jsonSerialization['category'] as String,
      descriptionSummary: jsonSerialization['descriptionSummary'] as String?,
      locationName: jsonSerialization['locationName'] as String?,
      address: jsonSerialization['address'] as String?,
      latitude: (jsonSerialization['latitude'] as num).toDouble(),
      longitude: (jsonSerialization['longitude'] as num).toDouble(),
      status: jsonSerialization['status'] as String,
      priorityScore: (jsonSerialization['priorityScore'] as num).toDouble(),
      priorityLevel: jsonSerialization['priorityLevel'] as String,
      priorityExplanation: jsonSerialization['priorityExplanation'] as String?,
      totalReports: jsonSerialization['totalReports'] as int,
      uniqueCitizens: jsonSerialization['uniqueCitizens'] as int,
      assignedDepartmentId: jsonSerialization['assignedDepartmentId'] as int?,
      assignedOfficerId: jsonSerialization['assignedOfficerId'] as int?,
      firstReportedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['firstReportedAt'],
      ),
      lastReportedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['lastReportedAt'],
      ),
      resolvedAt: jsonSerialization['resolvedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['resolvedAt'],
            ),
      reopenedCount: jsonSerialization['reopenedCount'] as int,
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

  String issueCode;

  String title;

  String category;

  String? descriptionSummary;

  String? locationName;

  String? address;

  double latitude;

  double longitude;

  String status;

  double priorityScore;

  String priorityLevel;

  String? priorityExplanation;

  int totalReports;

  int uniqueCitizens;

  int? assignedDepartmentId;

  int? assignedOfficerId;

  DateTime firstReportedAt;

  DateTime lastReportedAt;

  DateTime? resolvedAt;

  int reopenedCount;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [CivicIssue]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CivicIssue copyWith({
    int? id,
    String? issueCode,
    String? title,
    String? category,
    String? descriptionSummary,
    String? locationName,
    String? address,
    double? latitude,
    double? longitude,
    String? status,
    double? priorityScore,
    String? priorityLevel,
    String? priorityExplanation,
    int? totalReports,
    int? uniqueCitizens,
    int? assignedDepartmentId,
    int? assignedOfficerId,
    DateTime? firstReportedAt,
    DateTime? lastReportedAt,
    DateTime? resolvedAt = const _isc.$UndefinedDateTime(),
    int? reopenedCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CivicIssue',
      if (id != null) 'id': id,
      'issueCode': issueCode,
      'title': title,
      'category': category,
      if (descriptionSummary != null) 'descriptionSummary': descriptionSummary,
      if (locationName != null) 'locationName': locationName,
      if (address != null) 'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'priorityScore': priorityScore,
      'priorityLevel': priorityLevel,
      if (priorityExplanation != null)
        'priorityExplanation': priorityExplanation,
      'totalReports': totalReports,
      'uniqueCitizens': uniqueCitizens,
      if (assignedDepartmentId != null)
        'assignedDepartmentId': assignedDepartmentId,
      if (assignedOfficerId != null) 'assignedOfficerId': assignedOfficerId,
      'firstReportedAt': firstReportedAt.toJson(),
      'lastReportedAt': lastReportedAt.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      'reopenedCount': reopenedCount,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CivicIssue',
      if (id != null) 'id': id,
      'issueCode': issueCode,
      'title': title,
      'category': category,
      if (descriptionSummary != null) 'descriptionSummary': descriptionSummary,
      if (locationName != null) 'locationName': locationName,
      if (address != null) 'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'priorityScore': priorityScore,
      'priorityLevel': priorityLevel,
      if (priorityExplanation != null)
        'priorityExplanation': priorityExplanation,
      'totalReports': totalReports,
      'uniqueCitizens': uniqueCitizens,
      if (assignedDepartmentId != null)
        'assignedDepartmentId': assignedDepartmentId,
      if (assignedOfficerId != null) 'assignedOfficerId': assignedOfficerId,
      'firstReportedAt': firstReportedAt.toJson(),
      'lastReportedAt': lastReportedAt.toJson(),
      if (resolvedAt != null) 'resolvedAt': resolvedAt?.toJson(),
      'reopenedCount': reopenedCount,
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

class _CivicIssueImpl extends CivicIssue {
  _CivicIssueImpl({
    int? id,
    required String issueCode,
    required String title,
    required String category,
    String? descriptionSummary,
    String? locationName,
    String? address,
    required double latitude,
    required double longitude,
    required String status,
    required double priorityScore,
    required String priorityLevel,
    String? priorityExplanation,
    required int totalReports,
    required int uniqueCitizens,
    int? assignedDepartmentId,
    int? assignedOfficerId,
    required DateTime firstReportedAt,
    required DateTime lastReportedAt,
    DateTime? resolvedAt,
    required int reopenedCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         issueCode: issueCode,
         title: title,
         category: category,
         descriptionSummary: descriptionSummary,
         locationName: locationName,
         address: address,
         latitude: latitude,
         longitude: longitude,
         status: status,
         priorityScore: priorityScore,
         priorityLevel: priorityLevel,
         priorityExplanation: priorityExplanation,
         totalReports: totalReports,
         uniqueCitizens: uniqueCitizens,
         assignedDepartmentId: assignedDepartmentId,
         assignedOfficerId: assignedOfficerId,
         firstReportedAt: firstReportedAt,
         lastReportedAt: lastReportedAt,
         resolvedAt: resolvedAt,
         reopenedCount: reopenedCount,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [CivicIssue]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CivicIssue copyWith({
    Object? id = _Undefined,
    String? issueCode,
    String? title,
    String? category,
    Object? descriptionSummary = _Undefined,
    Object? locationName = _Undefined,
    Object? address = _Undefined,
    double? latitude,
    double? longitude,
    String? status,
    double? priorityScore,
    String? priorityLevel,
    Object? priorityExplanation = _Undefined,
    int? totalReports,
    int? uniqueCitizens,
    Object? assignedDepartmentId = _Undefined,
    Object? assignedOfficerId = _Undefined,
    DateTime? firstReportedAt,
    DateTime? lastReportedAt,
    DateTime? resolvedAt = const _isc.$UndefinedDateTime(),
    int? reopenedCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CivicIssue(
      id: id is int? ? id : this.id,
      issueCode: issueCode ?? this.issueCode,
      title: title ?? this.title,
      category: category ?? this.category,
      descriptionSummary: descriptionSummary is String?
          ? descriptionSummary
          : this.descriptionSummary,
      locationName: locationName is String? ? locationName : this.locationName,
      address: address is String? ? address : this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      priorityScore: priorityScore ?? this.priorityScore,
      priorityLevel: priorityLevel ?? this.priorityLevel,
      priorityExplanation: priorityExplanation is String?
          ? priorityExplanation
          : this.priorityExplanation,
      totalReports: totalReports ?? this.totalReports,
      uniqueCitizens: uniqueCitizens ?? this.uniqueCitizens,
      assignedDepartmentId: assignedDepartmentId is int?
          ? assignedDepartmentId
          : this.assignedDepartmentId,
      assignedOfficerId: assignedOfficerId is int?
          ? assignedOfficerId
          : this.assignedOfficerId,
      firstReportedAt: firstReportedAt ?? this.firstReportedAt,
      lastReportedAt: lastReportedAt ?? this.lastReportedAt,
      resolvedAt: resolvedAt is _isc.UndefinedSentinel
          ? this.resolvedAt
          : resolvedAt,
      reopenedCount: reopenedCount ?? this.reopenedCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
