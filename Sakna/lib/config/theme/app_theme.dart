import 'package:flutter/material.dart';
import 'theme_state.dart';

class AppTheme {
  static ThemeData buildTheme(ThemeColors colors) {
    return ThemeData(
      primaryColor: colors.primary,
      scaffoldBackgroundColor: colors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: colors.primary,
        primary: colors.primary,
        secondary: colors.accent,
        brightness: colors.isDark ? Brightness.dark : Brightness.light,
      ),
      fontFamily: 'Cairo',
      useMaterial3: true,
      
      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: colors.isDark ? colors.accent : Colors.white),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: colors.surface,
        elevation: 4,
        shadowColor: colors.isDark ? Colors.black45 : Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.border, width: colors.isDark ? 1 : 0.5),
        ),
      ),

      // Input Decoration Theme (Text Fields)
      inputDecorationTheme: InputDecorationTheme(
        fillColor: colors.surface,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.border, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.border, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.accent, width: 1.5),
        ),
        labelStyle: TextStyle(color: colors.textSecondary, fontFamily: 'Cairo'),
        hintStyle: TextStyle(color: colors.textSecondary, fontFamily: 'Cairo'),
      ),

      // Text Theme
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: colors.textPrimary, fontFamily: 'Cairo'),
        bodyMedium: TextStyle(color: colors.textSecondary, fontFamily: 'Cairo'),
        titleLarge: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
        titleMedium: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.w600, fontFamily: 'Cairo'),
      ),
    );
  }
}
