import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khidma/config/theme/theme_provider.dart';
import 'package:khidma/config/theme/theme_state.dart';

class ReviewsSection extends ConsumerWidget {
  const ReviewsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'آراء العملاء',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: themeColors.textPrimary,
                  ),
            ),
            TextButton(
              onPressed: () {
                // View all reviews action
              },
              child: Text(
                'عرض الكل',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: themeColors.accent,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        _buildReviewCard(
          context,
          themeColors,
          userName: 'محمد عبدالله',
          dateText: 'قبل يومين',
          avatarLetter: 'م',
          rating: 5,
          comment: 'خدمة ممتازة واحترافية عالية. وصل في الموعد المحدد وقام بحل المشكلة في وقت قياسي وبسعر معقول. أنصح بالتعامل معه بشدة.',
        ),
        const SizedBox(height: 12),
        _buildReviewCard(
          context,
          themeColors,
          userName: 'سارة الفهد',
          dateText: 'قبل أسبوع',
          avatarLetter: 'س',
          rating: 4,
          comment: 'شغل نظيف جداً ومحترم. تم إصلاح تسريب الحمام بدون أي تكسير مزعج. شكراً جزيلاً لجهودكم.',
        ),
      ],
    );
  }

  Widget _buildReviewCard(
    BuildContext context,
    ThemeColors colors, {
    required String userName,
    required String dateText,
    required String avatarLetter,
    required int rating,
    required String comment,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: colors.background,
                child: Text(
                  avatarLetter,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 14,
                        color: colors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateText,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                            color: colors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star_rounded,
                    size: 15,
                    color: index < rating ? colors.accent : colors.border,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            comment,
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12.5,
                  height: 1.6,
                  color: colors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
