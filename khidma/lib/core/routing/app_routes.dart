import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String home = '/home';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    // TODO: Add redirect logic based on AuthBloc state
    // redirect: (BuildContext context, GoRouterState state) {
    //   final bool isAuthenticated = ...
    //   if (!isAuthenticated && state.matchedLocation != login) return login;
    //   if (isAuthenticated && state.matchedLocation == login) return home;
    //   return null;
    // },
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Login Placeholder')),
        ),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Home Placeholder')),
        ),
      ),
    ],
  );
}
