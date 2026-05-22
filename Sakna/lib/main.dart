import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'app/app_bootstrapper.dart';
import 'features/auth/presentation/providers/auth_providers.dart';

void main() async {
  final sharedPreferences = await AppBootstrapper.init();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const SakanaApp(),
    ),
  );
}
