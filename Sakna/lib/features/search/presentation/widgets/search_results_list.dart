import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';
import 'tech_result_card.dart';
import 'service_result_card.dart';

class SearchResultsList extends StatelessWidget {
  final List<Map<String, dynamic>> results;

  const SearchResultsList({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            const Text(
              'لا توجد نتائج مطابقة لبحثك',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'تأكد من كتابة الكلمة بشكل صحيح أو جرب كلمات أخرى',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
