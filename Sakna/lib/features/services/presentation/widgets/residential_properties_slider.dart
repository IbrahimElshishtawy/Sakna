import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class ResidentialPropertiesSlider extends StatelessWidget {
  final Function(String categoryId, String subCategoryId) onTapPropertyCategory;

  const ResidentialPropertiesSlider({
    super.key,
    required this.onTapPropertyCategory,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> properties = [
      {
        'title': 'شقة فاخرة بحي النرجس',
        'price': '4,000 ر.س / شهري',
        'rooms': '3 غرف',
        'area': '130 م²',
        'badge': '360° View 🌐',
        'tag': 'إيجار سكني',
        'imageColor': Colors.blueGrey.shade100,
        'facilities': 'تكييف مركزي • موقف خاص',
      },
      {
        'title': 'شقة تمليك بحي الصحافة',
        'price': '850,000 ر.س',
        'rooms': '4 غرف',
        'area': '165 م²',
        'badge': 'تمليك مودرن ✨',
        'tag': 'بيع سكنى',
        'imageColor': Colors.orange.shade100,
        'facilities': 'ضمانات 10 سنوات • دخول ذكي',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'العقارات السكنية المميزة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
            TextButton(
              onPressed: () => onTapPropertyCategory('real_estate', 'rent'),
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
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final prop = properties[index];
              return Container(
                width: 250,
                margin: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.greyLight.withValues(alpha: 0.8),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mock Image Area
                    Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: prop['imageColor'],
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                prop['tag'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                prop['badge'],
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          ),
                          const Center(
                            child: Icon(Icons.home_outlined, size: 36, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),

                    // Content Area
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prop['title'],
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              fontFamily: 'Cairo',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${prop['rooms']} • ${prop['area']}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                prop['price'],
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 10,
                                color: AppColors.accent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
