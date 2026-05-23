import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/service_category.dart';
import '../providers/services_provider.dart';

class SubCategoryTabs extends ConsumerWidget {
  final ServiceCategory category;
  final int activeIndex;

  const SubCategoryTabs({
    super.key,
    required this.category,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 54,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.greyLight, width: 1),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: category.subCategories.length,
        itemBuilder: (context, index) {
          final sub = category.subCategories[index];
          final isActive = index == activeIndex;

          return InkWell(
            onTap: () {
              ref.read(servicesProvider.notifier).selectSubCategory(sub.id);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? AppColors.accent : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                sub.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
