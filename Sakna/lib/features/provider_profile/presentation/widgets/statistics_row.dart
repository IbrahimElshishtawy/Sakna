import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khidma/config/theme/theme_provider.dart';

class StatisticsRow extends ConsumerWidget {
  const StatisticsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);

    return Row(
      children: [
        _buildStatCard(
          context,
          themeColors,
          title: '4.9',
          subtitle: 'التقييم',
          icon: Icon(Icons.star_rounded, color: themeColors.accent, size: 20),
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          context,
          themeColors,
          title: '+150',
          subtitle: 'حجز مكتمل',
          icon: Icon(Icons.check_circle_outline_rounded, color: themeColors.primary, size: 18),
        ),
        const SizedBox(width: 12),
        _buildStatCard(
          context,
          themeColors,
          title: '8',
          subtitle: 'سنوات خبرة',
          icon: Icon(Icons.history_edu_rounded, color: themeColors.primary, size: 18),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    ThemeColors colors, {
    required String title,
    required String subtitle,
    required Widget icon,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colors.border,
            width: colors.isDark ? 1 : 0.8,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    color: colors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
