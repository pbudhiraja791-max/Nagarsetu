import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primary = Color(0xFF1677F5);
  static const Color primaryDark = Color(0xFF0F5AC0);
  static const Color primaryLight = Color(0xFFEAF4FF);
  static const Color primarySubtle = Color(0xFFF2F7FF);

  // Text & Navy
  static const Color navy = Color(0xFF0B2454);
  static const Color textPrimary = Color(0xFF0B2454);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Status Colors
  static const Color resolved = Color(0xFF10B981);
  static const Color resolvedBg = Color(0xFFECFDF5);
  static const Color inProgress = Color(0xFFF59E0B);
  static const Color inProgressBg = Color(0xFFFFFBEB);
  static const Color open = Color(0xFFEF4444);
  static const Color openBg = Color(0xFFFEF2F2);

  // Backgrounds & Surfaces
  static const Color background = Color(0xFFF2F7FF);
  static const Color cardBg = Colors.white;
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderHover = Color(0xFFCBD5E1);

  // Shadows
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF0B2454).withOpacity(0.04),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0xFF0B2454).withOpacity(0.02),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> hoverShadow = [
    BoxShadow(
      color: const Color(0xFF1677F5).withOpacity(0.12),
      blurRadius: 20,
      offset: const Offset(0, 6),
    ),
  ];
}
