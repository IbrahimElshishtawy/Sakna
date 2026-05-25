import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../providers/order_providers.dart';

class OrderTrackingCard extends ConsumerWidget {
  const OrderTrackingCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(activeOrderProvider);
    if (order == null) return const SizedBox.shrink();

    final themeColors = ref.watch(themeColorsProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: themeColors.border, width: themeColors.isDark ? 1 : 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: themeColors.isDark ? 0.2 : 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Truck icon container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: themeColors.border.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.local_shipping,
                  color: themeColors.isDark ? themeColors.accent : themeColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              
              // Progress text and status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            order.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: themeColors.textPrimary,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Small gold status badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: themeColors.accent.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'جاري التوصيل',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: themeColors.isDark ? themeColors.accent : themeColors.primary,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'وقت الوصول المتوقع: ${order.arrivalTime}',
                      style: TextStyle(
                        fontSize: 12,
                        color: themeColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),

              // Dismiss / Cancel order tracking visual (conditionally hides)
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: themeColors.textSecondary,
                  size: 22,
                ),
                onPressed: () {
                  // Interactive dismiss order card action
                  ref.read(activeOrderProvider.notifier).dismissOrder();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'تم إنهاء تتبع الطلب الحالي بنجاح',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 18),
          
          // Shipping progress indicator line
          Row(
            children: [
              Icon(Icons.location_on, color: themeColors.accent, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: 0.6,
                    minHeight: 6,
                    backgroundColor: themeColors.border,
                    valueColor: AlwaysStoppedAnimation<Color>(themeColors.isDark ? themeColors.accent : themeColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.home_outlined, color: themeColors.textSecondary, size: 18),
            ],
          ),
        ],
      ),
    );
  }
}
