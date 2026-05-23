import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/app_colors.dart';
import '../../domain/entities/service_category.dart';
import '../../domain/entities/service_sub_category.dart';
import '../../domain/entities/service_item.dart';
import '../../data/datasources/mock_services_data.dart';
import '../providers/services_provider.dart';

class ServiceCategoryDetailsScreen extends ConsumerWidget {
  const ServiceCategoryDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(servicesProvider);
    final selectedCategoryId = state.selectedCategoryId ?? 'maintenance';

    // Find the category from the mock database
    final category = MockServicesData.allCategories.firstWhere(
      (cat) => cat.id == selectedCategoryId,
      orElse: () => MockServicesData.allCategories.first,
    );

    // Get active subcategory
    final activeSubCategoryIndex = _getActiveSubCategoryIndex(category, state.selectedSubCategoryId);
    final activeSubCategory = category.subCategories.isNotEmpty
        ? category.subCategories[activeSubCategoryIndex]
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          category.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: AppColors.accent),
            onPressed: () => _showCategoryInfoSheet(context, category),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Category header summary
            _buildCategoryBanner(category),

            // Horizontal subcategories tabs
            if (category.subCategories.length > 1)
              _buildSubCategoryTabs(context, ref, category, activeSubCategoryIndex),

            // Main Details Explorer Area
            Expanded(
              child: activeSubCategory != null
                  ? _buildSubCategoryItemsList(context, ref, activeSubCategory, category)
                  : const Center(
                      child: Text(
                        'لا توجد خدمات فرعية متوفرة حالياً.',
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  int _getActiveSubCategoryIndex(ServiceCategory category, String? selectedSubCategoryId) {
    if (selectedSubCategoryId == null) return 0;
    final index = category.subCategories.indexWhere((sub) => sub.id == selectedSubCategoryId);
    return index != -1 ? index : 0;
  }

  Widget _buildCategoryBanner(ServiceCategory category) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: category.color,
              shape: BoxShape.circle,
            ),
            child: Icon(category.icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  category.description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontFamily: 'Cairo',
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubCategoryTabs(
    BuildContext context,
    WidgetRef ref,
    ServiceCategory category,
    int activeIndex,
  ) {
    return Container(
      height: 54,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.greyLight, width: 1),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: category.subCategories.length,
        itemBuilder: (context, index) {
          final sub = category.subCategories[index];
          final isActive = index == activeIndex;

          return InkWell(
            onTap: () {
              ref.read(servicesProvider.notifier).selectSubCategory(sub.id);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isActive ? AppColors.accent : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                sub.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSubCategoryItemsList(
    BuildContext context,
    WidgetRef ref,
    ServiceSubCategory subCategory,
    ServiceCategory mainCategory,
  ) {
    final state = ref.watch(servicesProvider);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: subCategory.items.length + (mainCategory.id == 'maintenance' ? 1 : 0),
      itemBuilder: (context, index) {
        // Embed AI Diagnostics Widget for home appliance categories as requested
        if (mainCategory.id == 'maintenance' && index == subCategory.items.length) {
          return _buildAIDiagnosticsCard(context, ref, state);
        }

        final item = subCategory.items[index];

        if (mainCategory.id == 'real_estate') {
          return _buildRealEstateCard(context, item);
        }

        return _buildStandardServiceCard(context, item);
      },
    );
  }

  Widget _buildStandardServiceCard(BuildContext context, ServiceItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isEmergency
              ? Colors.red.withValues(alpha: 0.3)
              : AppColors.greyLight.withValues(alpha: 0.6),
          width: item.isEmergency ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (item.icon != null)
                        Icon(item.icon, color: item.isEmergency ? Colors.red : AppColors.primary, size: 20)
                      else
                        Icon(Icons.check_circle_outline, color: item.isEmergency ? Colors.red : AppColors.accent, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                if (item.isEmergency)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'طوارئ فوري 🚨',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 9.5,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              item.description,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
                fontFamily: 'Cairo',
                height: 1.4,
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'التكلفة التقديرية',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          item.priceEstimate,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: item.isEmergency ? Colors.red : AppColors.primary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        if (item.duration != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            '(${item.duration})',
                            style: const TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => _simulateBookingFlow(context, item),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: item.isEmergency ? Colors.red : AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  ),
                  child: Text(
                    item.isEmergency ? 'إرسال فوري' : 'احجز الآن',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealEstateCard(BuildContext context, ServiceItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.greyLight, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Graphic header
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.type == 'rent' ? 'إيجار سكني 🔑' : 'تمليك مودرن ✨',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
                if (item.has360View == true)
                  Positioned(
                    left: 12,
                    top: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '360° View 🌐',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                const Center(
                  child: Icon(Icons.home_work_outlined, size: 40, color: AppColors.primary),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                    fontFamily: 'Cairo',
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildFeatureChip(Icons.door_sliding_outlined, '${item.rooms} غرف'),
                    const SizedBox(width: 8),
                    _buildFeatureChip(Icons.straighten_outlined, '${item.area} م²'),
                  ],
                ),
                const SizedBox(height: 12),
                if (item.facilities != null)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: item.facilities!.map((fac) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Text(
                          fac,
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: AppColors.textSecondary,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.priceEstimate,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showVirtualPropertyView(context, item),
                      icon: const Icon(Icons.remove_red_eye_outlined, size: 14),
                      label: const Text(
                        'عرض التفاصيل',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.primary, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIDiagnosticsCard(BuildContext context, WidgetRef ref, ServicesState state) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00183F), Color(0xFF033170)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.psychology_outlined, color: AppColors.accent, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'تشخيص الأعطال بالذكاء الاصطناعي 🧠',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'اختر جهازاً من أجهزتك المعطلة ودع خوارزمياتنا تقترح التشخيص المناسب للمشكلة فوراً!',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 10.5,
                fontFamily: 'Cairo',
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildDiagnosticsOption(context, ref, 'الغسالة 🧺'),
                const SizedBox(width: 8),
                _buildDiagnosticsOption(context, ref, 'الثلاجة ❄️'),
                const SizedBox(width: 8),
                _buildDiagnosticsOption(context, ref, 'التكييف 💨'),
              ],
            ),
            if (state.isDiagnosticsLoading) ...[
              const SizedBox(height: 16),
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: AppColors.accent),
                    SizedBox(height: 8),
                    Text(
                      'جاري الفحص السريع للأعطال المقترحة...',
                      style: TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'Cairo'),
                    ),
                  ],
                ),
              ),
            ],
            if (state.diagnosticsResult != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lightbulb, color: AppColors.accent, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'التشخيص المقترح من الكاشف الذكي:',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      state.diagnosticsResult!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontFamily: 'Cairo',
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosticsOption(BuildContext context, WidgetRef ref, String label) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          ref.read(servicesProvider.notifier).simulateDiagnostics(label);
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white30),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 11, fontFamily: 'Cairo'),
        ),
      ),
    );
  }

  void _simulateBookingFlow(BuildContext context, ServiceItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            item.isEmergency ? 'تأكيد إرسال الطوارئ 🚨' : 'تأكيد حجز الخدمة',
            style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.isEmergency ? Icons.warning_amber_rounded : Icons.calendar_month,
                color: item.isEmergency ? Colors.red : AppColors.primary,
                size: 40,
              ),
              const SizedBox(height: 12),
              Text(
                'لقد اخترت: ${item.name}',
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                item.isEmergency
                    ? 'سيتم إرسال فني الطوارئ فوراً إلى موقعك المسجل الآن وتتبع حركته مباشرة.'
                    : 'التكلفة التقديرية للخدمة هي ${item.priceEstimate} وسيتواصل معك فني الصيانة لتنسيق موعد دقيق.',
                style: const TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey, fontFamily: 'Cairo')),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      item.isEmergency
                          ? '🚨 جاري التوجيه الفوري للفني إليك الآن وتحديث بطاقة التتبع!'
                          : '✅ تم حجز الخدمة بنجاح وسيتصل بك الفني قريباً!',
                      style: const TextStyle(fontFamily: 'Cairo'),
                    ),
                    backgroundColor: item.isEmergency ? Colors.red : AppColors.primary,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: item.isEmergency ? Colors.red : AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'تأكيد الموعد',
                style: TextStyle(color: Colors.white, fontFamily: 'Cairo', fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showVirtualPropertyView(BuildContext context, ServiceItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 360 virtual animation placeholder
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.circle_notifications_outlined, color: AppColors.accent, size: 48),
                            const SizedBox(height: 8),
                            const Text(
                              'جولة افتراضية تفاعلية 360°',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            Text(
                              'حرك الهاتف لاستكشاف كامل زوايا العقار الافتراضي',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 10,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 12,
                        bottom: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.vrpano, color: AppColors.accent, size: 14),
                              SizedBox(width: 4),
                              Text(
                                'شغال الآن',
                                style: TextStyle(color: Colors.white, fontSize: 8.5, fontFamily: 'Cairo'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                          fontFamily: 'Cairo',
                          height: 1.4,
                        ),
                      ),
                      const Divider(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'السعر المطلوب',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              Text(
                                item.priceEstimate,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    '✅ تم تسجيل طلب معاينة العقار بنجاح وسيتواصل معك وكيلنا المرخص!',
                                    style: TextStyle(fontFamily: 'Cairo'),
                                  ),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            },
                            icon: const Icon(Icons.phone_in_talk, size: 14),
                            label: const Text(
                              'تواصل مع الوكيل',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCategoryInfoSheet(BuildContext context, ServiceCategory category) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'عن تصنيف ${category.title}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                category.description,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  fontFamily: 'Cairo',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Icon(Icons.shield_outlined, color: AppColors.accent, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'جميع فنيي صيانة Sakna معتمدون ومؤهلون علمياً.',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'حسناً، فهمت',
                    style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
