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
                  gradient: LinearGradient(
                    colors: themeColors.isDark
                        ? [const Color(0xFF0A1E3F), const Color(0xFF051630)]
                        : [Colors.white, const Color(0xFFF9FAFB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: themeColors.isDark
                        ? themeColors.accent.withValues(alpha: 0.35)
                        : themeColors.border.withValues(alpha: 0.6),
                    width: themeColors.isDark ? 1.5 : 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: themeColors.isDark
                          ? themeColors.accent.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.03),
                      blurRadius: 12,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    item['icon'],
                    color: themeColors.isDark ? themeColors.accent : themeColors.primary,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['label'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
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
