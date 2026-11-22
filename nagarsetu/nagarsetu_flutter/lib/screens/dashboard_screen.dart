import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/city.dart';
import '../models/report_model.dart';
import '../widgets/sidebar.dart';
import '../widgets/top_navbar.dart';
import '../widgets/hero_banner.dart';
import '../widgets/quick_report_card.dart';
import '../widgets/track_report_card.dart';
import '../widgets/map_view_card.dart';
import '../widgets/recent_activity_card.dart';
import '../widgets/stats_and_location_panel.dart';
import '../widgets/report_submission_dialog.dart';
import '../widgets/officer_resolution_dialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _activeNavIndex = 0;
  City _currentCity = City.defaultCities.first; // Defaults to Indore
  List<CivicIssueItem> _issues = List.from(CivicIssueItem.initialIssues);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openReportDialog({String initialCategory = 'Potholes'}) {
    showDialog(
      context: context,
      builder: (context) => ReportSubmissionDialog(
        currentCity: _currentCity,
        initialCategory: initialCategory,
        onReportCreated: (result) {
          final newReportId = result['reportId'] ?? 'NS999';
          setState(() {
            _issues.insert(
              0,
              CivicIssueItem(
                id: newReportId,
                title: 'Citizen reported $initialCategory',
                category: initialCategory,
                status: IssueStatus.open,
                location: 'Main Road, ${_currentCity.name}',
                latOffset: 0.006,
                lngOffset: -0.004,
                timeAgo: 'Just now',
                description: 'Registered via NagarSetu Web App.',
              ),
            );
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.primary,
              behavior: SnackBarBehavior.floating,
              content: Row(
                children: [
                  const Icon(Icons.check_circle_rounded, color: Colors.white),
                  const SizedBox(width: 10),
                  Text('Report $newReportId submitted successfully!'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openOfficerResolutionDialog(CivicIssueItem issue) {
    showDialog(
      context: context,
      builder: (context) => OfficerResolutionDialog(
        issue: issue,
        onResolved: () {
          setState(() {
            final idx = _issues.indexWhere((i) => i.id == issue.id);
            if (idx != -1) {
              _issues[idx] = CivicIssueItem(
                id: issue.id,
                title: issue.title,
                category: issue.category,
                status: IssueStatus.resolved,
                location: issue.location,
                latOffset: issue.latOffset,
                lngOffset: issue.lngOffset,
                timeAgo: 'Just resolved',
                description: 'Repaired by Municipal Maintenance Crew.',
              );
            }
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.resolved,
              behavior: SnackBarBehavior.floating,
              content: Row(
                children: [
                  const Icon(Icons.verified_rounded, color: Colors.white),
                  const SizedBox(width: 10),
                  Text('Issue ${issue.id} marked as RESOLVED by Municipal Officer!'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCityPickerDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text(
          'Select Your City',
          style: TextStyle(
            color: AppColors.navy,
            fontWeight: FontWeight.w700,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        children: City.defaultCities.map((city) {
          final isSelected = city.id == _currentCity.id;
          return SimpleDialogOption(
            onPressed: () {
              setState(() {
                _currentCity = city;
              });
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: isSelected ? AppColors.primary : AppColors.textMuted,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${city.name}, ${city.state}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.navy,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    const Icon(Icons.check, color: AppColors.primary, size: 18),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 1100;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: !isDesktop
          ? Drawer(
              child: Sidebar(
                activeIndex: _activeNavIndex,
                onSelect: (index) {
                  setState(() => _activeNavIndex = index);
                  Navigator.of(context).pop();
                },
              ),
            )
          : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Fixed Left Sidebar on Desktop
          if (isDesktop)
            Sidebar(
              activeIndex: _activeNavIndex,
              onSelect: (index) {
                setState(() => _activeNavIndex = index);
              },
            ),

          // 2. Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Navbar
                TopNavbar(
                  currentCity: _currentCity,
                  onCityChanged: (city) {
                    setState(() => _currentCity = city);
                  },
                  onOpenDrawer: !isDesktop
                      ? () => _scaffoldKey.currentState?.openDrawer()
                      : null,
                ),

                // Scrollable Dashboard Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Hero Banner
                        HeroBanner(
                          onReportClick: () => _openReportDialog(initialCategory: 'Potholes'),
                        ),

                        const SizedBox(height: 24),

                        // Two Column Layout: Main Widgets + Right Stats Panel
                        if (screenWidth >= 1200)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Main content section (Quick Report, Track, Map, Activity)
                              Expanded(
                                flex: 7,
                                child: Column(
                                  children: [
                                    // Row 1: Quick Report & Track Report
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: QuickReportCard(
                                            onCategorySelected: (cat) {},
                                            onUploadPhoto: () => _openReportDialog(initialCategory: 'Potholes'),
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        const Expanded(
                                          flex: 5,
                                          child: TrackReportCard(),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 24),

                                    // Row 2: Problems Around You & Recently Reported
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 6,
                                          child: MapViewCard(
                                            city: _currentCity,
                                            issues: _issues,
                                            onResolveClick: _openOfficerResolutionDialog,
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        Expanded(
                                          flex: 5,
                                          child: RecentActivityCard(items: _issues),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 24),

                              // Right sidebar: Location & 3 Community Stats
                              SizedBox(
                                width: 320,
                                child: StatsAndLocationPanel(
                                  currentCity: _currentCity,
                                  onChangeLocation: _showCityPickerDialog,
                                  onReportNow: () => _openReportDialog(initialCategory: 'Potholes'),
                                ),
                              ),
                            ],
                          )
                        else
                          // Stacked column layout for tablet & mobile
                          Column(
                            children: [
                              QuickReportCard(
                                onCategorySelected: (cat) {},
                                onUploadPhoto: () => _openReportDialog(initialCategory: 'Potholes'),
                              ),
                              const SizedBox(height: 20),
                              const TrackReportCard(),
                              const SizedBox(height: 20),
                              MapViewCard(
                                city: _currentCity,
                                issues: _issues,
                                onResolveClick: _openOfficerResolutionDialog,
                              ),
                              const SizedBox(height: 20),
                              RecentActivityCard(items: _issues),
                              const SizedBox(height: 20),
                              StatsAndLocationPanel(
                                currentCity: _currentCity,
                                onChangeLocation: _showCityPickerDialog,
                                onReportNow: () => _openReportDialog(initialCategory: 'Potholes'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
