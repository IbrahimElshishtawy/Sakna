import 'package:flutter/material.dart';

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final dynamic themeColors;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;
  final bool showDivider;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.themeColors,
    required this.onTap,
    this.iconColor,
    this.textColor,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final activeGold = themeColors.isDark ? const Color(0xFFFFD700) : const Color(0xFFB8860B);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: themeColors.background,
            ),
            child: Icon(
              icon,
              color: iconColor ?? activeGold,
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor ?? themeColors.textPrimary,
              fontFamily: 'Cairo',
            ),
          ),
          trailing: trailing ?? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (subtitle != null) ...[
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 13,
                    color: themeColors.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Icon(
                isRtl ? Icons.arrow_back_ios_new_rounded : Icons.arrow_forward_ios_rounded,
                size: 14,
                color: themeColors.textSecondary.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            color: themeColors.border.withValues(alpha: 0.5),
            height: 1,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
