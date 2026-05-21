import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class OnboardingProgressDots extends StatelessWidget {
  final int currentIndex;
  final int totalPages;

  const OnboardingProgressDots({
    super.key,
    required this.currentIndex,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) {
          final isActive = index == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            height: 8.0,
            width: isActive ? 24.0 : 8.0,
            decoration: BoxDecoration(
              color: isActive ? AppColors.accent : AppColors.greyLight,
              borderRadius: BorderRadius.circular(4.0),
            ),
          );
        },
      ),
    );
  }
}
