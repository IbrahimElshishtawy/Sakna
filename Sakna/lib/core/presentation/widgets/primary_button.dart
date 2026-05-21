import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutline;
  final Color? color;
  final Color? textColor;
  final Color? borderColor;
  final IconData? icon;
  final bool iconFirst;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isOutline = false,
    this.color,
    this.textColor,
    this.borderColor,
    this.icon,
    this.iconFirst = true,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = color ?? (isOutline ? Colors.transparent : AppColors.primary);
    final foregroundColor = textColor ?? (isOutline ? AppColors.textPrimary : Colors.white);
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isOutline ? BorderSide(color: borderColor ?? AppColors.greyLight) : BorderSide.none,
          ),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null && iconFirst) ...[
              Icon(icon, color: foregroundColor),
              const SizedBox(width: 12),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: foregroundColor,
                fontFamily: 'Cairo', // Assuming Cairo or similar for Arabic
              ),
            ),
            if (icon != null && !iconFirst) ...[
              const SizedBox(width: 12),
              Icon(icon, color: foregroundColor),
            ],
          ],
        ),
      ),
    );
  }
}
