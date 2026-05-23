import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'icon': Icons.history, 'label': 'السجلات'},
      {'icon': Icons.account_balance_wallet_outlined, 'label': 'المحفظة'},
      {'icon': Icons.home_work_outlined, 'label': 'الدعم'},
      {'icon': Icons.apps, 'label': 'المزيد'},
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(item['icon'], color: AppColors.primary, size: 26),
              ),
              const SizedBox(height: 8),
              Text(
                item['label'],
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
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
