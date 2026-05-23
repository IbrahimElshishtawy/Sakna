import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class SmartSuggestionsList extends StatelessWidget {
  final Function(String) onTapItem;

  const SmartSuggestionsList({
    super.key,
    required this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اقتراحات ذكية',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 12),
        _buildSmartSuggestionCard(
          title: 'تمريض منزلي متخصص',
          subtitle: 'قسم الخدمات الطبية • متاح اليوم',
          icon: Icons.medical_services_outlined,
          color: Colors.red,
        ),
        const SizedBox(height: 12),
        _buildSmartSuggestionCard(
          title: 'تأسيس كهرباء وصيانة أعطال',
          subtitle: 'قسم الصيانة المنزلية',
          icon: Icons.electric_bolt_outlined,
          color: Colors.blue,
        ),
        const SizedBox(height: 12),
        _buildSmartSuggestionCard(
          title: 'تنسيق حدائق خارجية',
          subtitle: 'قسم العناية بالمرافق',
          icon: Icons.local_florist_outlined,
          color: Colors.green,
        ),
      ],
    );
  }

  Widget _buildSmartSuggestionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return GestureDetector(
      onTap: () => onTapItem(title),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.015),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Icon circle leading
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.arrow_outward,
              color: AppColors.textSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
