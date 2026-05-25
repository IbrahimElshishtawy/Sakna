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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: themeColors.surface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Brand Logo & Brand Name (Start Side)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: themeColors.accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: themeColors.accent, width: 1.5),
                ),
                child: Center(
                  child: Icon(
                    Icons.home_work_rounded,
                    color: themeColors.accent,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'SAKNA',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: themeColors.isDark ? themeColors.accent : themeColors.primary,
                  fontFamily: 'Cairo',
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),

          // Dynamic Toggle Controls & Notifications
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Language Switch
              GestureDetector(
                onTap: () {
                  ref.read(localeProvider.notifier).toggleLocale();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: themeColors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: themeColors.accent, width: 1),
                  ),
                  child: Text(
                    t.isArabic ? 'EN' : 'عربي',
                    style: TextStyle(
                      color: themeColors.accent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // Theme Switch
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  themeColors.isDark ? Icons.wb_sunny : Icons.nightlight_round,
                  color: themeColors.accent,
                  size: 18,
                ),
                onPressed: () {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
              ),
              const SizedBox(width: 4),
              // Notifications
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: themeColors.border),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.notifications_none_outlined,
                    color: themeColors.textPrimary,
                    size: 18,
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
