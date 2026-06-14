import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../../core/presentation/widgets/primary_button.dart';
import '../../../booking/presentation/providers/booking_flow_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  ConsumerState<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  String _selectedMethodId = 'card';

  final List<Map<String, String>> _methods = [
    {
      'id': 'card',
      'title': 'بطاقة ائتمان تنتهي بـ 4242',
      'titleEn': 'Credit card ending in 4242',
      'subtitle': 'تاريخ الانتهاء: 12/25',
      'subtitleEn': 'Expiry date: 12/25',
      'icon': 'visa',
    },
    {
      'id': 'apple_pay',
      'title': 'Apple Pay',
      'titleEn': 'Apple Pay',
      'subtitle': 'دفع سريع وآمن',
      'subtitleEn': 'Fast and secure payment',
      'icon': 'apple',
    },
    {
      'id': 'instapay',
      'title': 'Instapay',
      'titleEn': 'Instapay',
      'subtitle': 'تحويل بنكي فوري',
      'subtitleEn': 'Instant bank transfer',
      'icon': 'instapay',
    },
    {
      'id': 'vodafone',
      'title': 'فودافون كاش',
      'titleEn': 'Vodafone Cash',
      'subtitle': 'الدفع عبر المحفظة الإلكترونية',
      'subtitleEn': 'Pay via mobile wallet',
      'icon': 'vodafone',
    },
    {
      'id': 'cash',
      'title': 'الدفع نقداً',
      'titleEn': 'Cash on Delivery',
      'subtitle': 'الدفع عند استلام الخدمة',
      'subtitleEn': 'Pay on service delivery',
      'icon': 'cash',
    },
  ];

  @override
  void initState() {
    super.initState();
    final currentDetails = ref.read(bookingFlowProvider);
    if (currentDetails.paymentMethodId != null) {
      _selectedMethodId = currentDetails.paymentMethodId!;
    }
  }

  void _showSuccessDialog(BuildContext context, ThemeColors colors, AppTranslator t) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            backgroundColor: colors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: colors.border),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16),
                // Success Check Circle Animation
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  t.isArabic ? 'تم الحجز بنجاح!' : 'Booking Successful!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  t.isArabic
                      ? 'تم تأكيد موعدك بنجاح مع مقدم الخدمة. يمكنك متابعة حالة الطلب من شاشة الحجوزات.'
                      : 'Your appointment has been confirmed. You can track status from the bookings screen.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textSecondary,
                    height: 1.5,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  text: t.isArabic ? 'الذهاب للحجوزات' : 'Go to Bookings',
                  color: colors.primary,
                  textColor: Colors.white,
                  onPressed: () {
                    // Reset State and Go to Bookings
                    ref.read(bookingFlowProvider.notifier).reset();
                    context.go('/bookings');
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    ref.read(bookingFlowProvider.notifier).reset();
                    context.go('/home');
                  },
                  child: Text(
                    t.isArabic ? 'الرئيسية' : 'Home',
                    style: TextStyle(
                      color: colors.accent,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
    
    double promoDiscount = 0.0;
    if (bookingDetails.promoCode != null) {
      promoDiscount = 45.0; // 10%
    }
    double loyaltyDiscount = 0.0;
    if (bookingDetails.useLoyaltyPoints) {
      loyaltyDiscount = 20.0;
    }

    final double totalDiscount = promoDiscount + loyaltyDiscount;
    final double subtotal = (baseCost + serviceFees - totalDiscount).clamp(0.0, double.infinity);
    final double vat = subtotal * 0.14;
    final double finalTotal = subtotal + vat;

    final currency = t.translate('egp');

    return Scaffold(
      backgroundColor: themeColors.background,
      appBar: AppBar(
        backgroundColor: themeColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          t.translate('payment_methods_title'),
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
                    // 1. Total Cost Banner Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: themeColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: themeColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.translate('total_amount'),
                                style: TextStyle(fontSize: 12, color: themeColors.textSecondary),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${finalTotal.toStringAsFixed(2)} $currency',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: themeColors.textPrimary,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.lock_outline, color: themeColors.accent, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    t.translate('secure_payments_note'),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: themeColors.accent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Choose title
                    Text(
                      isAr ? 'اختر طريقة الدفع' : 'Choose Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: themeColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 2. Payment Methods List
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _methods.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final method = _methods[index];
                        final isSelected = _selectedMethodId == method['id'];

                        final title = isAr ? method['title']! : method['titleEn']!;
                        final subtitle = isAr ? method['subtitle']! : method['subtitleEn']!;
                        final iconName = method['icon']!;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMethodId = method['id']!;
                            });
                            bookingFlowNotifier.updatePaymentMethod(method['id']!);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? themeColors.surface : themeColors.background,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? themeColors.primary : themeColors.border,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Selection Radio
                                Icon(
                                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                  color: isSelected ? themeColors.accent : themeColors.textSecondary,
                                  size: 20,
                                ),
                                const SizedBox(width: 16),

                                // Title and Subtitle details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: themeColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        subtitle,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: themeColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),

                                // Visual Icon Brand Badge
                                _buildMethodLogo(iconName, themeColors),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),

                    // 3. Add Card Item
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: themeColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: themeColors.border, style: BorderStyle.values[1]),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: themeColors.accent, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              t.translate('add_new_card'),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: themeColors.accent,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // 4. Secure badge & bottom pay button
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.lock_outline, color: themeColors.textSecondary, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        t.translate('secure_gateway_note'),
                        style: TextStyle(
                          fontSize: 11,
                          color: themeColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  PrimaryButton(
                    text: '${t.translate('confirm_payment')}   |   ${finalTotal.toStringAsFixed(0)} $currency',
                    color: themeColors.primary,
                    textColor: Colors.white,
                    onPressed: () {
                      bookingFlowNotifier.updatePaymentMethod(_selectedMethodId);
                      _showSuccessDialog(context, themeColors, t);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMethodLogo(String logoName, ThemeColors colors) {
    if (logoName == 'visa') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black12, width: 0.5),
        ),
        child: const Text(
          'VISA',
          style: TextStyle(
            color: Color(0xFF1A1F71),
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            fontSize: 12,
          ),
        ),
      );
    } else if (logoName == 'apple') {
      return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.apple, color: Colors.white, size: 20),
      );
    } else if (logoName == 'instapay') {
      return Container(
        width: 32,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black12, width: 0.5),
        ),
        child: const Center(
          child: Text(
            'IP',
            style: TextStyle(
              color: Colors.pink,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      );
    } else if (logoName == 'vodafone') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE60000),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'V',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    } else {
      return Icon(Icons.money, color: colors.accent, size: 24);
    }
  }
}
