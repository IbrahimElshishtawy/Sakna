import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../../core/presentation/widgets/primary_button.dart';
import '../../../booking/presentation/providers/booking_flow_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class BookingSetupScreen extends ConsumerStatefulWidget {
  const BookingSetupScreen({super.key});

  @override
  ConsumerState<BookingSetupScreen> createState() => _BookingSetupScreenState();
}

class _BookingSetupScreenState extends ConsumerState<BookingSetupScreen> {
  late List<DateTime> _dates;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    // Generate dates: yesterday, today, and 5 future days
    _dates = List.generate(7, (index) => today.add(Duration(days: index - 1)));
  }

  String _getDateLabel(DateTime date, AppTranslator t) {
    final today = DateTime.now();
    final difference = date.difference(DateTime(today.year, today.month, today.day)).inDays;

    if (difference == -1) {
      return t.isArabic ? 'أمس' : 'Yesterday';
    } else if (difference == 0) {
      return t.isArabic ? 'اليوم' : 'Today';
    } else if (difference == 1) {
      return t.isArabic ? 'غداً' : 'Tomorrow';
    }

    final weekdaysAr = ['الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
    final weekdaysEn = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    return t.isArabic ? weekdaysAr[date.weekday - 1] : weekdaysEn[date.weekday - 1];
  }

  String _formatDayNum(DateTime date) {
    return date.day.toString();
  }

  String _getMonthLabel(DateTime date, AppTranslator t) {
    final monthsAr = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    final monthsEn = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return t.isArabic ? monthsAr[date.month - 1] : monthsEn[date.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);
    final bookingDetails = ref.watch(bookingFlowProvider);
    final bookingFlowNotifier = ref.read(bookingFlowProvider.notifier);

    // Initialize selected date to today if not set
    _selectedDate ??= bookingDetails.date ?? _dates[1];

    final isAr = t.isArabic;

    // Time slots configuration
    final morningSlots = [
      {'time': '09:00 ص', 'timeEn': '09:00 AM', 'status': 'available'},
      {'time': '10:00 ص', 'timeEn': '10:00 AM', 'status': 'available'},
      {'time': '11:00 ص', 'timeEn': '11:00 AM', 'status': 'limited'},
    ];

    final eveningSlots = [
      {'time': '12:00 م', 'timeEn': '12:00 PM', 'status': 'available'},
      {'time': '01:00 م', 'timeEn': '01:00 PM', 'status': 'disabled'},
      {'time': '03:00 م', 'timeEn': '03:00 PM', 'status': 'available'},
      {'time': '04:00 م', 'timeEn': '04:00 PM', 'status': 'limited'},
    ];

    return Scaffold(
      backgroundColor: themeColors.background,
      appBar: AppBar(
        backgroundColor: themeColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          t.translate('booking_setup'),
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
            // 1. Progress Step Indicator
            Container(
              color: themeColors.surface,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                children: [
                  _buildStep(1, t.translate('step_service'), true, false, themeColors),
                  _buildLine(true, themeColors),
                  _buildStep(2, t.translate('step_schedule'), false, true, themeColors),
                  _buildLine(false, themeColors),
                  _buildStep(3, t.translate('step_details'), false, false, themeColors),
                  _buildLine(false, themeColors),
                  _buildStep(4, t.translate('step_payment'), false, false, themeColors),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 2. Select Date Header
                    Text(
                      t.translate('select_date'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Horizontal Dates ListView
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _dates.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final date = _dates[index];
                          final isYesterday = index == 0;
                          final isSelected = !isYesterday &&
                              _selectedDate!.day == date.day &&
                              _selectedDate!.month == date.month;

                          return GestureDetector(
                            onTap: isYesterday
                                ? null
                                : () {
                                    setState(() {
                                      _selectedDate = date;
                                    });
                                    bookingFlowNotifier.updateDate(date);
                                  },
                            child: Container(
                              width: 80,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? themeColors.primary
                                    : (isYesterday ? themeColors.border.withValues(alpha: 0.3) : themeColors.surface),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? themeColors.accent : themeColors.border,
                                  width: isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _getDateLabel(date, t),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected
                                          ? themeColors.accent
                                          : (isYesterday ? themeColors.textSecondary.withValues(alpha: 0.5) : themeColors.textSecondary),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatDayNum(date),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : (isYesterday ? themeColors.textPrimary.withValues(alpha: 0.3) : themeColors.textPrimary),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _getMonthLabel(date, t),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: isSelected
                                          ? Colors.white70
                                          : (isYesterday ? themeColors.textSecondary.withValues(alpha: 0.5) : themeColors.textSecondary),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Select Time Header
                    Text(
                      t.translate('select_time'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: themeColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isAr ? 'توقيت الرياض (GMT +3)' : 'Riyadh Time (GMT +3)',
                      style: TextStyle(fontSize: 12, color: themeColors.textSecondary),
                    ),
                    const SizedBox(height: 16),

                    // Time Slots Categories
                    _buildTimeCategorySection(t.translate('morning'), morningSlots, bookingDetails, bookingFlowNotifier, themeColors, isAr),
                    const SizedBox(height: 20),
                    _buildTimeCategorySection(t.translate('evening'), eveningSlots, bookingDetails, bookingFlowNotifier, themeColors, isAr),
                    const SizedBox(height: 24),

                    // Time Legends
                    Row(
                      children: [
                        _buildLegendDot(Colors.grey, t.translate('available'), themeColors),
                        const SizedBox(width: 20),
                        _buildLegendDot(themeColors.accent, t.translate('limited'), themeColors),
                      ],
                    ),
                    const SizedBox(height: 28),

                    // 4. Repeat Booking Toggle Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: themeColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: themeColors.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.cached, color: themeColors.accent, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      t.translate('repeat_booking'),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: themeColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  t.translate('repeat_booking_desc'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: themeColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: bookingDetails.isRecurring,
                            activeThumbColor: themeColors.accent,
                            activeTrackColor: themeColors.primary,
                            inactiveThumbColor: Colors.grey,
                            inactiveTrackColor: themeColors.border,
                            onChanged: (val) {
                              bookingFlowNotifier.toggleRecurring(val);
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // 5. Bottom Action Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.translate('approximate_total'),
                          style: TextStyle(
                            fontSize: 11,
                            color: themeColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isAr ? '150 ر.س' : '150 SAR',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: themeColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      text: t.translate('continue_btn'),
                      color: themeColors.primary,
                      textColor: Colors.white,
                      icon: isAr ? Icons.arrow_back : Icons.arrow_forward,
                      iconFirst: false,
                      onPressed: bookingDetails.timeSlot == null
                          ? null
                          : () {
                              context.push('/add-order-details');
                            },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(int stepNum, String title, bool isDone, bool isActive, ThemeColors colors) {
    final circleColor = isDone
        ? colors.primary
        : (isActive ? colors.primary : colors.border);
    final borderColor = isDone
        ? colors.accent
        : (isActive ? colors.accent : colors.border);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: circleColor,
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : Text(
                    stepNum.toString(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isActive ? Colors.white : colors.textSecondary,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive || isDone ? FontWeight.bold : FontWeight.normal,
            color: isActive || isDone ? colors.textPrimary : colors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(bool isDone, ThemeColors colors) {
    return Expanded(
      child: Container(
        height: 2,
        color: isDone ? colors.primary : colors.border,
        margin: const EdgeInsets.only(bottom: 16),
      ),
    );
  }

  Widget _buildLegendDot(Color color, String text, ThemeColors colors) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: colors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildTimeCategorySection(
    String categoryTitle,
    List<Map<String, String>> slots,
    BookingDetails bookingDetails,
    BookingFlowNotifier notifier,
    ThemeColors colors,
    bool isAr,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryTitle,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.2,
          ),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final slot = slots[index];
            final displayTime = isAr ? slot['time']! : slot['timeEn']!;
            final status = slot['status']!;
            final isDisabled = status == 'disabled';
            
            // Check if selected
            final isSelected = bookingDetails.timeSlot == slot['time'];

            Color cardBg = colors.surface;
            Color textCol = colors.textPrimary;
            Color borderCol = colors.border;

            if (isSelected) {
              cardBg = colors.primary;
              textCol = Colors.white;
              borderCol = colors.accent;
            } else if (isDisabled) {
              cardBg = colors.border.withValues(alpha: 0.2);
              textCol = colors.textSecondary.withValues(alpha: 0.4);
              borderCol = colors.border.withValues(alpha: 0.1);
            }

            return GestureDetector(
              onTap: isDisabled
                  ? null
                  : () {
                      notifier.updateTimeSlot(isSelected ? null : slot['time']);
                    },
              child: Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderCol, width: isSelected ? 1.5 : 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isDisabled) ...[
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: status == 'limited' ? colors.accent : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      displayTime,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: textCol,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
