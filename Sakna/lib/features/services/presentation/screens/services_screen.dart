import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/app_colors.dart';
import '../providers/services_provider.dart';
import '../widgets/service_promo_card.dart';
import '../widgets/main_category_grid.dart';
import '../widgets/popular_services_accordion.dart';
import '../widgets/subscription_packages_slider.dart';
import '../widgets/residential_properties_slider.dart';
import 'service_category_details_screen.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state to check search or filter states
    final state = ref.watch(servicesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Gorgeous Header mimicking screenshot: ...الخدمات الشاملة / جميع الخدمات
            _buildCustomAppBar(context),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar: ابحث عن خدمة، فني، أو عقار...
                    _buildSearchBar(context, ref),
                    const SizedBox(height: 20),

                    // Glassmorphic Promotional Slider
                    const ServicePromoCard(),
                    const SizedBox(height: 24),

                    // Main Categories Title & Grid (4x2)
                    const Text(
                      'التصنيفات الرئيسية',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 12),
                    MainCategoryGrid(
                      onCategoryTap: (categoryId) {
                        ref.read(servicesProvider.notifier).selectCategory(categoryId);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ServiceCategoryDetailsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),

                    // Popular Services Expandable Accordion
                    PopularServicesAccordion(
                      onSubCategoryTap: (categoryId, subCategoryId) {
                        ref.read(servicesProvider.notifier).selectCategory(categoryId);
                        ref.read(servicesProvider.notifier).selectSubCategory(subCategoryId);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ServiceCategoryDetailsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),

                    // Subscription packages
                    SubscriptionPackagesSlider(
                      onTapPackage: () {
                        ref.read(servicesProvider.notifier).selectCategory('subscriptions');
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ServiceCategoryDetailsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 28),

                    // Residential Properties
                    ResidentialPropertiesSlider(
                      onTapPropertyCategory: (categoryId, subCategoryId) {
                        ref.read(servicesProvider.notifier).selectCategory(categoryId);
                        ref.read(servicesProvider.notifier).selectSubCategory(subCategoryId);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ServiceCategoryDetailsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: AppColors.primary, // Navy background matching dark header style
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.white, size: 24),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
              const Text(
                'جميع الخدمات',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.accent, size: 24),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, WidgetRef ref) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greyLight, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const TextField(
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: 'ابحث عن خدمة، فني، أو عقار...',
          hintStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontFamily: 'Cairo',
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        ),
      ),
    );
  }
}
