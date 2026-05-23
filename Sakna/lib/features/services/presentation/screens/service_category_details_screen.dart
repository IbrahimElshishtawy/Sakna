import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/service_category.dart';
import '../../data/datasources/mock_services_data.dart';
import '../providers/services_provider.dart';
import '../widgets/category_banner_header.dart';
import '../widgets/sub_category_tabs.dart';
import '../widgets/standard_service_card.dart';
import '../widgets/real_estate_service_card.dart';
import '../widgets/ai_diagnostics_card.dart';

class ServiceCategoryDetailsScreen extends ConsumerWidget {
  const ServiceCategoryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(servicesProvider);
    final selectedCategoryId = state.selectedCategoryId ?? 'maintenance';

    // Find the category from the mock database
    final category = MockServicesData.allCategories.firstWhere(
      (cat) => cat.id == selectedCategoryId,
      orElse: () => MockServicesData.allCategories.first,
    );

    // Get active subcategory
    final activeSubCategoryIndex = _getActiveSubCategoryIndex(category, state.selectedSubCategoryId);
    final activeSubCategory = category.subCategories.isNotEmpty
        ? category.subCategories[activeSubCategoryIndex]
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          category.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.accent),
            onPressed: () => _showCategoryInfoSheet(context, category),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category banner summary
            CategoryBannerHeader(category: category),

            // Horizontal subcategories tabs
            if (category.subCategories.length > 1)
              SubCategoryTabs(
                category: category,
                activeIndex: activeSubCategoryIndex,
              ),

            // Main Details Explorer Area
            Expanded(
              child: activeSubCategory != null
                  ? ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: activeSubCategory.items.length + (category.id == 'maintenance' ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Embed AI Diagnostics Widget for home appliance categories as requested
                        if (category.id == 'maintenance' && index == activeSubCategory.items.length) {
                          return const AIDiagnosticsCard();
                        }

                        final item = activeSubCategory.items[index];

                        if (category.id == 'real_estate') {
                          return RealEstateServiceCard(item: item);
                        }

                        return StandardServiceCard(item: item);
                      },
                    )
                  : const Center(
                      child: Text(
                        'لا توجد خدمات فرعية متوفرة حالياً.',
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  int _getActiveSubCategoryIndex(ServiceCategory category, String? selectedSubCategoryId) {
    if (selectedSubCategoryId == null) return 0;
    final index = category.subCategories.indexWhere((sub) => sub.id == selectedSubCategoryId);
    return index != -1 ? index : 0;
  }

  void _showCategoryInfoSheet(BuildContext context, ServiceCategory category) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'عن تصنيف ${category.title}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                category.description,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  fontFamily: 'Cairo',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.shield_outlined, color: AppColors.accent, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'جميع فنيي صيانة Sakna معتمدون ومؤهلون.',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'حسناً، فهمت',
                    style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
