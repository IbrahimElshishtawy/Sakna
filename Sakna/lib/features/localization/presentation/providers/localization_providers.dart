import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../domain/entities/app_translations.dart';

class LocaleNotifier extends Notifier<Locale> {
  static const _key = 'selected_lang';

  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final savedLang = prefs.getString(_key);
    if (savedLang == 'en') {
      return const Locale('en', 'US');
    } else {
      return const Locale('ar', 'AE'); // Default to Arabic
    }
  }

  Future<void> toggleLocale() async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (state.languageCode == 'ar') {
      state = const Locale('en', 'US');
      await prefs.setString(_key, 'en');
    } else {
      state = const Locale('ar', 'AE');
      await prefs.setString(_key, 'ar');
    }
  }

  Future<void> setLocale(String langCode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    if (langCode == 'en') {
      state = const Locale('en', 'US');
      await prefs.setString(_key, 'en');
    } else {
      state = const Locale('ar', 'AE');
      await prefs.setString(_key, 'ar');
    }
  }
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class AppTranslator {
  final Locale locale;
  AppTranslator(this.locale);

  String translate(String key) {
    return AppTranslations.translate(locale.languageCode, key);
  }

  bool get isArabic => locale.languageCode == 'ar';
}

final translationProvider = Provider<AppTranslator>((ref) {
  final locale = ref.watch(localeProvider);
  return AppTranslator(locale);
});
