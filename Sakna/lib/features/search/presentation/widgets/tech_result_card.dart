import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class TechResultCard extends ConsumerWidget {
  final Map<String, dynamic> tech;

  const TechResultCard({
    super.key,
    required this.tech,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);
    final isAr = t.isArabic;

    final primaryBrandColor = themeColors.isDark ? themeColors.accent : themeColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: themeColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: themeColors.border, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: themeColors.isDark ? 0.2 : 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Technician icon avatar details
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: tech['avatarColor'].withValues(alpha: 0.1),
                ),
                child: Center(
                  child: Icon(tech['icon'], color: tech['avatarColor'], size: 28),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                tech['price'],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryBrandColor,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          
          // Bio details & button
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      tech['name'],
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: themeColors.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: themeColors.border.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tech['category'],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: primaryBrandColor,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      isAr
                          ? '${tech['rating']} (${tech['reviews']} تقييم)'
                          : '${tech['rating']} (${tech['reviews']} reviews)',
                      style: TextStyle(
                        fontSize: 11,
                        color: themeColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  tech['bio'],
                  style: TextStyle(
                    fontSize: 12,
                    color: themeColors.textSecondary,
                    height: 1.4,
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
