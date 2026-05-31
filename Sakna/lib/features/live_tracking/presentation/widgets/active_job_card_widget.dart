import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';
import '../../domain/entities/job_tracking.dart';

class ActiveJobCardWidget extends ConsumerWidget {
  final JobTracking job;

  const ActiveJobCardWidget({
    super.key,
    required this.job,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

    // Format ticking elapsed seconds: HH:MM:SS
    final seconds = job.elapsedTimeInSeconds;
    final hoursStr = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutesStr = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secondsStr = (seconds % 60).toString().padLeft(2, '0');
    final formattedTime = '$hoursStr:$minutesStr:$secondsStr';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
      decoration: BoxDecoration(
        color: const Color(0xFF031024), // Luxury signature midnight navy
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF0D2547),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF031024).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Ticking Badge Status "جاري العمل"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.amber.withValues(alpha: 0.25),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.sync,
                  size: 14,
                  color: Color(0xFFFCD34D), // Soft gold
                ),
                const SizedBox(width: 6),
                Text(
                  t.translate('active_job'),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                    color: Color(0xFFFCD34D),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),

          // 2. Active Job Title
          Text(
            job.jobTitle,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // 3. Location info / Subtitle
          Text(
            '${t.isArabic ? 'وحدة رقم' : 'Unit No.'} ${job.unitNumber} - ${job.complexName}',
            style: const TextStyle(
              fontSize: 14.5,
              fontFamily: 'Cairo',
              color: Color(0xFF9CA3AF), // Muted grey
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 28),
          
          const Divider(
            color: Color(0xFF0D2547),
            thickness: 1.5,
          ),
          
          const SizedBox(height: 20),

          // 4. Elapsed Time Label
          Text(
            t.translate('elapsed_time'),
            style: const TextStyle(
              fontSize: 13,
              fontFamily: 'Cairo',
              color: Color(0xFF9CA3AF),
              letterSpacing: 0.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // 5. Large Golden ticking numbers
          Text(
            formattedTime,
            style: const TextStyle(
              fontSize: 44,
              fontWeight: FontWeight.w800,
              color: Color(0xFFFCD34D), // Golden timer text
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
