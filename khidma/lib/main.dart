import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/app_theme.dart';
import 'core/app_routes.dart';
import 'core/bloc/user_bloc/user_bloc.dart';
import 'core/bloc/user_bloc/user_event.dart';
import 'core/bloc/user_bloc/user_state.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc()..add(FetchUserStatsEvent())),
      ],
      child: const KhidmaApp(),
    ),
  );
}

class KhidmaApp extends StatelessWidget {
  const KhidmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        bool isDark = false;
        String locale = 'ar';
        if (state is UserProfileLoaded) {
          isDark = state.isDarkMode;
          locale = state.currentLocale;
        }

        return MaterialApp(
          title: 'Khidma',
          debugShowCheckedModeBanner: false,
          theme: buildLightTheme(),
          darkTheme: ThemeData.dark(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          locale: Locale(locale),
          supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.onboarding,
      scrollBehavior: const _AppScrollBehavior(),
          onGenerateRoute: AppRoutes.generateRoute,
        );
      },
    );
  }
}

class _AppScrollBehavior extends ScrollBehavior {
  const _AppScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }

  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
    PointerDeviceKind.stylus,
  };
}
