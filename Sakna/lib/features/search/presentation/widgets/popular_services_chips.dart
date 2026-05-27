import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class PopularServicesChips extends ConsumerWidget {
  final Function(String) onTapChip;

  const PopularServicesChips({
    super.key,
    required this.onTapChip,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.translate('popular_services'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: themeColors.textPrimary,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildPopularServiceChip(t.translate('ac_repair'), Icons.ac_unit, themeColors),
            _buildPopularServiceChip(t.translate('home_injection'), Icons.vaccines, themeColors),
            _buildPopularServiceChip(t.translate('plumber_shater'), Icons.water_drop, themeColors),
            _buildPopularServiceChip(t.translate('deep_clean_short'), Icons.cleaning_services, themeColors),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildPopularServiceChip(String label, IconData icon, dynamic themeColors) {
    final activeIconColor = themeColors.isDark ? themeColors.accent : themeColors.primary;

    return GestureDetector(
      onTap: () => onTapChip(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: themeColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: themeColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: themeColors.isDark ? 0.2 : 0.01),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: activeIconColor, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: themeColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
