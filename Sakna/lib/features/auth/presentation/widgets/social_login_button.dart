import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';

class SocialLoginButton extends ConsumerWidget {
  final String label;
  final IconData fallbackIcon;
  final VoidCallback onPressed;

  const SocialLoginButton({
    super.key,
    required this.label,
    required this.fallbackIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);

    return Expanded(
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(color: themeColors.border),
          backgroundColor: themeColors.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: themeColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              fallbackIcon,
              color: label.toLowerCase() == 'google'
                  ? Colors.redAccent
                  : (label.toLowerCase() == 'facebook' ? const Color(0xFF1877F2) : themeColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
