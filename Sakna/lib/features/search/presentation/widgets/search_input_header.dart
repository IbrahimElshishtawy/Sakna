import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';
import 'filters_bottom_sheet.dart';

class SearchInputHeader extends ConsumerWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final String query;

  const SearchInputHeader({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
    required this.query,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);
    final isAr = t.isArabic;

    final isSearching = query.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: themeColors.surface,
      child: Row(
        children: [
          // Back button (dynamically direction-aware)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: themeColors.border),
            ),
            child: IconButton(
              icon: Icon(
                isAr ? Icons.arrow_forward : Icons.arrow_back,
                color: themeColors.textPrimary,
                size: 20,
              ),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  context.go('/home');
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          
          // Search input box
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: themeColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: themeColors.border, width: 0.5),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: themeColors.textSecondary, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      onChanged: onChanged,
                      textAlign: isAr ? TextAlign.right : TextAlign.left,
                      textDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: themeColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        hintText: t.translate('search_hint'),
                        hintTextDirection: isAr ? TextDirection.rtl : TextDirection.ltr,
                        hintStyle: TextStyle(
                          color: themeColors.textSecondary,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  
                  // Clear button (X) when typing, otherwise settings icon
                  if (isSearching)
                    IconButton(
                      icon: Icon(Icons.close, color: themeColors.textSecondary, size: 18),
                      onPressed: onClear,
                    )
                  else
                    IconButton(
                      icon: Icon(Icons.tune, color: themeColors.textSecondary, size: 18),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const FiltersBottomSheet(),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
