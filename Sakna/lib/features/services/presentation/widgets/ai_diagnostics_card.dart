import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/app_colors.dart';
import '../providers/services_provider.dart';

class AIDiagnosticsCard extends ConsumerWidget {
  const AIDiagnosticsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(servicesProvider);

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
}
