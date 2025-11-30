import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  // Shared animation durations
  static const Duration quickAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Shared curves
  static const Curve defaultCurve = Curves.easeOutCubic;
  static const Curve bounceCurve = Curves.elasticOut;

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.accent,
          surface: AppColors.darkSurface,
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.darkBackground,
        cardColor: AppColors.darkCard,
        cardTheme: CardThemeData(
          color: AppColors.darkCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          shadowColor: AppColors.primary.withValues(alpha: 0.1),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.white54,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.primary,
          inactiveTrackColor: AppColors.primaryLight.withValues(alpha: 0.3),
          thumbColor: Colors.white,
          overlayColor: AppColors.primary.withValues(alpha: 0.15),
          trackHeight: 6,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            side: const BorderSide(color: AppColors.primaryLight),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryLight,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white70,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: -1),
          displayMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          displaySmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          titleSmall: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white70),
          labelLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          labelMedium: TextStyle(color: Colors.white70),
          labelSmall: TextStyle(color: Colors.white54),
        ),
      );

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          tertiary: AppColors.accent,
          surface: AppColors.lightSurface,
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
        ),
        scaffoldBackgroundColor: AppColors.lightBackground,
        cardColor: AppColors.lightCard,
        cardTheme: CardThemeData(
          color: AppColors.lightCard,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          shadowColor: AppColors.primary.withValues(alpha: 0.08),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
            letterSpacing: -0.5,
          ),
          iconTheme: IconThemeData(color: Color(0xFF1E293B)),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.lightSurface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Color(0xFF94A3B8),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.primary,
          inactiveTrackColor: AppColors.primary.withValues(alpha: 0.2),
          thumbColor: AppColors.primary,
          overlayColor: AppColors.primary.withValues(alpha: 0.15),
          trackHeight: 6,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
        ),
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.lightSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightCard,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF64748B),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, letterSpacing: -1),
          displayMedium: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold, letterSpacing: -0.5),
          displaySmall: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w600),
          titleLarge: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w500),
          titleSmall: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(color: Color(0xFF1E293B)),
          bodyMedium: TextStyle(color: Color(0xFF1E293B)),
          bodySmall: TextStyle(color: Color(0xFF64748B)),
          labelLarge: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w500),
          labelMedium: TextStyle(color: Color(0xFF64748B)),
          labelSmall: TextStyle(color: Color(0xFF94A3B8)),
        ),
      );
}
