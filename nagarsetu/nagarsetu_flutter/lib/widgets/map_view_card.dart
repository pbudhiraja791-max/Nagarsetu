import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/city.dart';
import '../models/report_model.dart';

class MapViewCard extends StatefulWidget {
  final City city;
  final List<CivicIssueItem> issues;
  final Function(CivicIssueItem issue)? onResolveClick;

  const MapViewCard({
    super.key,
    required this.city,
    required this.issues,
    this.onResolveClick,
  });

  @override
  State<MapViewCard> createState() => _MapViewCardState();
}

class _MapViewCardState extends State<MapViewCard> {
  String _selectedFilter = 'All';
  CivicIssueItem? _hoveredIssue;

  @override
  Widget build(BuildContext context) {
    final filteredIssues = widget.issues.where((issue) {
      if (_selectedFilter == 'Open') return issue.status == IssueStatus.open;
      if (_selectedFilter == 'In Progress') return issue.status == IssueStatus.inProgress;
      if (_selectedFilter == 'Resolved') return issue.status == IssueStatus.resolved;
      return true;
    }).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header & Filter Pills
          Row(
            children: [
              const Icon(Icons.location_on_rounded, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Problems Around You',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
              const Spacer(),
              // Filter pills
              _buildFilterPill('All'),
              const SizedBox(width: 6),
              _buildFilterPill('Open', color: AppColors.open),
              const SizedBox(width: 6),
              _buildFilterPill('In Progress', color: AppColors.inProgress),
              const SizedBox(width: 6),
              _buildFilterPill('Resolved', color: AppColors.resolved),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Explore civic reports across ${widget.city.name}. Click on a marker for details.',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Custom Interactive Map Surface
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 290,
              width: double.infinity,
              color: const Color(0xFFF1F5F9),
              child: Stack(
                children: [
                  // Vector City Street Canvas
                  CustomPaint(
                    size: const Size(double.infinity, 290),
                    painter: _CityMapPainter(),
                  ),

                  // Center City Marker with Radar Pulse
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Text(
                            widget.city.name,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Markers for Issues
                  ...filteredIssues.map((issue) {
                    final xNorm = 0.5 + (issue.lngOffset * 15);
                    final yNorm = 0.5 - (issue.latOffset * 15);

                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final left = (xNorm * constraints.maxWidth).clamp(20.0, constraints.maxWidth - 50.0);
                        final top = (yNorm * 290).clamp(20.0, 240.0);

                        return Positioned(
                          left: left,
                          top: top,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _hoveredIssue = issue;
                              });
                            },
                            child: AnimatedScale(
                              scale: _hoveredIssue?.id == issue.id ? 1.25 : 1.0,
                              duration: const Duration(milliseconds: 150),
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: issue.statusColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: issue.statusColor.withOpacity(0.4),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    issue.status == IssueStatus.resolved
                                        ? Icons.check
                                        : (issue.status == IssueStatus.inProgress ? Icons.timelapse : Icons.priority_high),
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),

                  // Active Tooltip Info Card
                  if (_hoveredIssue != null)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: _hoveredIssue!.statusBgColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.info_outline,
                                color: _hoveredIssue!.statusColor,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${_hoveredIssue!.title} (${_hoveredIssue!.id})',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.navy,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '${_hoveredIssue!.location} • ${_hoveredIssue!.statusLabel}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: _hoveredIssue!.statusColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (_hoveredIssue!.status != IssueStatus.resolved && widget.onResolveClick != null) ...[
                              ElevatedButton(
                                onPressed: () {
                                  widget.onResolveClick!(_hoveredIssue!);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.resolved,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  elevation: 0,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Officer Resolve',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            IconButton(
                              icon: const Icon(Icons.close, size: 16, color: AppColors.textMuted),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                setState(() {
                                  _hoveredIssue = null;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Bottom Legend
          Row(
            children: [
              _buildLegendItem('Open', AppColors.open),
              const SizedBox(width: 16),
              _buildLegendItem('In Progress', AppColors.inProgress),
              const SizedBox(width: 16),
              _buildLegendItem('Resolved', AppColors.resolved),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String label, {Color? color}) {
    final isSelected = _selectedFilter == label;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? (color ?? AppColors.primary) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _CityMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final riverPaint = Paint()
      ..color = const Color(0xFFCCE4FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round;

    final pathRiver = Path();
    pathRiver.moveTo(size.width * 0.1, 0);
    pathRiver.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.5,
      size.width * 0.45,
      size.height,
    );
    canvas.drawPath(pathRiver, riverPaint);

    final roadPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    final roadBorderPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;

    // Grid Roads
    final List<Path> roads = [];

    for (double y = 40; y < size.height; y += 70) {
      final p = Path()..moveTo(0, y)..lineTo(size.width, y);
      roads.add(p);
    }

    for (double x = 60; x < size.width; x += 110) {
      final p = Path()..moveTo(x, 0)..lineTo(x, size.height);
      roads.add(p);
    }

    final diagonal = Path()
      ..moveTo(size.width * 0.8, 0)
      ..lineTo(size.width * 0.2, size.height);
    roads.add(diagonal);

    for (final r in roads) {
      canvas.drawPath(r, roadBorderPaint);
      canvas.drawPath(r, roadPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
