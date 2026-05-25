import 'package:flutter/material.dart';

class ThemeColors {
  final Color primary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color border;
  final bool isDark;

  const ThemeColors({
    required this.primary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.border,
    required this.isDark,
  });

  // Dark theme palette matching mockup
  static const darkPalette = ThemeColors(
    primary: Color(0xFF031024), // Luxury deep navy
    accent: Color(0xFFFFD700),  // Bright gold
    background: Color(0xFF010A16), // Dark background
    surface: Color(0xFF051630), // Slate navy card surface
    textPrimary: Colors.white,
    textSecondary: Color(0xFF9CA3AF), // Muted gray
    border: Color(0xFF0D2547),
    isDark: true,
  );

  // Light theme palette
  static const lightPalette = ThemeColors(
    primary: Color(0xFF031024), // Keep signature navy for consistency
    accent: Color(0xFFB8860B),  // Dark gold for readability in light mode
    background: Color(0xFFF9FAFB), // Clean off-white
    surface: Colors.white, // Pure white card surface
    textPrimary: Color(0xFF111827), // Dark slate-gray text
    textSecondary: Color(0xFF6B7280), // Medium gray
    border: Color(0xFFE5E7EB), // Soft light border
    isDark: false,
  );
}
