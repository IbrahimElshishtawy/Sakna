import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class SeasonalBanners extends ConsumerWidget {
  const SeasonalBanners({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            themeColors.primary,
            themeColors.isDark ? themeColors.surface : const Color(0xFF0C244C),
          ],
          begin: t.isArabic ? Alignment.centerRight : Alignment.centerLeft,
          end: t.isArabic ? Alignment.centerLeft : Alignment.centerRight,
        ),
      ),
      child: Stack(
        children: [
          // Background subtle design elements
          Positioned(
            left: t.isArabic ? -20 : null,
            right: t.isArabic ? null : -20,
            bottom: -20,
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          
          // Content block RTL/LTR compatible
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: themeColors.accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    t.isArabic ? 'عرض محدود' : 'Limited Offer',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: themeColors.primary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  t.isArabic ? 'خصم 20% على تعقيم المنازل' : '20% off on home sanitization',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  t.isArabic ? 'استخدم كود: STER20' : 'Use code: STER20',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
