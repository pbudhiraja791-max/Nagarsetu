import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class QuickReportCard extends StatefulWidget {
  final Function(String category) onCategorySelected;
  final VoidCallback onUploadPhoto;

  const QuickReportCard({
    super.key,
    required this.onCategorySelected,
    required this.onUploadPhoto,
  });

  @override
  State<QuickReportCard> createState() => _QuickReportCardState();
}

class _QuickReportCardState extends State<QuickReportCard> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Potholes',
      'icon': Icons.construction_rounded,
      'color': Color(0xFF1677F5),
    },
    {
      'name': 'Garbage',
      'icon': Icons.delete_outline_rounded,
      'color': Color(0xFF10B981),
    },
    {
      'name': 'Drainage',
      'icon': Icons.water_drop_outlined,
      'color': Color(0xFF0EA5E9),
    },
  ];

  @override
  Widget build(BuildContext context) {
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
          // Header
          Row(
            children: const [
              Icon(Icons.campaign_rounded, color: AppColors.primary, size: 24),
              SizedBox(width: 10),
              Text(
                'Quick Report',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Click a photo, tell us what\'s wrong, and we\'ll take care of the rest!',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // 3 Evenly Spaced Category Cards
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: List.generate(_categories.length, (index) {
                  final cat = _categories[index];
                  final isSelected = _selectedIndex == index;

                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index < _categories.length - 1 ? 14 : 0,
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          widget.onCategorySelected(cat['name'] as String);
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primaryLight : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(0.12),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary.withOpacity(0.2)
                                        : AppColors.border,
                                  ),
                                ),
                                child: Icon(
                                  cat['icon'] as IconData,
                                  color: isSelected ? AppColors.primary : AppColors.navy,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                cat['name'] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                  color: isSelected ? AppColors.primary : AppColors.navy,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),

          const SizedBox(height: 20),

          // Upload Photo / Take Photo Action Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: widget.onUploadPhoto,
              icon: const Icon(Icons.camera_alt_rounded, size: 20),
              label: const Text(
                'Upload Photo / Take Photo',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 2,
                shadowColor: AppColors.primary.withOpacity(0.35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
