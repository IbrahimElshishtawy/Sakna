import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class PopularServicesChips extends StatelessWidget {
  final Function(String) onTapChip;

  const PopularServicesChips({
    super.key,
    required this.onTapChip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'خدمات شائعة',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildPopularServiceChip('تصليح تكييف', Icons.ac_unit),
            _buildPopularServiceChip('حقنة منزلية', Icons.vaccines),
            _buildPopularServiceChip('سباك شاطر', Icons.water_drop),
            _buildPopularServiceChip('تنظيف عميق', Icons.cleaning_services),
          ],
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildPopularServiceChip(String label, IconData icon) {
    return GestureDetector(
      onTap: () => onTapChip(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.greyLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.primary, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
