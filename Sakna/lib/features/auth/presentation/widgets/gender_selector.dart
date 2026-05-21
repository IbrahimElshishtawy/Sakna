import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

enum Gender { male, female }

class GenderSelector extends StatefulWidget {
  final Gender? initialGender;
  final ValueChanged<Gender> onChanged;

  const GenderSelector({
    super.key,
    this.initialGender,
    required this.onChanged,
  });

  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  Gender? _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.initialGender;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.greyLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _buildOption(
            title: 'ذكر',
            icon: Icons.man,
            gender: Gender.male,
          ),
          _buildOption(
            title: 'أنثى',
            icon: Icons.woman,
            gender: Gender.female,
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String title,
    required IconData icon,
    required Gender gender,
  }) {
    final isSelected = _selectedGender == gender;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = gender;
          });
          widget.onChanged(gender);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
