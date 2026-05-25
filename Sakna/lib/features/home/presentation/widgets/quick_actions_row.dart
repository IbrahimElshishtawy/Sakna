import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class QuickActionsRow extends ConsumerWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

    final List<Map<String, dynamic>> items = [
      {'icon': Icons.history, 'label': t.isArabic ? 'السجلات' : 'History'},
      {'icon': Icons.account_balance_wallet_outlined, 'label': t.isArabic ? 'المحفظة' : 'Wallet'},
      {'icon': Icons.home_work_outlined, 'label': t.isArabic ? 'الدعم' : 'Support'},
      {'icon': Icons.apps, 'label': t.isArabic ? 'المزيد' : 'More'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.map((item) {
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: themeColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: themeColors.border, width: themeColors.isDark ? 1 : 0.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: themeColors.isDark ? 0.15 : 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  item['icon'],
                  color: themeColors.isDark ? themeColors.accent : themeColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['label'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: themeColors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
