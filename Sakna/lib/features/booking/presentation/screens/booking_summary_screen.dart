import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../../core/presentation/widgets/primary_button.dart';
import '../providers/booking_flow_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class BookingSummaryScreen extends ConsumerStatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  ConsumerState<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends ConsumerState<BookingSummaryScreen> {
  final _promoController = TextEditingController();
  bool _isPromoApplied = false;
  double _promoDiscount = 0.0;
  String? _promoError;

  @override
  void initState() {
    super.initState();
    final currentDetails = ref.read(bookingFlowProvider);
    if (currentDetails.promoCode != null) {
      _promoController.text = currentDetails.promoCode!;
      _isPromoApplied = true;
      _promoDiscount = 45.0; // 10% of 450 EGP
    }
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo(BookingFlowNotifier notifier, AppTranslator t) {
    final code = _promoController.text.trim().toUpperCase();
    if (code == 'SAKNA10' || code == 'DISCOUNT10' || code == 'KHIDMA10') {
      setState(() {
        _isPromoApplied = true;
        _promoDiscount = 45.0; // 10% of 450 EGP
        _promoError = null;
      });
      notifier.updatePromoCode(code);
    } else if (code.isEmpty) {
      setState(() {
        _isPromoApplied = false;
        _promoDiscount = 0.0;
        _promoError = null;
      });
      notifier.updatePromoCode(null);
    } else {
      setState(() {
        _isPromoApplied = false;
        _promoDiscount = 0.0;
        _promoError = t.isArabic ? 'كود الخصم غير صالح' : 'Invalid promo code';
      });
      notifier.updatePromoCode(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);
    final bookingDetails = ref.watch(bookingFlowProvider);
    final bookingFlowNotifier = ref.read(bookingFlowProvider.notifier);

    final isAr = t.isArabic;

    // Calculations
    const double baseCost = 450.0;
    const double serviceFees = 20.0;
    
    double loyaltyDiscount = 0.0;
    if (bookingDetails.useLoyaltyPoints) {
      loyaltyDiscount = 20.0;
    }

    final double totalDiscount = _promoDiscount + loyaltyDiscount;
    final double subtotal = (baseCost + serviceFees - totalDiscount).clamp(0.0, double.infinity);
    final double vat = subtotal * 0.14;
    final double finalTotal = subtotal + vat;

    // Format selected date & time slot
    String dateLabel = t.translate('booking_time');
    if (bookingDetails.date != null && bookingDetails.timeSlot != null) {
      final monthsAr = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      final monthsEn = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      final date = bookingDetails.date!;
      final month = isAr ? monthsAr[date.month - 1] : monthsEn[date.month - 1];
      
      final weekdaysAr = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
      final weekdaysEn = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      final weekday = isAr ? weekdaysAr[date.weekday - 1] : weekdaysEn[date.weekday - 1];

      // Convert time slot label to English if needed
      String timeDisplay = bookingDetails.timeSlot!;
      if (!isAr) {
        timeDisplay = timeDisplay
            .replaceAll('ص', 'AM')
            .replaceAll('م', 'PM');
      }

      dateLabel = '$weekday، ${date.day} $month - $timeDisplay';
    }

    // Selected address details
    String addressLabelText = t.translate('booking_address');
    if (bookingDetails.addressLabel != null && bookingDetails.addressDetails != null) {
      addressLabelText = '${bookingDetails.addressLabel}: ${bookingDetails.addressDetails}';
    }

    return Scaffold(
      backgroundColor: themeColors.background,
      appBar: AppBar(
        backgroundColor: themeColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          t.translate('booking_summary'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(isAr ? Icons.arrow_forward : Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Service Details Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: themeColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: themeColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top gold decorative line
                          Container(
                            height: 4,
                            width: 60,
                            decoration: BoxDecoration(
                              color: themeColors.accent,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            t.translate('service_details'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: themeColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Doctor Detail
                          _buildDetailRow(
                            Icons.local_hospital_outlined,
                            t.translate('doctor_visit'),
                            t.translate('doctor_name'),
                            themeColors,
                          ),
                          const Divider(height: 24, thickness: 0.5),

                          // Booking Date Time
                          _buildDetailRow(
                            Icons.calendar_month_outlined,
                            isAr ? 'موعد الزيارة' : 'Visit Time',
                            dateLabel,
                            themeColors,
                          ),
                          const Divider(height: 24, thickness: 0.5),

                          // Address
                          _buildDetailRow(
                            Icons.location_on_outlined,
                            isAr ? 'عنوان الزيارة' : 'Visit Address',
                            addressLabelText,
                            themeColors,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. Promo Code Input Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: themeColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: themeColors.border),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.local_offer_outlined, color: themeColors.textSecondary, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _promoController,
                              style: TextStyle(color: themeColors.textPrimary, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: t.translate('enter_promo_code'),
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                filled: false,
                                errorText: _promoError,
                                errorStyle: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isPromoApplied ? Colors.green : themeColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                            onPressed: () => _applyPromo(bookingFlowNotifier, t),
                            child: Text(
                              _isPromoApplied
                                  ? (isAr ? 'تم التطبيق' : 'Applied')
                                  : t.translate('apply'),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 3. Loyalty Points Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: themeColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: themeColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: themeColors.accent.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.star, color: themeColors.accent, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  t.translate('use_loyalty_points'),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: themeColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  t.translate('loyalty_points_desc'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: themeColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: bookingDetails.useLoyaltyPoints,
                            activeThumbColor: themeColors.accent,
                            activeTrackColor: themeColors.primary,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: themeColors.border,
                            onChanged: (val) {
                              bookingFlowNotifier.toggleLoyaltyPoints(val);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 4. Payment Summary Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: themeColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: themeColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.translate('payment_summary'),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: themeColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Service Cost
                          _buildCostRow(t.translate('service_cost'), baseCost, t, themeColors),
                          const SizedBox(height: 12),

                          // Service Fees
                          _buildCostRow(t.translate('service_fees'), serviceFees, t, themeColors),
                          
                          // Discounts if any
                          if (totalDiscount > 0) ...[
                            const SizedBox(height: 12),
                            _buildCostRow(
                              isAr ? 'الخصومات المطبقة' : 'Applied Discounts',
                              -totalDiscount,
                              t,
                              themeColors,
                              isDiscount: true,
                            ),
                          ],
                          const SizedBox(height: 12),

                          // VAT
                          _buildCostRow(t.translate('vat'), vat, t, themeColors),
                          const Divider(height: 24, thickness: 0.5),

                          // Final Total
                          _buildCostRow(
                            t.translate('final_total'),
                            finalTotal,
                            t,
                            themeColors,
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // 5. Choose Payment Method Bottom Action Bar
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: PrimaryButton(
                text: t.translate('choose_payment_method'),
                color: themeColors.primary,
                textColor: Colors.white,
                icon: Icons.payment_outlined,
                onPressed: () {
                  context.push('/payment-methods');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value, ThemeColors colors) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colors.accent, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textPrimary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCostRow(String title, double amount, AppTranslator t, ThemeColors colors,
      {bool isDiscount = false, bool isTotal = false}) {
    final currency = t.translate('egp');
    final formattedAmount = '${amount.abs().toStringAsFixed(0)} $currency';
    
    final textStyle = TextStyle(
      fontSize: isTotal ? 18 : 14,
      fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
      color: isTotal
          ? colors.textPrimary
          : (isDiscount ? Colors.green : colors.textSecondary),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: textStyle),
        Text(
          isDiscount ? '- $formattedAmount' : formattedAmount,
          style: textStyle.copyWith(fontFamily: 'Cairo'),
        ),
      ],
    );
  }
}
