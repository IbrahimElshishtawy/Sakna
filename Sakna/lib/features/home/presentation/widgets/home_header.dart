import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      color: themeColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User profile avatar & Welcoming RTL layout compatible
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeColors.accent.withValues(alpha: 0.2),
                  border: Border.all(color: themeColors.accent, width: 1.5),
                ),
                child: Center(
                  child: Icon(
                    Icons.person,
                    color: themeColors.isDark ? themeColors.accent : themeColors.primary,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.translate('welcome_back'),
                    style: TextStyle(
                      fontSize: 12,
                      color: themeColors.textSecondary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  Text(
                    t.translate('user_name'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: themeColors.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          // Brand Centered
          Text(
            'SAKNA',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: themeColors.isDark ? themeColors.accent : themeColors.primary,
              letterSpacing: 1.5,
            ),
          ),

          // Dynamic Toggle Controls & Notifications
          Row(
            children: [
              // Language Switch
              GestureDetector(
                onTap: () {
                  ref.read(localeProvider.notifier).toggleLocale();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: themeColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: themeColors.accent, width: 1),
                  ),
                  child: Text(
                    t.isArabic ? 'EN' : 'عربي',
                    style: TextStyle(
                      color: themeColors.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // Theme Switch
              IconButton(
                icon: Icon(
                  themeColors.isDark ? Icons.wb_sunny : Icons.nightlight_round,
                  color: themeColors.accent,
                  size: 20,
                ),
                onPressed: () {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
              ),
              // Notifications
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: themeColors.border),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    color: themeColors.textPrimary,
                    size: 20,
                  ),
                  onPressed: () {
                    // Navigate to notifications screen
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
