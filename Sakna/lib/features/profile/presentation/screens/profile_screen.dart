import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final themeMode = ref.watch(themeModeProvider);
    final t = ref.watch(translationProvider);
    final isAr = t.isArabic;

    // Signature brand colors
    final brandNavy = const Color(0xFF031024);
    final brandGold = const Color(0xFFFFD700);
    final lightGold = const Color(0xFFB8860B);
    final activeGold = themeColors.isDark ? brandGold : lightGold;

    return Scaffold(
      backgroundColor: themeColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 24.0,
          bottom: 110.0, // bottom padded for floating navbar
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // 1. Premium Header Section with dynamic greeting
            Text(
              t.translate('profile'),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: themeColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 20),

            // 2. High-end Glassmorphic Profile Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: themeColors.isDark
                      ? [
                          brandNavy.withValues(alpha: 0.85),
                          const Color(0xFF051D3F).withValues(alpha: 0.85),
                        ]
                      : [
                          Colors.white,
                          Colors.white.withValues(alpha: 0.9),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: themeColors.isDark ? 0.4 : 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: themeColors.isDark
                      ? brandGold.withValues(alpha: 0.25)
                      : themeColors.border,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: [
                  // Avatar with Golden Gradient Ring
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
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 46,
                      backgroundColor: brandNavy,
                      child: Text(
                        isAr ? 'أ م' : 'AM',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: brandGold,
                          letterSpacing: isAr ? 1.0 : 2.0,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Username
                  Text(
                    t.translate('user_name'),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: themeColors.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Membership Tier
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: activeGold.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: activeGold.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.workspace_premium_rounded,
                          size: 15,
                          color: activeGold,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          t.translate('member_tier'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: activeGold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. Dynamic Balance Credit Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: themeColors.isDark
                      ? [
                          const Color(0xFF0D2547),
                          brandNavy,
                        ]
                      : [
                          brandNavy,
                          const Color(0xFF0A2242),
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                image: DecorationImage(
                  image: const AssetImage('assets/images/card_pattern.png'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.white.withValues(alpha: 0.04),
                    BlendMode.dstATop,
                  ),
                  onError: (exception, stackTrace) {}, // Gracefully handle missing asset
                ),
                boxShadow: [
                  BoxShadow(
                    color: brandNavy.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: brandGold.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.translate('wallet_balance'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.7),
                          fontFamily: 'Cairo',
                        ),
                      ),
                      Icon(
                        Icons.account_balance_wallet_rounded,
                        color: brandGold,
                        size: 26,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '250.00',
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        t.translate('egp'),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: brandGold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // 4. Settings Section Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Text(
                t.translate('settings'),
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: themeColors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 5. Interactive Theme Switcher Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: themeColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: themeColors.border, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.palette_outlined,
                        color: activeGold,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        t.translate('appearance'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: themeColors.textPrimary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  
                  // Day & Night Selector Pills
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: themeColors.background,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: themeColors.border, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        // Light Mode Pill
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (themeMode != ThemeMode.light) {
                                ref.read(themeModeProvider.notifier).toggleTheme();
                              }
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: themeMode == ThemeMode.light
                                    ? (themeColors.isDark ? brandNavy : Colors.white)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: themeMode == ThemeMode.light
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 4,
                                        ),
                                      ]
                                    : null,
                                border: themeMode == ThemeMode.light
                                    ? Border.all(color: activeGold.withValues(alpha: 0.3), width: 1)
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.light_mode_rounded,
                                    size: 18,
                                    color: themeMode == ThemeMode.light ? activeGold : themeColors.textSecondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    t.translate('theme_light'),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: themeMode == ThemeMode.light
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: themeMode == ThemeMode.light
                                          ? themeColors.textPrimary
                                          : themeColors.textSecondary,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        // Dark Mode Pill
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              if (themeMode != ThemeMode.dark) {
                                ref.read(themeModeProvider.notifier).toggleTheme();
                              }
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: themeMode == ThemeMode.dark
                                    ? (themeColors.isDark ? brandNavy : Colors.white)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: themeMode == ThemeMode.dark
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.15),
                                          blurRadius: 4,
                                        ),
                                      ]
                                    : null,
                                border: themeMode == ThemeMode.dark
                                    ? Border.all(color: activeGold.withValues(alpha: 0.3), width: 1)
                                    : null,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.dark_mode_rounded,
                                    size: 18,
                                    color: themeMode == ThemeMode.dark ? activeGold : themeColors.textSecondary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    t.translate('theme_dark'),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: themeMode == ThemeMode.dark
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: themeMode == ThemeMode.dark
                                          ? themeColors.textPrimary
                                          : themeColors.textSecondary,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 6. Interactive Language Selector Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: themeColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: themeColors.border, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.translate_rounded,
                        color: activeGold,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        t.translate('language'),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: themeColors.textPrimary,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Language Pills
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: themeColors.background,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: themeColors.border, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        // Arabic Pill
                        Expanded(
                          child: InkWell(
                            onTap: () => ref.read(localeProvider.notifier).setLocale('ar'),
                            borderRadius: BorderRadius.circular(10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isAr
                                    ? (themeColors.isDark ? brandNavy : Colors.white)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: isAr
                                    ? Border.all(color: activeGold.withValues(alpha: 0.3), width: 1)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  'العربية',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isAr ? FontWeight.bold : FontWeight.normal,
                                    color: isAr ? themeColors.textPrimary : themeColors.textSecondary,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        // English Pill
                        Expanded(
                          child: InkWell(
                            onTap: () => ref.read(localeProvider.notifier).setLocale('en'),
                            borderRadius: BorderRadius.circular(10),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !isAr
                                    ? (themeColors.isDark ? brandNavy : Colors.white)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: !isAr
                                    ? Border.all(color: activeGold.withValues(alpha: 0.3), width: 1)
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  'English',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: !isAr ? FontWeight.bold : FontWeight.normal,
                                    color: !isAr ? themeColors.textPrimary : themeColors.textSecondary,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 7. General Utility Actions
            Container(
              decoration: BoxDecoration(
                color: themeColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: themeColors.border, width: 1),
              ),
              child: Column(
                children: [
                  // Saved Addresses
                  _buildMenuTile(
                    icon: Icons.map_outlined,
                    title: t.translate('saved_addresses'),
                    themeColors: themeColors,
                    onTap: () {},
                  ),
                  Divider(color: themeColors.border, height: 1, thickness: 1),
                  
                  // Help & Support
                  _buildMenuTile(
                    icon: Icons.headset_mic_outlined,
                    title: t.translate('support'),
                    themeColors: themeColors,
                    onTap: () {},
                  ),
                  Divider(color: themeColors.border, height: 1, thickness: 1),
                  
                  // Log Out (Red Accent)
                  _buildMenuTile(
                    icon: Icons.logout_rounded,
                    title: t.translate('logout'),
                    themeColors: themeColors,
                    iconColor: Colors.redAccent,
                    textColor: Colors.redAccent,
                    showTrailing: false,
                    onTap: () => _showLogoutDialog(context, themeColors, t),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required dynamic themeColors,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
    bool showTrailing = true,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(
        icon,
        color: iconColor ?? (themeColors.isDark ? const Color(0xFFFFD700) : const Color(0xFFB8860B)),
        size: 22,
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
      trailing: showTrailing
          ? Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: themeColors.textSecondary,
            )
          : null,
    );
  }

  void _showLogoutDialog(BuildContext context, dynamic themeColors, dynamic t) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            backgroundColor: themeColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: themeColors.border,
                width: 1,
              ),
            ),
            title: Text(
              t.translate('logout'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeColors.textPrimary,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              t.isArabic 
                  ? 'هل أنت متأكد من رغبتك في تسجيل الخروج؟' 
                  : 'Are you sure you want to log out?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeColors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  t.isArabic ? 'إلغاء' : 'Cancel',
                  style: TextStyle(
                    color: themeColors.textSecondary,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                ),
                child: Text(
                  t.isArabic ? 'خروج' : 'Log Out',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
