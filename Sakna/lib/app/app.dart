import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/router/app_router.dart';
import '../config/theme/app_theme.dart';
import '../config/theme/theme_provider.dart';
import '../features/localization/presentation/providers/localization_providers.dart';

class SakanaApp extends ConsumerWidget {
  const SakanaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Sakana',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme.buildTheme(themeColors),
      // RTL Support for Arabic
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'), // Arabic
        Locale('en', 'US'), // English
      ],
      locale: locale,
    );
  }
}
