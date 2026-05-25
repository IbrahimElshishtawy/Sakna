import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';
import '../../presentation/providers/order_providers.dart';
import '../widgets/home_header.dart';
import '../widgets/order_tracking_card.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/quick_actions_row.dart';
import '../widgets/home_categories.dart';
import '../widgets/seasonal_banners.dart';
import '../widgets/elite_technicians.dart';
import '../widgets/emergency_banner.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeOrder = ref.watch(activeOrderProvider);
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

    return Scaffold(
      backgroundColor: themeColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Sticky Header Block (handles its own theme/lang)
            const HomeHeader(),

            // Main Content Area Scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 5.0,
                  right: 5.0,
                  top: 5.0,
                  bottom: 30.0,
                ), // bottom padded for floating navbar
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Conditional Order Tracking Card
                    const OrderTrackingCard(),
                    if (activeOrder != null) const SizedBox(height: 20),

                    // Persistent Search Bar
                    const HomeSearchBar(),
                    const SizedBox(height: 24),

                    // Quick navigation icons grid
                    const QuickActionsRow(),
                    const SizedBox(height: 28),

                    // Categories Block ("الخدمات الأساسية")
                    const HomeCategories(),
                    const SizedBox(height: 28),

                    // Seasonal Banners Block
                    const SeasonalBanners(),
                    const SizedBox(height: 28),

                    // Elite Technicians ("نخبة الفنيين")
                    const EliteTechnicians(),
                    const SizedBox(height: 28),

                    // Emergency floating block ("طلب طوارئ؟")
                    const EmergencyBanner(),
                    const SizedBox(height: 40),

                    // Developer reset button to show/hide order card easily
                    if (activeOrder == null)
                      Center(
                        child: TextButton.icon(
                          onPressed: () => ref
                              .read(activeOrderProvider.notifier)
                              .resetOrder(),
                          icon: Icon(Icons.refresh, color: themeColors.accent),
                          label: Text(
                            t.isArabic
                                ? 'إظهار بطاقة تتبع الطلب للتجربة'
                                : 'Show tracking card for demo',
                            style: TextStyle(
                              color: themeColors.isDark
                                  ? themeColors.accent
                                  : themeColors.primary,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
