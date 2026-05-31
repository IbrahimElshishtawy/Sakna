import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class EmptyBookingsWidget extends ConsumerWidget {
  const EmptyBookingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            // 1. Premium Top Header (RTL-aware)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Rightmost icon in RTL (Profile)
                _buildHeaderIcon(
                  context,
                  themeColors,
                  icon: Icons.person_outline_rounded,
                  onTap: () => context.push('/profile'),
                ),
                // Centered App Name / Page Welcome
                Text(
                  t.translate('bookings_welcome'),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: themeColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
                // Leftmost icon in RTL (Notifications)
                _buildHeaderIcon(
                  context,
                  themeColors,
                  icon: Icons.notifications_none_rounded,
                  onTap: () {
                    // Navigate to notifications when route is defined
                  },
                ),
              ],
            ),
            
            // Spacer to mimic screen composition in mockup
            const SizedBox(height: 80),

            // 2. High-Fidelity Rounded Card Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28.0),
              decoration: BoxDecoration(
                color: themeColors.surface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: themeColors.border.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: themeColors.isDark ? 0.25 : 0.04,
                    ),
                    blurRadius: 24,
                    spreadRadius: 2,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  
                  // 3. Gorgeous Circular Calendar Illustration with Gradient
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: themeColors.isDark
                            ? [
                                const Color(0xFF0F2647).withValues(alpha: 0.8),
                                const Color(0xFF031024).withValues(alpha: 0.9),
                              ]
                            : [
                                const Color(0xFFFEF3C7),
                                const Color(0xFFFFFDF5),
                              ],
                        radius: 0.85,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: themeColors.isDark
                              ? Colors.black.withValues(alpha: 0.3)
                              : Colors.amber.withValues(alpha: 0.08),
                          blurRadius: 16,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: themeColors.surface.withValues(
                            alpha: themeColors.isDark ? 0.3 : 0.7,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.calendar_month_outlined,
                            size: 48,
                            color: themeColors.isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 36),

                  // 4. No Active Bookings Title
                  Text(
                    t.translate('no_active_bookings'),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: themeColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 14),

                  // 5. Friendly description
                  Text(
                    t.translate('no_bookings_desc'),
                    style: TextStyle(
                      fontSize: 14.5,
                      fontFamily: 'Cairo',
                      color: themeColors.textSecondary,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 36),

                  // 6. Premium dark navy button with micro-animation capability
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.go('/services'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            t.translate('explore_services'),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            
            // Bottom padding to clear floating nav bar space (approx 100px)
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(
    BuildContext context,
    dynamic themeColors, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: themeColors.surface,
        border: Border.all(
          color: themeColors.border.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: themeColors.isDark ? 0.15 : 0.02,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Center(
            child: Icon(
              icon,
              color: themeColors.textPrimary,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
