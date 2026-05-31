import 'package:flutter/material.dart';

class ProfileCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String avatarUrl;
  final dynamic themeColors;
  final VoidCallback onNotificationTap;
  final VoidCallback onAvatarTap;

  const ProfileCustomAppBar({
    super.key,
    required this.title,
    required this.avatarUrl,
    required this.themeColors,
    required this.onNotificationTap,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeGold = themeColors.isDark ? const Color(0xFFFFD700) : const Color(0xFFB8860B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      height: preferredSize.height + MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
        color: themeColors.background,
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Side: Notification Bell button with badge
            InkWell(
              onTap: onNotificationTap,
              borderRadius: BorderRadius.circular(100),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeColors.surface,
                  border: Border.all(
                    color: themeColors.border,
                    width: 1,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_rounded,
                      color: themeColors.textPrimary,
                      size: 22,
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Center: Title
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: themeColors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
            ),

            // Right Side: Small User Avatar
            InkWell(
              onTap: onAvatarTap,
              borderRadius: BorderRadius.circular(100),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: activeGold.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: themeColors.surface,
                  backgroundImage: avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: avatarUrl.isEmpty
                      ? Text(
                          'أ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: activeGold,
                            fontFamily: 'Cairo',
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64.0);
}
