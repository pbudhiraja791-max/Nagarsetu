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

abstract class DashboardAnalytics
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DashboardAnalytics._({
    required this.totalReports,
    required this.totalUniqueCitizens,
    required this.totalCivicIssues,
    required this.openIssues,
    required this.resolvedIssues,
    required this.inProgressIssues,
    required this.reopenedIssues,
    required this.resolutionRate,
    required this.avgResolutionHours,
    required this.categoriesBreakdownJson,
    required this.departmentPerformanceJson,
  });

  factory DashboardAnalytics({
    required int totalReports,
    required int totalUniqueCitizens,
    required int totalCivicIssues,
    required int openIssues,
    required int resolvedIssues,
    required int inProgressIssues,
    required int reopenedIssues,
    required double resolutionRate,
    required double avgResolutionHours,
    required String categoriesBreakdownJson,
    required String departmentPerformanceJson,
  }) = _DashboardAnalyticsImpl;

  factory DashboardAnalytics.fromJson(Map<String, dynamic> jsonSerialization) {
    return DashboardAnalytics(
      totalReports: jsonSerialization['totalReports'] as int,
      totalUniqueCitizens: jsonSerialization['totalUniqueCitizens'] as int,
      totalCivicIssues: jsonSerialization['totalCivicIssues'] as int,
      openIssues: jsonSerialization['openIssues'] as int,
      resolvedIssues: jsonSerialization['resolvedIssues'] as int,
      inProgressIssues: jsonSerialization['inProgressIssues'] as int,
      reopenedIssues: jsonSerialization['reopenedIssues'] as int,
      resolutionRate: (jsonSerialization['resolutionRate'] as num).toDouble(),
      avgResolutionHours: (jsonSerialization['avgResolutionHours'] as num)
          .toDouble(),
      categoriesBreakdownJson:
          jsonSerialization['categoriesBreakdownJson'] as String,
      departmentPerformanceJson:
          jsonSerialization['departmentPerformanceJson'] as String,
    );
  }

  int totalReports;

  int totalUniqueCitizens;

  int totalCivicIssues;

  int openIssues;

  int resolvedIssues;

  int inProgressIssues;

  int reopenedIssues;

  double resolutionRate;

  double avgResolutionHours;

  String categoriesBreakdownJson;

  String departmentPerformanceJson;

  /// Returns a shallow copy of this [DashboardAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DashboardAnalytics copyWith({
    int? totalReports,
    int? totalUniqueCitizens,
    int? totalCivicIssues,
    int? openIssues,
    int? resolvedIssues,
    int? inProgressIssues,
    int? reopenedIssues,
    double? resolutionRate,
    double? avgResolutionHours,
    String? categoriesBreakdownJson,
    String? departmentPerformanceJson,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DashboardAnalytics',
      'totalReports': totalReports,
      'totalUniqueCitizens': totalUniqueCitizens,
      'totalCivicIssues': totalCivicIssues,
      'openIssues': openIssues,
      'resolvedIssues': resolvedIssues,
      'inProgressIssues': inProgressIssues,
      'reopenedIssues': reopenedIssues,
      'resolutionRate': resolutionRate,
      'avgResolutionHours': avgResolutionHours,
      'categoriesBreakdownJson': categoriesBreakdownJson,
      'departmentPerformanceJson': departmentPerformanceJson,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DashboardAnalytics',
      'totalReports': totalReports,
      'totalUniqueCitizens': totalUniqueCitizens,
      'totalCivicIssues': totalCivicIssues,
      'openIssues': openIssues,
      'resolvedIssues': resolvedIssues,
      'inProgressIssues': inProgressIssues,
      'reopenedIssues': reopenedIssues,
      'resolutionRate': resolutionRate,
      'avgResolutionHours': avgResolutionHours,
      'categoriesBreakdownJson': categoriesBreakdownJson,
      'departmentPerformanceJson': departmentPerformanceJson,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _DashboardAnalyticsImpl extends DashboardAnalytics {
  _DashboardAnalyticsImpl({
    required int totalReports,
    required int totalUniqueCitizens,
    required int totalCivicIssues,
    required int openIssues,
    required int resolvedIssues,
    required int inProgressIssues,
    required int reopenedIssues,
    required double resolutionRate,
    required double avgResolutionHours,
    required String categoriesBreakdownJson,
    required String departmentPerformanceJson,
  }) : super._(
         totalReports: totalReports,
         totalUniqueCitizens: totalUniqueCitizens,
         totalCivicIssues: totalCivicIssues,
         openIssues: openIssues,
         resolvedIssues: resolvedIssues,
         inProgressIssues: inProgressIssues,
         reopenedIssues: reopenedIssues,
         resolutionRate: resolutionRate,
         avgResolutionHours: avgResolutionHours,
         categoriesBreakdownJson: categoriesBreakdownJson,
         departmentPerformanceJson: departmentPerformanceJson,
       );

  /// Returns a shallow copy of this [DashboardAnalytics]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DashboardAnalytics copyWith({
    int? totalReports,
    int? totalUniqueCitizens,
    int? totalCivicIssues,
    int? openIssues,
    int? resolvedIssues,
    int? inProgressIssues,
    int? reopenedIssues,
    double? resolutionRate,
    double? avgResolutionHours,
    String? categoriesBreakdownJson,
    String? departmentPerformanceJson,
  }) {
    return DashboardAnalytics(
      totalReports: totalReports ?? this.totalReports,
      totalUniqueCitizens: totalUniqueCitizens ?? this.totalUniqueCitizens,
      totalCivicIssues: totalCivicIssues ?? this.totalCivicIssues,
      openIssues: openIssues ?? this.openIssues,
      resolvedIssues: resolvedIssues ?? this.resolvedIssues,
      inProgressIssues: inProgressIssues ?? this.inProgressIssues,
      reopenedIssues: reopenedIssues ?? this.reopenedIssues,
      resolutionRate: resolutionRate ?? this.resolutionRate,
      avgResolutionHours: avgResolutionHours ?? this.avgResolutionHours,
      categoriesBreakdownJson:
          categoriesBreakdownJson ?? this.categoriesBreakdownJson,
      departmentPerformanceJson:
          departmentPerformanceJson ?? this.departmentPerformanceJson,
    );
  }
}
