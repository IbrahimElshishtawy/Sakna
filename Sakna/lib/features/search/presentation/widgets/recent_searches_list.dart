import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class RecentSearchesList extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    if (history.isEmpty) return const SizedBox.shrink();

    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);
    final isAr = t.isArabic;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              t.translate('recent_search'),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: themeColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
            TextButton(
              onPressed: onClearAll,
              child: Text(
                t.translate('clear_all'),
                style: TextStyle(
                  color: themeColors.accent,
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
              leading: Icon(Icons.history, color: themeColors.textSecondary, size: 20),
              title: Align(
                alignment: isAr ? Alignment.centerRight : Alignment.centerLeft,
                child: Text(
                  search,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: themeColors.textPrimary,
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
