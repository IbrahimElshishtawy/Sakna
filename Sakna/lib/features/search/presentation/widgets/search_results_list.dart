import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';
import 'tech_result_card.dart';
import 'service_result_card.dart';

class SearchResultsList extends ConsumerWidget {
  final List<Map<String, dynamic>> results;

  const SearchResultsList({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_outlined,
              size: 64,
              color: themeColors.textSecondary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 16),
            Text(
              t.translate('no_results_title'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: themeColors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Text(
                t.translate('no_results_subtitle'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: themeColors.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: 110,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        if (item['type'] == 'tech') {
          return TechResultCard(tech: item);
        } else {
          return ServiceResultCard(service: item);
        }
      },
    );
  }
}
