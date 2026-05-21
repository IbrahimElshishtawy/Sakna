import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/app_routes.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/register_bloc.dart';
import '../bloc/register_event.dart';
import '../bloc/register_state.dart';

import '../widgets/registration/step_basic_info.dart';
import '../widgets/registration/step_security.dart';
import '../widgets/registration/step_otp.dart';
import '../widgets/registration/step_kyc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bgController.dispose();
    super.dispose();
  }

  void _showCustomSnackBar(BuildContext context, String message) {
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
      create: (_) => sl<RegisterBloc>(),
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listenWhen: (previous, current) =>
            previous.currentStep != current.currentStep ||
            previous.status != current.status,
        listener: (context, state) {
          if (state.status == RegisterStatus.failure &&
              state.errorMessage != null) {
            _showCustomSnackBar(context, state.errorMessage!);
          } else if (state.status == RegisterStatus.success) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          }

          // Animate PageView to current step
          if (_pageController.hasClients &&
              _pageController.page?.round() != state.currentStep) {
            _pageController.animateToPage(
              state.currentStep,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
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
                          color:
                              const Color(0xFF42A5F5).withValues(alpha: 0.15),
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
                          color:
                              const Color(0xFF1565C0).withValues(alpha: 0.12),
                        ),
                      ),
                    ),

                    // Main Content
                    Column(
                      children: [
                        // Top Bar (Back button + Title)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  if (state.currentStep > 0) {
                                    context
                                        .read<RegisterBloc>()
                                        .add(const RegisterPreviousStep());
                                  } else {
                                    Navigator.pop(context);
                                  }
                                },
                                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                    color: Colors.white),
                              ),
                              const Expanded(
                                child: Text(
                                  'إنشاء حساب',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 48), // Balance
                            ],
                          ),
                        ),

                        // Progress Indicator
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: SmoothPageIndicator(
                            controller: _pageController,
                            count: state.totalSteps,
                            effect: ExpandingDotsEffect(
                              dotHeight: 8,
                              dotWidth: 8,
                              activeDotColor: Colors.white,
                              dotColor: Colors.white.withValues(alpha: 0.3),
                              expansionFactor: 3,
                            ),
                          ),
                        ),

                        // Page View
                        Expanded(
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: const [
                              StepBasicInfo(),
                              StepSecurity(),
                              StepOtp(),
                              StepKyc(),
                            ],
                          ),
                        ),

                        // Bottom Actions
                        Container(
                          padding: EdgeInsets.fromLTRB(
                            24,
                            16,
                            24,
                            viewInsetsBottom > 0 ? 16 : 32,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.4),
                              ],
                            ),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: state.status == RegisterStatus.loading
                                  ? null
                                  : () {
                                      if (state.isLastStep) {
                                        context
                                            .read<RegisterBloc>()
                                            .add(const RegisterSubmitted());
                                      } else {
                                        context
                                            .read<RegisterBloc>()
                                            .add(const RegisterNextStep());
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF0F64FF),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                disabledBackgroundColor:
                                    Colors.white.withValues(alpha: 0.7),
                              ),
                              child: state.status == RegisterStatus.loading
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Color(0xFF0F64FF),
                                        ),
                                      ),
                                    )
                                  : Text(
                                      state.isLastStep
                                          ? 'إكمال التسجيل'
                                          : 'التالي',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
