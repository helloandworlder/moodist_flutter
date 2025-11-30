import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ========== Youthful & Soothing Color Palette ==========
  
  // Primary - Soft Lavender/Periwinkle
  static const primaryStart = Color(0xFFA78BFA);
  static const primaryEnd = Color(0xFF818CF8);
  static const primary = Color(0xFFA78BFA);
  static const primaryLight = Color(0xFFC4B5FD);
  static const primaryDark = Color(0xFF8B5CF6);

  // Secondary - Gentle Coral/Peach
  static const secondaryStart = Color(0xFFFDA4AF);
  static const secondaryEnd = Color(0xFFFB7185);
  static const secondary = Color(0xFFFDA4AF);
  static const secondaryLight = Color(0xFFFECDD3);
  static const secondaryDark = Color(0xFFF43F5E);

  // Accent - Fresh Mint
  static const accentStart = Color(0xFF6EE7B7);
  static const accentEnd = Color(0xFF34D399);
  static const accent = Color(0xFF6EE7B7);

  // Calm gradient (Lavender → Sky Blue)
  static const calmStart = Color(0xFFC4B5FD);
  static const calmEnd = Color(0xFF93C5FD);

  // Warm gradient (Peach → Soft Coral)
  static const warmStart = Color(0xFFFED7AA);
  static const warmEnd = Color(0xFFFDA4AF);

  // Fresh gradient (Mint → Teal)
  static const freshStart = Color(0xFF6EE7B7);
  static const freshEnd = Color(0xFF5EEAD4);

  // Cool gradient (Sky Blue → Cyan)
  static const coolStart = Color(0xFF7DD3FC);
  static const coolEnd = Color(0xFF67E8F9);

  // Sunset gradient (Orange → Pink)
  static const sunsetStart = Color(0xFFFBBF24);
  static const sunsetEnd = Color(0xFFF472B6);

  // Dark theme colors - Deep Navy with warmth
  static const darkBackground = Color(0xFF0F172A);
  static const darkSurface = Color(0xFF1E293B);
  static const darkCard = Color(0xFF334155);
  static const darkCardHighlight = Color(0xFF475569);

  // Light theme colors - Warm Cream
  static const lightBackground = Color(0xFFFFFBF5);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightCard = Color(0xFFF8FAFC);
  static const lightCardHighlight = Color(0xFFF1F5F9);

  // Functional colors - Softer versions
  static const success = Color(0xFF34D399);
  static const warning = Color(0xFFFBBF24);
  static const error = Color(0xFFFB7185);
  static const info = Color(0xFF60A5FA);

  // Favorite color - Soft red
  static const favorite = Color(0xFFFB7185);

  // Category colors - Softer, more harmonious
  static const categoryNature = Color(0xFF34D399);
  static const categoryRain = Color(0xFF60A5FA);
  static const categoryAnimals = Color(0xFFFBBF24);
  static const categoryUrban = Color(0xFFA78BFA);
  static const categoryPlaces = Color(0xFFF472B6);
  static const categoryTransport = Color(0xFF2DD4BF);
  static const categoryThings = Color(0xFFC084FC);
  static const categoryNoise = Color(0xFF94A3B8);

  // ========== Gradient Helpers ==========

  static LinearGradient get primaryGradient => const LinearGradient(
    colors: [primaryStart, primaryEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get secondaryGradient => const LinearGradient(
    colors: [secondaryStart, secondaryEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get accentGradient => const LinearGradient(
    colors: [accentStart, accentEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get calmGradient => const LinearGradient(
    colors: [calmStart, calmEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get warmGradient => const LinearGradient(
    colors: [warmStart, warmEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get freshGradient => const LinearGradient(
    colors: [freshStart, freshEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get coolGradient => const LinearGradient(
    colors: [coolStart, coolEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get sunsetGradient => const LinearGradient(
    colors: [sunsetStart, sunsetEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get headerGradient => const LinearGradient(
    colors: [Color(0xFFA78BFA), Color(0xFF818CF8), Color(0xFF93C5FD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'nature':
        return categoryNature;
      case 'rain':
        return categoryRain;
      case 'animals':
        return categoryAnimals;
      case 'urban':
        return categoryUrban;
      case 'places':
        return categoryPlaces;
      case 'transport':
        return categoryTransport;
      case 'things':
        return categoryThings;
      case 'noise':
        return categoryNoise;
      default:
        return primary;
    }
  }
}
