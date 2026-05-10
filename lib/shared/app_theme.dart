// ═══════════════════════════════════════════════════════════
//  app_theme.dart
//  ✅ خط Cairo — الأفضل للعربية في Flutter
//  ✅ ألوان موحّدة مع AppColors
//  ✅ TextTheme متناسق في كل الشاشات
//  ✅ Light & Dark محترف
//
//  pubspec.yaml — أضف:
//  google_fonts: ^6.2.1
//
//  أو أضف الخط يدوياً:
//  flutter:
//    fonts:
//      - family: Cairo
//        fonts:
//          - asset: assets/fonts/Cairo-Regular.ttf
//          - asset: assets/fonts/Cairo-Medium.ttf  weight: 500
//          - asset: assets/fonts/Cairo-SemiBold.ttf weight: 600
//          - asset: assets/fonts/Cairo-Bold.ttf    weight: 700
//          - asset: assets/fonts/Cairo-ExtraBold.ttf weight: 800
// ═══════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  // ── Brand Color (مصدر واحد للون الذهبي) ────────────────
  static const Color gold = Color(0xFFE8960C);
  static const Color goldLight = Color(0xFFF5B53F);
  static const Color goldDark = Color(0xFFA86A08);

  // ── Light Palette ────────────────────────────────────────
  static const Color _lightBg = Color(0xFFFAFAFA);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightText = Color(0xFF0D0D0D);
  static const Color _lightTextSub = Color(0xFF6B6B6B);
  static const Color _lightTextMuted = Color(0xFFBBBBBB);
  static const Color _lightBorder = Color(0xFFEEEEEE);

  // ── Dark Palette ─────────────────────────────────────────
  static const Color _darkBg = Color(0xFF080808);
  static const Color _darkSurface = Color(0xFF111111);
  static const Color _darkText = Color(0xFFFFFFFF);
  static const Color _darkTextSub = Color(0xFF888888);
  static const Color _darkTextMuted = Color(0xFF444444);
  static const Color _darkBorder = Color(0xFF242424);

  // ════════════════════════════════════════════════════════
  //  Light Theme
  // ════════════════════════════════════════════════════════
  static final ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    fontFamily: 'Cairo',

    // ── Scaffold ─────────────────────────────────────────
    scaffoldBackgroundColor: _lightBg,

    // ── Color Scheme ─────────────────────────────────────
    colorScheme: ColorScheme.fromSeed(
      seedColor: gold,
      brightness: Brightness.light,
      primary: gold,
      onPrimary: Colors.white,
      surface: _lightSurface,
      onSurface: _lightText,
      background: _lightBg,
      error: const Color(0xFFE05252),
    ),

    // ── Typography ────────────────────────────────────────
    // Cairo يدعم العربية بشكل ممتاز مع وزن صحيح
    textTheme: const TextTheme(
      // عناوين كبيرة (اسم التطبيق، عناوين الصفحات)
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: _lightText,
        height: 1.3,
        letterSpacing: -0.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: _lightText,
        height: 1.3,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: _lightText,
        height: 1.3,
      ),

      // عناوين متوسطة (بطاقات، sections)
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _lightText,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: _lightText,
        height: 1.4,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: _lightText,
        height: 1.4,
      ),

      // نصوص أساسية (وصف المنتج، محتوى)
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: _lightText,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: _lightTextSub,
        height: 1.6,
      ),
      bodySmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: _lightTextMuted,
        height: 1.5,
      ),

      // تسميات (أزرار، labels)
      labelLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: _lightText,
        height: 1.2,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: _lightTextSub,
        height: 1.2,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: _lightTextMuted,
        letterSpacing: 0.5,
        height: 1.2,
      ),
    ),

    // ── AppBar ────────────────────────────────────────────
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: _lightSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: _lightText, size: 20),
      titleTextStyle: TextStyle(
        color: _lightText,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        fontFamily: 'Cairo',
        height: 1.2,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),

    // ── Divider ───────────────────────────────────────────
    dividerTheme: const DividerThemeData(
      color: _lightBorder,
      thickness: 0.5,
      space: 0,
    ),

    // ── ElevatedButton ────────────────────────────────────
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: gold,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 52),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),

    // ── TextButton ────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: gold,
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ── InputDecoration ───────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _lightSurface,
      hintStyle: const TextStyle(
        color: _lightTextMuted,
        fontSize: 13,
        fontFamily: 'Cairo',
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _lightBorder, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _lightBorder, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: gold, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE05252), width: 0.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE05252), width: 1.0),
      ),
    ),

    // ── SnackBar ──────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      backgroundColor: _lightText,
      contentTextStyle: const TextStyle(
        color: Colors.white,
        fontFamily: 'Cairo',
        fontSize: 13,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  // ════════════════════════════════════════════════════════
  //  Dark Theme
  // ════════════════════════════════════════════════════════
  static final ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    fontFamily: 'Cairo',

    scaffoldBackgroundColor: _darkBg,

    colorScheme: ColorScheme.fromSeed(
      seedColor: gold,
      brightness: Brightness.dark,
      primary: gold,
      onPrimary: Colors.white,
      surface: _darkSurface,
      onSurface: _darkText,
      background: _darkBg,
      error: const Color(0xFFE05252),
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: _darkText,
        height: 1.3,
        letterSpacing: -0.3,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: _darkText,
        height: 1.3,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: _darkText,
        height: 1.3,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: _darkText,
        height: 1.4,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: _darkText,
        height: 1.4,
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: _darkText,
        height: 1.4,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: _darkText,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: _darkTextSub,
        height: 1.6,
      ),
      bodySmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w400,
        color: _darkTextMuted,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: _darkText,
        height: 1.2,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: _darkTextSub,
        height: 1.2,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: _darkTextMuted,
        letterSpacing: 0.5,
        height: 1.2,
      ),
    ),

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: _darkBg,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(color: _darkText, size: 20),
      titleTextStyle: TextStyle(
        color: _darkText,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        fontFamily: 'Cairo',
        height: 1.2,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    ),

    dividerTheme: const DividerThemeData(
      color: _darkBorder,
      thickness: 0.5,
      space: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: gold,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        minimumSize: const Size(double.infinity, 52),
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: gold,
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: _darkSurface,
      hintStyle: const TextStyle(
        color: _darkTextMuted,
        fontSize: 13,
        fontFamily: 'Cairo',
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _darkBorder, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _darkBorder, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: gold, width: 1.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE05252), width: 0.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE05252), width: 1.0),
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: _darkSurface,
      contentTextStyle: const TextStyle(
        color: _darkText,
        fontFamily: 'Cairo',
        fontSize: 13,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}

