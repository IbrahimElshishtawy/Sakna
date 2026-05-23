import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    // Categories ordered exactly like the screenshot: سباكة, كهرباء, تمريض, تنظيف
    final List<Map<String, dynamic>> categories = [
      {'icon': Icons.plumbing, 'label': 'سباكة', 'color': Colors.orange.shade50},
      {'icon': Icons.electric_bolt, 'label': 'كهرباء', 'color': Colors.blue.shade50},
      {'icon': Icons.medical_services_outlined, 'label': 'تمريض', 'color': Colors.red.shade50},
      {'icon': Icons.cleaning_services_outlined, 'label': 'تنظيف', 'color': Colors.green.shade50},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'الخدمات الأساسية',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'عرض الكل',
                style: TextStyle(
                  color: AppColors.accent,
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.01),
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
                        color: cat['color'],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(cat['icon'], color: AppColors.primary, size: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      cat['label'],
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
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
