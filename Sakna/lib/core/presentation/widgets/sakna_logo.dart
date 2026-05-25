import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class SaknaLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? color;

  const SaknaLogo({
    super.key,
    this.size = 60,
    this.showText = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = color ?? AppColors.accent;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(size * 0.25),
            border: Border.all(color: primaryColor, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Premium Gold House Silhouette
              Icon(
                Icons.home_outlined,
                color: primaryColor,
                size: size * 0.6,
              ),
              // Cozy brand curve inside
              Positioned(
                bottom: size * 0.2,
                child: Container(
                  width: size * 0.25,
                  height: size * 0.08,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              // Brand Gold Dot (represent luxury & precision)
              Positioned(
                top: size * 0.25,
                right: size * 0.35,
                child: CircleAvatar(
                  radius: size * 0.06,
                  backgroundColor: primaryColor,
                ),
              ),
            ],
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 8),
          Text(
            'سَكَنَى',
            style: TextStyle(
              color: primaryColor,
              fontSize: size * 0.3,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}
