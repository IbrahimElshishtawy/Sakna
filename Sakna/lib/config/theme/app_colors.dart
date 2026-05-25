import 'package:flutter/material.dart';
import 'theme_state.dart';

class AppColors {
  // Static fallback constants
  static const Color primary = Color(0xFF031024); // Dark navy
  static const Color accent = Color(0xFFFFD700); // Gold/Yellow
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color background = Color(0xFFF9FAFB);
  static const Color white = Colors.white;
  static const Color greyLight = Color(0xFFE5E7EB);

  // Theme palettes
  static const ThemeColors dark = ThemeColors.darkPalette;
  static const ThemeColors light = ThemeColors.lightPalette;
}