// ═══════════════════════════════════════════════════════════
//  AppTextStyles — استخدمها مباشرة في أي widget
//  بدل كتابة TextStyle في كل مكان
//
//  مثال:
//  Text('اسم المنتج', style: AppTextStyles.title)
//  Text('الوصف', style: AppTextStyles.body)
//  Text('$1,099', style: AppTextStyles.price)
// ═══════════════════════════════════════════════════════════
class AppTextStyles {
  AppTextStyles._();

  static const String _font = 'Cairo';
  static const Color _gold = Color(0xFFE8960C);

  // ── عناوين ───────────────────────────────────────────────
  static const TextStyle pageTitle = TextStyle(
    fontFamily: _font,
    fontSize: 17,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.2,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static const TextStyle cardTitle = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ── نصوص أساسية ──────────────────────────────────────────
  static const TextStyle body = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ── سعر ──────────────────────────────────────────────────
  static const TextStyle price = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: _gold,
    height: 1.2,
  );

  static const TextStyle priceSmall = TextStyle(
    fontFamily: _font,
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: _gold,
    height: 1.2,
  );

  // ── أزرار ─────────────────────────────────────────────────
  static const TextStyle button = TextStyle(
    fontFamily: _font,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: Colors.white,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  // ── تسميات ───────────────────────────────────────────────
  static const TextStyle label = TextStyle(
    fontFamily: _font,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
  );

  static const TextStyle tag = TextStyle(
    fontFamily: _font,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.5,
    color: Colors.white,
    height: 1.2,
  );

  // ── AppBar Brand ──────────────────────────────────────────
  static const TextStyle brandLight = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w300,
    letterSpacing: 2,
    color: Color(0xFF1A1A1A),
  );

  static const TextStyle brandBold = TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w800,
    letterSpacing: 2,
    color: _gold,
  );
}
