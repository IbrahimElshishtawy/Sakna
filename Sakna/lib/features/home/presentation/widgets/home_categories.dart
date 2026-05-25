import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class HomeCategories extends ConsumerWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

    // Categories ordered exactly like the screenshot: سباكة, كهرباء, تمريض, تنظيف
    final List<Map<String, dynamic>> categories = [
      {
        'icon': Icons.plumbing,
        'label': t.isArabic ? 'سباكة' : 'Plumbing',
        'lightColor': Colors.orange.shade50,
        'darkColor': Colors.orange.withValues(alpha: 0.2),
      },
      {
        'icon': Icons.electric_bolt,
        'label': t.isArabic ? 'كهرباء' : 'Electric',
        'lightColor': Colors.blue.shade50,
        'darkColor': Colors.blue.withValues(alpha: 0.2),
      },
      {
        'icon': Icons.medical_services_outlined,
        'label': t.isArabic ? 'تمريض' : 'Nursing',
        'lightColor': Colors.red.shade50,
        'darkColor': Colors.red.withValues(alpha: 0.2),
      },
      {
        'icon': Icons.cleaning_services_outlined,
        'label': t.isArabic ? 'تنظيف' : 'Cleaning',
        'lightColor': Colors.green.shade50,
        'darkColor': Colors.green.withValues(alpha: 0.2),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t.isArabic ? 'الخدمات الأساسية' : 'Core Services',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                t.isArabic ? 'عرض الكل' : 'View All',
                style: TextStyle(
                  color: themeColors.accent,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: categories.map((cat) {
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6.0),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  color: themeColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: themeColors.border, width: themeColors.isDark ? 1 : 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: themeColors.isDark ? 0.15 : 0.01),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: themeColors.isDark ? cat['darkColor'] : cat['lightColor'],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        cat['icon'],
                        color: themeColors.isDark ? themeColors.accent : themeColors.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cat['label'],
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
          }).toList(),
        ),
      ],
    );
  }
}
