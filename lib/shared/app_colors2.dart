import 'package:flutter/material.dart';

class AppColors {
  final Color bg;
  final Color surface;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color gold;
  final Color error;

  const AppColors({
    required this.bg,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.gold,
    required this.error,
  });

  static const AppColors light = AppColors(
    bg: Color(0xFFF5F5F7),
    surface: Colors.white,
    border: Color(0xFFF0F0F0),
    textPrimary: Color(0xFF1A1A1A),
    textSecondary: Color(0xFF555555),
    textMuted: Color(0xFFAAAAAA),
    gold: Color(0xFFE8960C),
    error: Color(0xFFE53935),
  );

  static const AppColors dark = AppColors(
    bg: Color(0xFF0F0F0F),
    surface: Color(0xFF1A1A1A),
    border: Color(0xFF2A2A2A),
    textPrimary: Color(0xFFE0E0E0),
    textSecondary: Color(0xFF888888),
    textMuted: Color(0xFF555555),
    gold: Color(0xFFFF8C00),
    error: Color(0xFFEF5350),
  );

  static AppColors of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? dark : light;
  }
}