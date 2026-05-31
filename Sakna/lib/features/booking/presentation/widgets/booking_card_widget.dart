import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';
import '../../domain/entities/booking.dart';

class BookingCardWidget extends ConsumerWidget {
  final Booking booking;
  final VoidCallback? onTap;

  const BookingCardWidget({
    super.key,
    required this.booking,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);
    final isArabic = t.isArabic;

    // Direct and robust manual date formatting (Zero external dependency)
    final year = booking.dateTime.year;
    final month = booking.dateTime.month.toString().padLeft(2, '0');
    final day = booking.dateTime.day.toString().padLeft(2, '0');
    final rawHour = booking.dateTime.hour;
    final displayHour = rawHour == 0 
        ? 12 
        : (rawHour > 12 ? rawHour - 12 : rawHour);
    final minute = booking.dateTime.minute.toString().padLeft(2, '0');
    final amPm = rawHour >= 12 
        ? (isArabic ? 'م' : 'PM') 
        : (isArabic ? 'ص' : 'AM');
    
    final formattedDate = '$year-$month-$day • $displayHour:$minute $amPm';

    // Status translation & coloring
    Color statusColor;
    String statusText;

    switch (booking.status) {
      case BookingStatus.active:
        statusColor = Colors.orange;
        statusText = isArabic ? 'نشط' : 'Active';
        break;
      case BookingStatus.completed:
        statusColor = Colors.green;
        statusText = isArabic ? 'مكتمل' : 'Completed';
        break;
      case BookingStatus.cancelled:
        statusColor = Colors.red;
        statusText = isArabic ? 'ملغي' : 'Cancelled';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: themeColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: themeColors.border.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: themeColors.isDark ? 0.25 : 0.03,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  // Circular status icon
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor.withValues(alpha: 0.1),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.build_circle_outlined,
                        color: statusColor,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // Text details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.serviceName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            color: themeColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          booking.providerName,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontFamily: 'Cairo',
                            color: themeColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Cairo',
                            color: themeColors.textSecondary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Price and status badge
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${booking.price.toStringAsFixed(0)} ${t.translate('egp')}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          color: themeColors.accent,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
