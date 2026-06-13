import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../../core/presentation/widgets/primary_button.dart';
import '../../../booking/presentation/providers/booking_flow_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class SelectAddressScreen extends ConsumerStatefulWidget {
  const SelectAddressScreen({super.key});

  @override
  ConsumerState<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends ConsumerState<SelectAddressScreen> {
  final _searchController = TextEditingController();
  
  // Track selected address index (0 = Home, 1 = Work, 2 = Family Home)
  int _selectedAddressIndex = 0;

  final List<Map<String, String>> _addresses = [
    {
      'label': 'المنزل',
      'labelEn': 'Home',
      'icon': 'home',
      'details': 'الرياض، حي الملقا، شارع الأمير محمد بن سعد بن عبدالعزيز، فيلا 12',
      'detailsEn': 'Riyadh, Al-Malqa, Prince Mohammed bin Saad bin Abdulaziz St, Villa 12',
    },
    {
      'label': 'العمل',
      'labelEn': 'Work',
      'icon': 'work',
      'details': 'الرياض، مركز الملك عبدالله المالي، برج 4، الطابق 15',
      'detailsEn': 'Riyadh, KAFD, Tower 4, Floor 15',
    },
    {
      'label': 'منزل العائلة',
      'labelEn': 'Family Home',
      'icon': 'family',
      'details': 'الرياض، حي الياسمين، شارع التخصصي، فيلا 22',
      'detailsEn': 'Riyadh, Al-Yasmin, Takhassusi St, Villa 22',
    }
  ];

  @override
  void initState() {
    super.initState();
    final currentDetails = ref.read(bookingFlowProvider);
    if (currentDetails.addressLabel != null) {
      final index = _addresses.indexWhere((element) =>
          element['label'] == currentDetails.addressLabel ||
          element['labelEn'] == currentDetails.addressLabel);
      if (index != -1) {
        _selectedAddressIndex = index;
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);
    final bookingFlowNotifier = ref.read(bookingFlowProvider.notifier);

    final isAr = t.isArabic;

    return Scaffold(
      backgroundColor: themeColors.background,
      appBar: AppBar(
        backgroundColor: themeColors.primary,
        foregroundColor: Colors.white,
        title: Text(
          t.translate('select_address'),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        leading: IconButton(
          icon: Icon(isAr ? Icons.arrow_forward : Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: const [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=100&q=80'),
          ),
          SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Map container
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  // 1. Custom Mock Map View
                  _buildMockMap(themeColors, isAr),

                  // 2. Overlay Floating Search Bar
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: themeColors.textPrimary, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: t.translate('search_address_hint'),
                          prefixIcon: Icon(Icons.search, color: themeColors.textSecondary),
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),

                  // 3. Floating Map Locate Button
                  Positioned(
                    bottom: 16,
                    right: isAr ? null : 16,
                    left: isAr ? 16 : null,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: themeColors.surface,
                      foregroundColor: themeColors.accent,
                      shape: const CircleBorder(),
                      onPressed: () {},
                      child: const Icon(Icons.my_location),
                    ),
                  ),
                ],
              ),
            ),

            // 4. Address list and bottom actions sheet
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: themeColors.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handlebar indicator
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: themeColors.border,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        t.translate('saved_addresses_label'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Address List
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _addresses.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = _addresses[index];
                          final isSelected = _selectedAddressIndex == index;
                          
                          final label = isAr ? item['label']! : item['labelEn']!;
                          final details = isAr ? item['details']! : item['detailsEn']!;
                          
                          IconData addressIcon = Icons.home;
                          if (item['icon'] == 'work') {
                            addressIcon = Icons.business_center;
                          } else if (item['icon'] == 'family') {
                            addressIcon = Icons.people_outline;
                          }

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedAddressIndex = index;
                              });
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
                                  // Leading Selection Check
                                  Icon(
                                    isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                    color: isSelected ? themeColors.accent : themeColors.textSecondary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 16),

                                  // Address Details Text
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          label,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: themeColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          details,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: themeColors.textSecondary,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Icon Badge
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? themeColors.accent.withValues(alpha: 0.15)
                                          : themeColors.border.withValues(alpha: 0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      addressIcon,
                                      color: isSelected ? themeColors.accent : themeColors.textSecondary,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Confirm Button Action
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: PrimaryButton(
                        text: t.translate('confirm_current_location'),
                        color: themeColors.primary,
                        textColor: Colors.white,
                        onPressed: () {
                          final selected = _addresses[_selectedAddressIndex];
                          final label = isAr ? selected['label']! : selected['labelEn']!;
                          final details = isAr ? selected['details']! : selected['detailsEn']!;
                          bookingFlowNotifier.updateAddress(label, details);
                          context.push('/booking-summary');
                        },
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

  Widget _buildMockMap(ThemeColors colors, bool isAr) {
    // Premium map mock utilizing CustomPainter
    return Container(
      color: colors.isDark ? const Color(0xFF0F1E36) : const Color(0xFFE3EDF7),
      child: CustomPaint(
        painter: MapPainter(colors: colors),
        child: Stack(
          children: [
            // Center pin with label
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                      ],
                    ),
                    child: Text(
                      isAr ? 'شارع التحلية، الرياض' : 'Tahlia St, Riyadh',
                      style: TextStyle(
                        color: colors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.accent.withValues(alpha: 0.3),
                        ),
                      ),
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colors.accent,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24), // Offset for pin point
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MapPainter extends CustomPainter {
  final ThemeColors colors;
  MapPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = colors.isDark ? const Color(0xFF1B2F4E) : Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24
      ..strokeCap = StrokeCap.round;

    final dashPaint = Paint()
      ..color = colors.isDark ? Colors.white30 : Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Green areas
    final greenPaint = Paint()
      ..color = colors.isDark ? const Color(0xFF132D28) : const Color(0xFFE2F0D9)
      ..style = PaintingStyle.fill;

    // Draw some parks/background blocks
    canvas.drawRect(Rect.fromLTWH(20, 40, size.width * 0.4, size.height * 0.25), greenPaint);
    canvas.drawRect(Rect.fromLTWH(size.width * 0.55, size.height * 0.4, size.width * 0.35, size.height * 0.3), greenPaint);

    // Draw road 1 (horizontal)
    final path1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..lineTo(size.width, size.height * 0.4);
    canvas.drawPath(path1, roadPaint);

    // Draw road 2 (vertical curved)
    final path2 = Path()
      ..moveTo(size.width * 0.5, 0)
      ..quadraticBezierTo(size.width * 0.3, size.height * 0.5, size.width * 0.6, size.height);
    canvas.drawPath(path2, roadPaint);

    // Draw road dashed center lines
    _drawDashedPath(canvas, path1, dashPaint);
    _drawDashedPath(canvas, path2, dashPaint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    // Simple custom dash draw to prevent dependencies
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
