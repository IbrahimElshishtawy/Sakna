import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class MainCategoryGrid extends StatelessWidget {
  final Function(String categoryId) onCategoryTap;

  const MainCategoryGrid({
    super.key,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    // 8 items exactly matching the mockup screenshot
    final List<Map<String, dynamic>> gridItems = [
      {
        'id': 'maintenance',
        'title': 'صيانة منزلية',
        'icon': Icons.plumbing_outlined,
        'color': Colors.orange.shade50,
        'iconColor': Colors.orange.shade700,
      },
      {
        'id': 'medical',
        'title': 'خدمات طبية',
        'icon': Icons.medical_services_outlined,
        'color': Colors.red.shade50,
        'iconColor': Colors.red.shade700,
      },
      {
        'id': 'cleaning',
        'title': 'تنظيف',
        'icon': Icons.cleaning_services_outlined,
        'color': Colors.green.shade50,
        'iconColor': Colors.green.shade700,
      },
      {
        'id': 'moving',
        'title': 'نقل عفش',
        'icon': Icons.local_shipping_outlined,
        'color': Colors.blue.shade50,
        'iconColor': Colors.blue.shade700,
      },
      {
        'id': 'real_estate',
        'title': 'عقارات',
        'icon': Icons.real_estate_agent_outlined,
        'color': Colors.amber.shade50,
        'iconColor': Colors.amber.shade700,
      },
      {
        'id': 'smart_home',
        'title': 'سمارت هوم',
        'icon': Icons.settings_suggest_outlined,
        'color': Colors.teal.shade50,
        'iconColor': Colors.teal.shade700,
      },
      {
        'id': 'corporate',
        'title': 'خدمات للمكاتب',
        'icon': Icons.business_center_outlined,
        'color': Colors.cyan.shade50,
        'iconColor': Colors.cyan.shade700,
      },
      {
        'id': 'emergency',
        'title': 'طوارئ..',
        'icon': Icons.dangerous_outlined,
        'color': Colors.red.shade100,
        'iconColor': Colors.red.shade900,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: gridItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.25,
      ),
      itemBuilder: (context, index) {
        final item = gridItems[index];

        return InkWell(
          onTap: () => onCategoryTap(item['id']),
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.greyLight.withValues(alpha: 0.5),
                width: 1,
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Premium colored container for the icon
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item['color'],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    item['icon'],
                    color: item['iconColor'],
                    size: 26,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
