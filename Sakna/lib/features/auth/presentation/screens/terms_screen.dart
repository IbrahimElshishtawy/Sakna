import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../../core/presentation/widgets/primary_button.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class TermsScreen extends ConsumerWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

    return Scaffold(
      backgroundColor: themeColors.background,
      appBar: AppBar(
        backgroundColor: themeColors.primary,
        title: Text(
          t.translate('terms_title'),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, false),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon header
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: themeColors.accent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: themeColors.accent, width: 2),
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        color: themeColors.accent,
                        size: 48,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Header title
                  Text(
                    t.translate('terms_header'),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: themeColors.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Intro
                  Text(
                    t.translate('terms_intro'),
                    style: TextStyle(
                      fontSize: 14,
                      color: themeColors.textSecondary,
                      height: 1.6,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Divider(),
                  const SizedBox(height: 16),

                  // Section 1: Introduction
                  _buildSectionTitle(
                    t.isArabic ? '1. قبول الشروط والخدمة' : '1. Acceptance of Terms',
                    themeColors,
                  ),
                  _buildSectionBody(
                    t.isArabic
                        ? 'باستخدام منصة سكنى (Sakna)، فإنك توافق تماماً على الالتزام بكافة البنود والشروط الواردة في هذه الاتفاقية. نحن نقدم منصة متطورة لحجز خدمات الصيانة، الرعاية الصحية المنزلية، العقارات، والتشطيبات الفنية الفاخرة.'
                        : 'By using the Sakna platform, you fully agree to be bound by all the terms and conditions set forth in this agreement. We provide an advanced platform for booking maintenance, home healthcare, real estate, and premium finishing services.',
                    themeColors,
                  ),

                  // Section 2: Quality & Technicians
                  _buildSectionTitle(
                    t.isArabic ? '2. جودة الخدمات والكوادر المعتمدة' : '2. Service Quality & Staff Verification',
                    themeColors,
                  ),
                  _buildSectionBody(
                    t.isArabic
                        ? 'تلتزم سكنى بالتعاون حصرياً مع نخبة من المهندسين، الفنيين، والكوادر الطبية المعتمدة والمرخصة لضمان أعلى معايير الأمان والجودة العالية. يتم فحص الهوية والشهادات والخبرات بدقة لكل فني مسجل.'
                        : 'Sakna is committed to collaborating exclusively with a premium group of certified and licensed engineers, technicians, and medical staff to ensure the highest standards of safety and quality. Background, license, and experience checks are strictly performed for each registered provider.',
                    themeColors,
                  ),

                  // Section 3: Bookings & Cancellation
                  _buildSectionTitle(
                    t.isArabic ? '3. سياسة الحجز والإلغاء والضمان' : '3. Bookings, Cancellations & Guarantee',
                    themeColors,
                  ),
                  _buildSectionBody(
                    t.isArabic
                        ? 'يمكنك تأكيد أو جدولة الطلب من خلال التطبيق. تتوفر لدينا خدمات الحجز الفوري للحالات الطارئة. في حال الرغبة بإلغاء الحجز، يرجى القيام بذلك قبل الموعد بـ 12 ساعة لتفادي رسوم الإلغاء.'
                        : 'You can confirm or schedule bookings directly via the app. Instant booking services are available for emergency scenarios. To cancel a booking, please do so at least 12 hours prior to the scheduled time to avoid cancellation fees.',
                    themeColors,
                  ),

                  // Section 4: Privacy & Medical Confidentiality
                  _buildSectionTitle(
                    t.isArabic ? '4. سرية البيانات الطبية والبيانات الشخصية' : '4. Privacy & Healthcare Confidentiality',
                    themeColors,
                  ),
                  _buildSectionBody(
                    t.isArabic
                        ? 'جميع بياناتك الطبية والشخصية المتعلقة بخدمات الرعاية المنزلية مشفرة بالكامل ولا يتم مشاركتها إلا مع مقدم الخدمة الطبي المختص والمسؤول عن حالتك فقط لضمان الخصوصية المطلقة.'
                        : 'All your medical and personal data related to home healthcare services is fully encrypted and shared only with the designated medical service provider assigned to your case, ensuring absolute privacy.',
                    themeColors,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Docked Bottom Button Area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: themeColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: themeColors.isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
              border: Border(top: BorderSide(color: themeColors.border, width: 0.5)),
            ),
            child: SafeArea(
              child: PrimaryButton(
                text: t.translate('terms_read_agree'),
                icon: Icons.check,
                onPressed: () {
                  Navigator.pop(context, true); // Return true when user agrees
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, dynamic themeColors) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: themeColors.textPrimary,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  Widget _buildSectionBody(String text, dynamic themeColors) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        color: themeColors.textSecondary,
        height: 1.6,
        fontFamily: 'Cairo',
      ),
    );
  }
}
