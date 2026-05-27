import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class SmartSuggestionsList extends ConsumerWidget {
  final Function(String) onTapItem;

  const SmartSuggestionsList({
    super.key,
    required this.onTapItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.translate('smart_suggestions'),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: themeColors.textPrimary,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 12),
        _buildSmartSuggestionCard(
          title: t.translate('specialized_nursing'),
          subtitle: t.translate('medical_dept_today'),
          icon: Icons.medical_services_outlined,
          color: Colors.red,
          themeColors: themeColors,
        ),
        const SizedBox(height: 12),
        _buildSmartSuggestionCard(
          title: t.translate('electrical_setup'),
          subtitle: t.translate('maintenance_dept'),
          icon: Icons.electric_bolt_outlined,
          color: Colors.blue,
          themeColors: themeColors,
        ),
        const SizedBox(height: 12),
        _buildSmartSuggestionCard(
          title: t.translate('landscaping'),
          subtitle: t.translate('facilities_care_dept'),
          icon: Icons.local_florist_outlined,
          color: Colors.green,
          themeColors: themeColors,
        ),
      ],
    );
  }

  Widget _buildSmartSuggestionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required dynamic themeColors,
  }) {
    return GestureDetector(
      onTap: () => onTapItem(title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: themeColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: themeColors.border, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: themeColors.isDark ? 0.2 : 0.015),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  // Icon circle leading
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: themeColors.textPrimary,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            color: themeColors.textSecondary,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_outward,
              color: themeColors.textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
