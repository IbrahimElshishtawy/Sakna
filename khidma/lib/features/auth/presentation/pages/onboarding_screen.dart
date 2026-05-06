import 'package:flutter/material.dart';

import '../../../../core/app_routes.dart';
import '../widgets/onboarding_3d_view.dart';
import '../widgets/onboarding_page_data.dart';
import '../widgets/dot_indicator.dart';

/// Premium 3-page onboarding screen with 3D-like animations,
/// floating icons, and smooth page transitions.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _bottomBarController;
  late Animation<double> _bottomBarFade;
  late Animation<Offset> _bottomBarSlide;

  @override
  void initState() {
    super.initState();
    _bottomBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _bottomBarFade = CurvedAnimation(
      parent: _bottomBarController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
    );
    _bottomBarSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _bottomBarController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
    ));

    _bottomBarController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bottomBarController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() => _currentPage = page);
  }

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  void _nextPage() {
    if (_currentPage < onboardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _goToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == onboardingPages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // PageView with 3D views
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: onboardingPages.length,
            itemBuilder: (context, index) {
              return Onboarding3dView(
                pageData: onboardingPages[index],
                isActive: index == _currentPage,
              );
            },
          ),

          // Bottom bar with dot indicator, skip, and next
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FadeTransition(
              opacity: _bottomBarFade,
              child: SlideTransition(
                position: _bottomBarSlide,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    bottom: MediaQuery.of(context).padding.bottom + 24,
                    top: 20,
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Dot Indicator
                      DotIndicator(
                        currentPage: _currentPage,
                        totalPages: onboardingPages.length,
                      ),
                      const SizedBox(height: 32),

                      // Action Buttons Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Skip button
                          AnimatedOpacity(
                            opacity: isLastPage ? 0.0 : 1.0,
                            duration: const Duration(milliseconds: 300),
                            child: TextButton(
                              onPressed: isLastPage ? null : _goToLogin,
                              child: Text(
                                'تخطي',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),

                          // Next / Get Started button
                          _NextButton(
                            isLastPage: isLastPage,
                            onTap: _nextPage,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextButton extends StatefulWidget {
  final bool isLastPage;
  final VoidCallback onTap;

  const _NextButton({required this.isLastPage, required this.onTap});

  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          padding: EdgeInsets.symmetric(
            horizontal: widget.isLastPage ? 32 : 20,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.isLastPage ? 16 : 50),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.2),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: widget.isLastPage
                ? const Text(
                    'ابدأ الآن',
                    key: ValueKey('start'),
                    style: TextStyle(
                      color: Color(0xFF0D47A1),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : const Icon(
                    Icons.arrow_forward_rounded,
                    key: ValueKey('arrow'),
                    color: Color(0xFF0D47A1),
                    size: 24,
                  ),
          ),
        ),
      ),
    );
  }
}
