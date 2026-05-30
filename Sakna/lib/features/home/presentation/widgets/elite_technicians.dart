import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class EliteTechnicians extends ConsumerWidget {
  const EliteTechnicians({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

    final List<Map<String, dynamic>> technicians = [
      {
        'name': t.isArabic ? 'أحمد محمود' : 'Ahmed Mahmoud',
        'rating': '4.9',
        'reviews': t.isArabic ? '150 تقييم' : '150 reviews',
        'bio': t.isArabic ? 'خبير سباكة وصيانة عامة بخبرة 8 سنوات' : 'Plumbing and general maintenance expert with 8 years experience',
        'price': t.isArabic ? '150 ر.س' : '150 SAR',
        'avatar': 'assets/images/tech_avatar.png',
      },
      {
        'name': t.isArabic ? 'م. خالد عباس' : 'Eng. Khaled Abbas',
        'rating': '4.8',
        'reviews': t.isArabic ? '124 تقييم' : '124 reviews',
        'bio': t.isArabic ? 'خبير صيانة كهربائية منذ 10 سنوات' : 'Electrical maintenance expert for 10 years',
        'price': t.isArabic ? '50 ر.س' : '50 SAR',
        'avatar': null,
      }
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t.isArabic ? 'نخبة الفنيين' : 'Elite Technicians',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
            Icon(
              t.isArabic ? Icons.chevron_left : Icons.chevron_right,
              color: themeColors.textSecondary,
              size: 22,
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: technicians.length,
            padding: const EdgeInsets.only(right: 8.0, left: 8.0),
            itemBuilder: (context, index) {
              final tech = technicians[index];
              return GestureDetector(
                onTap: () => context.push('/technician-profile'),
                child: Container(
                  width: 280,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: themeColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: themeColors.border, width: themeColors.isDark ? 1 : 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: themeColors.isDark ? 0.15 : 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Technician avatar details
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: themeColors.border.withValues(alpha: 0.3),
                              image: tech['avatar'] != null
                                  ? DecorationImage(
                                      image: AssetImage(tech['avatar']),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: tech['avatar'] == null
                                ? Center(
                                    child: Icon(
                                      Icons.person,
                                      color: themeColors.isDark ? themeColors.accent : themeColors.primary,
                                      size: 36,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            tech['price'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: themeColors.isDark ? themeColors.accent : themeColors.primary,
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
                            Text(
                              tech['name'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: themeColors.textPrimary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  '${tech['rating']} (${tech['reviews']})',
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
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: themeColors.textSecondary,
                                height: 1.4,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: 110,
                              height: 34,
                              decoration: BoxDecoration(
                                color: themeColors.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  t.isArabic ? 'احجز الآن' : 'Book Now',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: themeColors.isDark ? themeColors.accent : Colors.white,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

