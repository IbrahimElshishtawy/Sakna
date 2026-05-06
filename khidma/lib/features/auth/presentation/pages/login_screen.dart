// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_routes.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/login_form.dart';
import '../widgets/social_auth_section.dart';

/// Unified Login Screen — premium glassmorphic design.
/// No role selection; single entry point for all users.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _contentController;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();

    // Animated gradient background
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    // Content entrance animation
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _contentFade = CurvedAnimation(
      parent: _contentController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _contentSlide =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: const Interval(0.1, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    _contentController.forward();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _showCustomSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        content: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.redAccent.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.redAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is AuthFailure) {
            _showCustomSnackBar(state.message);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.lerp(
                      Alignment.topLeft,
                      Alignment.topRight,
                      _bgController.value,
                    )!,
                    end: Alignment.lerp(
                      Alignment.bottomRight,
                      Alignment.bottomLeft,
                      _bgController.value,
                    )!,
                    colors: const [
                      Color(0xFF0A1628),
                      Color(0xFF0D47A1),
                      Color(0xFF1565C0),
                      Color(0xFF0A1628),
                    ],
                    stops: [
                      0.0,
                      0.3 + (_bgController.value * 0.2),
                      0.6 + (_bgController.value * 0.1),
                      1.0,
                    ],
                  ),
                ),
                child: child,
              );
            },
            child: SafeArea(
              child: Stack(
                children: [
                  // Decorative blur circles
                  Positioned(
                    top: screenHeight * 0.05,
                    right: -60,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF42A5F5).withValues(alpha: 0.15),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: screenHeight * 0.15,
                    left: -80,
                    child: Container(
                      width: 250,
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF1565C0).withValues(alpha: 0.12),
                      ),
                    ),
                  ),

                  // Main Content
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          24,
                          24,
                          24,
                          24 + viewInsetsBottom,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight - viewInsetsBottom,
                          ),
                          child: FadeTransition(
                            opacity: _contentFade,
                            child: SlideTransition(
                              position: _contentSlide,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(height: screenHeight * 0.06),

                                  // Hero Logo
                                  Hero(
                                    tag: 'khidma_logo',
                                    child: Center(
                                      child: Container(
                                        width: 130,
                                        height: 130,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          color: Colors.white.withValues(
                                            alpha: 0.12,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.25,
                                            ),
                                            width: 1.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFF42A5F5,
                                              ).withValues(alpha: 0.3),
                                              blurRadius: 30,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            22,
                                          ),
                                          child: Image.asset(
                                            'assets/icons/iconApp.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Glassmorphic Card
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(24),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 15,
                                        sigmaY: 15,
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(24),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                          color: Colors.white.withValues(
                                            alpha: 0.08,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.15,
                                            ),
                                            width: 1,
                                          ),
                                        ),
                                        child: const Column(
                                          children: [
                                            LoginForm(),
                                            SizedBox(height: 28),
                                            SocialAuthSection(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 28),

                                  // Sign up prompt
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'ليس لديك حساب؟',
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.6,
                                          ),
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            AppRoutes.register,
                                          );
                                        },
                                        child: const Text(
                                          'إنشاء حساب',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
