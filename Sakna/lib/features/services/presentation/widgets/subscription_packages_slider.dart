import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class SubscriptionPackagesSlider extends StatelessWidget {
  final VoidCallback onTapPackage;

  const SubscriptionPackagesSlider({
    super.key,
    required this.onTapPackage,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> packages = [
      {
        'title': 'باقة الصيانة الذهبية',
        'subtitle': 'صيانة دورية متكاملة طوال العام',
        'price': '1000 ر.س',
        'period': '/ سنوي',
        'gradient': [const Color(0xFF031024), const Color(0xFF0F2C59)],
        'accent': AppColors.accent,
        'badge': 'الأكثر طلباً 🌟',
      },
      {
        'title': 'باقة التنظيف الأسبوعية',
        'subtitle': '4 زيارات تنظيف عميق شهرياً',
        'price': '450 ر.س',
        'period': '/ شهري',
        'gradient': [const Color(0xFF003B32), const Color(0xFF0A5C4F)],
        'accent': Colors.tealAccent,
        'badge': 'عرض خاص 🔥',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'باقات الاشتراكات المميزة',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final pkg = packages[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: pkg['gradient'],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: pkg['accent'].withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: pkg['accent'].withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              pkg['badge'],
                              style: TextStyle(
                                color: pkg['accent'],
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                          const Icon(Icons.stars_outlined, color: Colors.white70, size: 20),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pkg['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          Text(
                            pkg['subtitle'],
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 10.5,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: pkg['price'],
                                  style: TextStyle(
                                    color: pkg['accent'],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                TextSpan(
                                  text: pkg['period'],
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 11,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: onTapPackage,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'اشترك الآن',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            ),
          ),
        ),
      ],
    );
  }
}
