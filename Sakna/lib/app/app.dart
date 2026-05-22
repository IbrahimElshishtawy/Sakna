import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../config/router/app_router.dart';
import '../config/theme/app_colors.dart';

class SakanaApp extends StatelessWidget {
  const SakanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Sakana',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        fontFamily: 'Cairo', // Using Cairo or similar Arabic font
        useMaterial3: true,
      ),
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
      locale: const Locale('ar', 'AE'), // Default to Arabic
    );
  }
}
