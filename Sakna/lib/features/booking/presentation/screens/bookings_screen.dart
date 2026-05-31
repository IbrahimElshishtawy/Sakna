import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';
import '../controllers/booking_controller.dart';
import '../widgets/booking_card_widget.dart';
import '../widgets/empty_bookings_widget.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final bookingState = ref.watch(bookingControllerProvider);
    final t = ref.watch(translationProvider);

    return Scaffold(
      backgroundColor: themeColors.background,
      body: SafeArea(
        child: _buildBody(context, ref, bookingState, themeColors, t),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    dynamic state,
    dynamic themeColors,
    dynamic t,
  ) {
    // 1. Loading State with Premium Shimmer / Smooth Fading Pulse
    if (state.isLoading) {
      return Center(
        child: FadeIn(
          duration: const Duration(milliseconds: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  color: themeColors.accent,
                  strokeWidth: 3.5,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                t.isArabic ? 'جاري تحميل الحجوزات...' : 'Loading bookings...',
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Cairo',
                  color: themeColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 2. Error Handling Screen (SOLID & Robust)
    if (state.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: Colors.red.withValues(alpha: 0.8),
              ),
              const SizedBox(height: 20),
              Text(
                t.isArabic ? 'عذراً، حدث خطأ ما' : 'Sorry, something went wrong',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: themeColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                state.errorMessage!,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: 'Cairo',
                  color: themeColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => ref
                    .read(bookingControllerProvider.notifier)
                    .fetchBookings(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  t.isArabic ? 'إعادة المحاولة' : 'Retry',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 3. Gorgeous Empty State Widget with Animating Micro-Interaction
    if (state.isEmpty) {
      return FadeInUp(
        duration: const Duration(milliseconds: 600),
        child: const EmptyBookingsWidget(),
      );
    }

    // 4. Extensible Booking List View (Success State)
    return FadeIn(
      duration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            // Responsive Top Header (RTL-aware)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeaderIcon(
                  context,
                  themeColors,
                  icon: Icons.person_outline_rounded,
                  onTap: () => context.push('/profile'),
                ),
                Text(
                  t.translate('bookings_welcome'),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: themeColors.textPrimary,
                  ),
                ),
                _buildHeaderIcon(
                  context,
                  themeColors,
                  icon: Icons.notifications_none_rounded,
                  onTap: () {},
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Interactive Pull-To-Refresh Booking List
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => ref
                    .read(bookingControllerProvider.notifier)
                    .fetchBookings(),
                color: themeColors.accent,
                backgroundColor: themeColors.surface,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  itemCount: state.bookings.length,
                  itemBuilder: (context, index) {
                    final booking = state.bookings[index];
                    return BookingCardWidget(
                      booking: booking,
                      onTap: () {
                        // Extensible detail screen handler
                      },
                    );
                  },
                ),
              ),
            ),
            
            // Bottom padding spacer to clear the floating bottom nav
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderIcon(
    BuildContext context,
    dynamic themeColors, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: themeColors.surface,
        border: Border.all(
          color: themeColors.border.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: themeColors.isDark ? 0.15 : 0.02,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Center(
            child: Icon(
              icon,
              color: themeColors.textPrimary,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
