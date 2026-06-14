import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khidma/config/theme/theme_provider.dart';

class ServicesAndPricesSection extends ConsumerWidget {
  const ServicesAndPricesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الخدمات والأسعار',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: themeColors.textPrimary,
              ),
        ),
        const SizedBox(height: 12),
        _buildServiceItem(
          context,
          themeColors,
          title: 'إصلاح تسربات المياه',
          description: 'فحص وإصلاح التسربات بأجهزة حديثة',
          price: '150',
          unit: 'زيارة',
          icon: Icons.plumbing_rounded,
        ),
        const SizedBox(height: 12),
        _buildServiceItem(
          context,
          themeColors,
          title: 'تركيب أطقم حمامات',
          description: 'تركيب احترافي لجميع الماركات العالمية',
          price: '200',
          unit: 'طقم',
          icon: Icons.bathtub_rounded,
        ),
      ],
    );
  }

  Widget _buildServiceItem(
    BuildContext context,
    ThemeColors colors, {
    required String title,
    required String description,
    required String price,
    required String unit,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors.border,
          width: colors.isDark ? 1 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.background.withValues(alpha: colors.isDark ? 0.4 : 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.border.withValues(alpha: 0.5),
                width: 0.5,
              ),
            ),
            child: Icon(
              icon,
              color: colors.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: colors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: colors.textPrimary,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                'ر.س / $unit',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colors.textSecondary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
