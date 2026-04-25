// ═══════════════════════════════════════════════════════════
//  app_colors.dart
//  Single source of truth for ALL colors in the app.
//  Use AppColors.of(context).X everywhere — never hardcode.
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';

class AppColors {
  final bool isDark;

  const AppColors._(this.isDark);

  static AppColors of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppColors._(isDark);
  }

  // ── Brand ────────────────────────────────────────────────
  Color get gold => const Color(0xFFE8960C);
  Color get goldDim => const Color(0xFFA86A08);
  Color get goldSurface =>
      isDark ? const Color(0xFF1C1400) : const Color(0xFFFFF8EE);

  // ── Backgrounds ──────────────────────────────────────────
  Color get bg => isDark ? const Color(0xFF080808) : const Color(0xFFFAFAFA);

  Color get bgSecondary => isDark ? const Color(0xFF111111) : Colors.white;

  Color get surface => isDark ? const Color(0xFF161616) : Colors.white;

  Color get surfaceHigh =>
      isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5);

  // ── Borders ───────────────────────────────────────────────
  Color get border =>
      isDark ? const Color(0xFF242424) : const Color(0xFFEEEEEE);

  Color get borderLight =>
      isDark ? const Color(0xFF1C1C1C) : const Color(0xFFF5F5F5);

  // ── Text ──────────────────────────────────────────────────
  Color get textPrimary =>
      isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0D0D0D);

  Color get textSecondary =>
      isDark ? const Color(0xFF888888) : const Color(0xFF666666);

  Color get textMuted =>
      isDark ? const Color(0xFF444444) : const Color(0xFFBBBBBB);

  // ── Profile header gradient ───────────────────────────────
  List<Color> get profileGradient => isDark
      ? [
          const Color(0xFF0F0A00),
          const Color(0xFF130E00),
          const Color(0xFF0A0A0A),
        ]
      : [
          const Color(0xFFFFF8EE),
          const Color(0xFFFFF3DC),
          const Color(0xFFFAFAFA),
        ];

  // ── Home background gradient ──────────────────────────────
  List<Color> get homeBgGradient => isDark
      ? [const Color(0xFF0A0A0A), const Color(0xFF080808)]
      : [const Color(0xFFFFF9F0), const Color(0xFFFBFBFB), Colors.white];

  // ── Semantic colors ───────────────────────────────────────
  Color get error => const Color(0xFFE05252);
  Color get success => const Color(0xFF2D7D46);

  // ── Icon backgrounds ──────────────────────────────────────
  Color iconBg(Color base) => base.withOpacity(isDark ? 0.12 : 0.10);
}

// ═══════════════════════════════════════════════════════════
//  AppTheme — ThemeData factory
// ═══════════════════════════════════════════════════════════
class AppTheme {
  static const _gold = Color(0xFFE8960C);

  static ThemeData dark() => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF080808),
    primaryColor: _gold,
    colorScheme: const ColorScheme.dark(
      primary: _gold,
      surface: Color(0xFF111111),
      background: Color(0xFF080808),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF080808),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    dividerColor: const Color(0xFF242424),
    fontFamily: 'Cairo',
  );

  static ThemeData light() => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    primaryColor: _gold,
    colorScheme: const ColorScheme.light(
      primary: _gold,
      surface: Colors.white,
      background: Color(0xFFFAFAFA),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFF0D0D0D),
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      iconTheme: IconThemeData(color: Color(0xFF0D0D0D)),
    ),
    dividerColor: const Color(0xFFEEEEEE),
    fontFamily: 'Cairo',
  );
}
