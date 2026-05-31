import 'package:flutter/material.dart';

class ProfileAvatarSection extends StatelessWidget {
  final String name;
  final String avatarUrl;
  final String userType;
  final String memberTier;
  final dynamic themeColors;
  final VoidCallback? onAvatarEditTap;

  const ProfileAvatarSection({
    super.key,
    required this.name,
    required this.avatarUrl,
    required this.userType,
    required this.memberTier,
    required this.themeColors,
    this.onAvatarEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final brandNavy = const Color(0xFF031024);
    final brandGold = const Color(0xFFFFD700);
    final lightGold = const Color(0xFFB8860B);
    final activeGold = themeColors.isDark ? brandGold : lightGold;

    // Use a premium mockup photo if the avatarUrl is empty
    final displayImage = avatarUrl.isNotEmpty
        ? avatarUrl
        : 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?fit=crop&w=400&h=400';

    return Center(
      child: Column(
        children: [
          // 1. Large Circular Avatar with Gold Ring Outline
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [brandGold, const Color(0xFFB8860B), brandGold],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: brandGold.withValues(alpha: themeColors.isDark ? 0.35 : 0.15),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 64,
                  backgroundColor: brandNavy,
                  backgroundImage: NetworkImage(displayImage),
                ),
              ),
              if (onAvatarEditTap != null)
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: InkWell(
                    onTap: onAvatarEditTap,
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: activeGold,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: themeColors.background,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // 2. Name "أحمد محمد"
          Text(
            name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: themeColors.textPrimary,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 8),

          // 3. Gold/Beige Pill for "عميل" (Client)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFDF2E2), // soft gold-beige background
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: const Color(0xFFF3D2A2),
                width: 1,
              ),
            ),
            child: Text(
              userType,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFFC29143), // elegant dark gold text
                fontFamily: 'Cairo',
              ),
            ),
          ),
          const SizedBox(height: 4),

          // 4. "بريميوم" (Premium) Text
          Text(
            memberTier,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFFC29143),
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
