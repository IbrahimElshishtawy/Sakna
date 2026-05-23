import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class RecentSearchesList extends StatelessWidget {
  final List<String> history;
  final VoidCallback onClearAll;
  final Function(String) onTapItem;

  const RecentSearchesList({
    super.key,
    required this.history,
    required this.onClearAll,
    required this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'البحث الأخير',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
            TextButton(
              onPressed: onClearAll,
              child: const Text(
                'مسح الكل',
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
        Column(
          children: history.map((search) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.history, color: AppColors.textSecondary, size: 20),
              title: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  search,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              onTap: () => onTapItem(search),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
