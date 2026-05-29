import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khidma/config/theme/theme_provider.dart';

class AboutSection extends ConsumerWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: themeColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: themeColors.border,
          width: themeColors.isDark ? 1 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 20,
                color: themeColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'نبذة عن الفني',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: themeColors.textPrimary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'متخصص في جميع أعمال السباكة المنزلية والتجارية بخبرة تتجاوز 8 سنوات. ألتزم بتقديم أعلى معايير الجودة والدقة في المواعيد. حاصل على شهادات معتمدة في الصيانة الحديثة واستخدام أحدث المعدات للكشف عن الأعطال بدون تكسير، مما يضمن راحة البال لعملائي.',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13.5,
                  height: 1.65,
                  color: themeColors.textSecondary,
                ),
          ),
        ],
      ),
    );
  }
}
