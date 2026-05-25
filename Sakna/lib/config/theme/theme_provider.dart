import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import 'theme_state.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedMode = prefs.getString(_key);
    if (savedMode == 'light') {
      return ThemeMode.light;
    } else {
      return ThemeMode.dark; // Default to dark mode (luxury navy & gold)
    }
  }

  Future<void> toggleTheme() async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
      await prefs.setString(_key, 'light');
    } else {
      state = ThemeMode.dark;
      await prefs.setString(_key, 'dark');
    }
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

final themeColorsProvider = Provider<ThemeColors>((ref) {
  final mode = ref.watch(themeModeProvider);
  return mode == ThemeMode.dark ? ThemeColors.darkPalette : ThemeColors.lightPalette;
});
