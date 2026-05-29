import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khidma/config/theme/theme_provider.dart';
import 'package:khidma/features/provider_profile/presentation/widgets/about_section.dart';
import 'package:khidma/features/provider_profile/presentation/widgets/bottom_action_nav.dart';
import 'package:khidma/features/provider_profile/presentation/widgets/portfolio_grid.dart';
import 'package:khidma/features/provider_profile/presentation/widgets/profile_app_bar.dart';
import 'package:khidma/features/provider_profile/presentation/widgets/profile_header_section.dart';
import 'package:khidma/features/provider_profile/presentation/widgets/reviews_section.dart';
import 'package:khidma/features/provider_profile/presentation/widgets/services_and_prices_section.dart';
import 'package:khidma/features/provider_profile/presentation/widgets/statistics_row.dart';

/// The parent Technician Profile Screen orchestrator, built following clean architecture.
/// Imports and renders modularized and specialized sub-widgets under presentation/widgets/.
class TechnicianProfileScreen extends ConsumerWidget {
  const TechnicianProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);

    return Scaffold(
      backgroundColor: themeColors.background,
      appBar: const ProfileAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ProfileHeaderSection(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24),
                          StatisticsRow(),
                          SizedBox(height: 24),
                          AboutSection(),
                          SizedBox(height: 24),
                          ServicesAndPricesSection(),
                          SizedBox(height: 24),
                          PortfolioGrid(),
                          SizedBox(height: 24),
                          ReviewsSection(),
                          SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const BottomActionNav(),
          ],
        ),
      ),
    );
  }
}
