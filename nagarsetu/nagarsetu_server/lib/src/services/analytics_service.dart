import 'dart:convert';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AnalyticsService {
  /// Computes comprehensive civic performance and issue intelligence analytics
  static Future<DashboardAnalytics> getDashboardAnalytics(Session session) async {
    final allIssues = await CivicIssue.db.find(session);
    final allReports = await CitizenReport.db.find(session);

    final totalIssues = allIssues.length;
    final totalReports = allReports.length;

    // Unique citizens count
    final uniqueCitizensSet = allReports.map((r) => r.citizenId).toSet();
    final totalUniqueCitizens = uniqueCitizensSet.length;

    int openIssues = 0;
    int resolvedIssues = 0;
    int inProgressIssues = 0;
    int reopenedIssues = 0;
    double totalResolutionHours = 0.0;
    int resolvedCountForAvg = 0;

    final categoryMap = <String, int>{};
    final departmentMap = <int, Map<String, int>>{};

    for (final issue in allIssues) {
      final status = issue.status.toUpperCase();
      if (status == 'RESOLVED' || status == 'CLOSED') {
        resolvedIssues++;
        if (issue.resolvedAt != null) {
          final diff = issue.resolvedAt!.difference(issue.firstReportedAt).inMinutes / 60.0;
          if (diff > 0) {
            totalResolutionHours += diff;
            resolvedCountForAvg++;
          }
        }
      } else if (status == 'IN_PROGRESS' || status == 'ASSIGNED' || status == 'RESOLUTION_SUBMITTED') {
        inProgressIssues++;
      } else if (status == 'REOPENED') {
        reopenedIssues++;
      } else {
        openIssues++;
      }

      // Category breakdown
      categoryMap[issue.category] = (categoryMap[issue.category] ?? 0) + issue.totalReports;

      // Department breakdown
      if (issue.assignedDepartmentId != null) {
        final deptId = issue.assignedDepartmentId!;
        departmentMap.putIfAbsent(deptId, () => {'total': 0, 'resolved': 0});
        departmentMap[deptId]!['total'] = departmentMap[deptId]!['total']! + 1;
        if (status == 'RESOLVED' || status == 'CLOSED') {
          departmentMap[deptId]!['resolved'] = departmentMap[deptId]!['resolved']! + 1;
        }
      }
    }

    final resolutionRate = totalIssues > 0 ? (resolvedIssues / totalIssues) * 100.0 : 0.0;
    final avgResolutionHours = resolvedCountForAvg > 0 ? (totalResolutionHours / resolvedCountForAvg) : 0.0;

    return DashboardAnalytics(
      totalReports: totalReports,
      totalUniqueCitizens: totalUniqueCitizens,
      totalCivicIssues: totalIssues,
      openIssues: openIssues,
      resolvedIssues: resolvedIssues,
      inProgressIssues: inProgressIssues,
      reopenedIssues: reopenedIssues,
      resolutionRate: double.parse(resolutionRate.toStringAsFixed(2)),
      avgResolutionHours: double.parse(avgResolutionHours.toStringAsFixed(2)),
      categoriesBreakdownJson: jsonEncode(categoryMap),
      departmentPerformanceJson: jsonEncode(departmentMap),
    );
  }
}
