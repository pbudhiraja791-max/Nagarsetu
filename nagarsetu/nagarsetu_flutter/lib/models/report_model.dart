import 'package:flutter/material.dart';

enum IssueStatus {
  open,
  inProgress,
  resolved,
}

class CivicIssueItem {
  final String id;
  final String title;
  final String category;
  final IssueStatus status;
  final String location;
  final double latOffset; // Relative offset from city center (-0.05 to +0.05)
  final double lngOffset;
  final String timeAgo;
  final int upvotes;
  final String description;

  const CivicIssueItem({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.location,
    required this.latOffset,
    required this.lngOffset,
    required this.timeAgo,
    this.upvotes = 1,
    this.description = '',
  });

  String get statusLabel {
    switch (status) {
      case IssueStatus.open:
        return 'Open';
      case IssueStatus.inProgress:
        return 'In Progress';
      case IssueStatus.resolved:
        return 'Resolved';
    }
  }

  Color get statusColor {
    switch (status) {
      case IssueStatus.open:
        return const Color(0xFFEF4444);
      case IssueStatus.inProgress:
        return const Color(0xFFF59E0B);
      case IssueStatus.resolved:
        return const Color(0xFF10B981);
    }
  }

  Color get statusBgColor {
    switch (status) {
      case IssueStatus.open:
        return const Color(0xFFFEF2F2);
      case IssueStatus.inProgress:
        return const Color(0xFFFFFBEB);
      case IssueStatus.resolved:
        return const Color(0xFFECFDF5);
    }
  }

  static List<CivicIssueItem> initialIssues = [
    const CivicIssueItem(
      id: 'NS12340',
      title: 'Pothole near Gandhi Park',
      category: 'Potholes',
      status: IssueStatus.resolved,
      location: 'Near Gandhi Park, Sector 4',
      latOffset: 0.012,
      lngOffset: -0.018,
      timeAgo: '2 hours ago',
      description: 'Asphalt resurfaced and marked with reflective safety paint.',
    ),
    const CivicIssueItem(
      id: 'NS12341',
      title: 'Garbage accumulation at Central Market',
      category: 'Garbage',
      status: IssueStatus.inProgress,
      location: 'Central Market Gate 2',
      latOffset: -0.015,
      lngOffset: 0.008,
      timeAgo: '3 hours ago',
      description: 'Municipal sanitation truck dispatched for clearing.',
    ),
    const CivicIssueItem(
      id: 'NS12342',
      title: 'Broken drainage cover on Ring Road',
      category: 'Drainage',
      status: IssueStatus.open,
      location: 'Ring Road, Junction 9',
      latOffset: 0.024,
      lngOffset: 0.022,
      timeAgo: '4 hours ago',
      description: 'Exposed manhole hazard awaiting replacement slab.',
    ),
    const CivicIssueItem(
      id: 'NS12343',
      title: 'Deep road crater causing traffic delays',
      category: 'Potholes',
      status: IssueStatus.open,
      location: 'Station Road, Flyover descent',
      latOffset: -0.022,
      lngOffset: -0.025,
      timeAgo: '5 hours ago',
      description: 'Waterlogged depression hazardous for two-wheelers.',
    ),
    const CivicIssueItem(
      id: 'NS12344',
      title: 'Overflowing community bin cleaned',
      category: 'Garbage',
      status: IssueStatus.resolved,
      location: 'Colony Main Park entrance',
      latOffset: 0.005,
      lngOffset: 0.015,
      timeAgo: '1 day ago',
      description: 'Solid waste removed and secondary container installed.',
    ),
    const CivicIssueItem(
      id: 'NS12345',
      title: 'Blocked storm drain cleared before rains',
      category: 'Drainage',
      status: IssueStatus.resolved,
      location: 'Civil Lines, North Avenue',
      latOffset: -0.008,
      lngOffset: -0.012,
      timeAgo: '1 day ago',
      description: 'Desiltation complete and water runoff restored.',
    ),
  ];
}
