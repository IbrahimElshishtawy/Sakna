import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class MainShellScreen extends ConsumerWidget {
  final Widget child;

  const MainShellScreen({
    super.key,
    required this.child,
  });

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/bookings')) return 1;
    if (location.startsWith('/search')) return 2;
    if (location.startsWith('/services')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onTabTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/bookings');
        break;
      case 2:
        context.go('/search');
        break;
      case 3:
        context.go('/services');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = _getCurrentIndex(context);
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

    return Scaffold(
      backgroundColor: themeColors.background,
      body: Stack(
        children: [
          // 1. The Scrollable Page Content (extends to the very bottom, permitting scrolling under the floating navbar)
          Positioned.fill(
            child: child,
          ),

          // 2. The Truly Floating, Space-Hovering Bottom Navigation Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: themeColors.isDark ? 0.35 : 0.08),
                        blurRadius: 25,
                        spreadRadius: 1,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: themeColors.surface.withValues(alpha: themeColors.isDark ? 0.65 : 0.75),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: themeColors.border.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildNavItem(
                                context,
                                themeColors,
                                index: 0,
                                icon: Icons.home_filled,
                                inactiveIcon: Icons.home_outlined,
                                label: t.translate('home'),
                                isSelected: currentIndex == 0,
                              ),
                              _buildNavItem(
                                context,
                                themeColors,
                                index: 1,
                                icon: Icons.calendar_month,
                                inactiveIcon: Icons.calendar_month_outlined,
                                label: t.translate('bookings'),
                                isSelected: currentIndex == 1,
                              ),
                              _buildNavItem(
                                context,
                                themeColors,
                                index: 2,
                                icon: Icons.search,
                                inactiveIcon: Icons.search,
                                label: t.translate('search'),
                                isSelected: currentIndex == 2,
                              ),
                              _buildNavItem(
                                context,
                                themeColors,
                                index: 3,
                                icon: Icons.grid_view_rounded,
                                inactiveIcon: Icons.grid_view_outlined,
                                label: t.translate('services'),
                                isSelected: currentIndex == 3,
                              ),
                              _buildNavItem(
                                context,
                                themeColors,
                                index: 4,
                                icon: Icons.person,
                                inactiveIcon: Icons.person_outline,
                                label: t.translate('profile'),
                                isSelected: currentIndex == 4,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    dynamic themeColors, {
    required int index,
    required IconData icon,
    required IconData inactiveIcon,
    required String label,
    required bool isSelected,
  }) {
    final activeColor = themeColors.isDark ? themeColors.accent : themeColors.primary;
    final inactiveColor = themeColors.textSecondary;

    return Expanded(
      child: InkWell(
        onTap: () => _onTabTapped(context, index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Micro-animation / Premium scale on select
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: index == 4
                  ? Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected 
                            ? activeColor.withValues(alpha: 0.2) 
                            : inactiveColor.withValues(alpha: 0.1),
                        border: Border.all(
                          color: isSelected ? activeColor : inactiveColor,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.person,
                          size: 15,
                          color: isSelected ? activeColor : inactiveColor,
                        ),
                      ),
                    )
                  : Icon(
                      isSelected ? icon : inactiveIcon,
                      color: isSelected ? activeColor : inactiveColor,
                      size: 24,
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 4),
            // Custom active gold indicator line
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 18 : 0,
              height: 2.5,
              decoration: BoxDecoration(
                color: activeColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
