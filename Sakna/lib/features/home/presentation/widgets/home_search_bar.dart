import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';
import '../../../search/presentation/widgets/filters_bottom_sheet.dart';

class HomeSearchBar extends ConsumerWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

    return GestureDetector(
      onTap: () => context.go('/search'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: themeColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: themeColors.border, width: themeColors.isDark ? 1 : 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: themeColors.isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Settings filter button (clicking opens FiltersBottomSheet)
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const FiltersBottomSheet(),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: themeColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.tune,
                  color: themeColors.isDark ? themeColors.accent : Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                t.translate('search_hint'),
                textAlign: t.isArabic ? TextAlign.right : TextAlign.left,
                style: TextStyle(
                  fontSize: 14,
                  color: themeColors.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            Icon(
              Icons.search,
              color: themeColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
