import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';
import '../providers/profile_providers.dart';
import '../widgets/profile_avatar_section.dart';
import '../widgets/profile_custom_app_bar.dart';
import '../widgets/profile_menu_tile.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final themeMode = ref.watch(themeModeProvider);
    final t = ref.watch(translationProvider);
    final isAr = t.isArabic;
    
    // Watch Clean Architecture profile state
    final profileState = ref.watch(profileControllerProvider);
    final profileController = ref.read(profileControllerProvider.notifier);

    // Signature brand colors
    final brandNavy = const Color(0xFF031024);
    final brandGold = const Color(0xFFFFD700);

    return Scaffold(
      backgroundColor: themeColors.background,
      appBar: ProfileCustomAppBar(
        title: t.translate('welcome_in_khidma'),
        avatarUrl: profileState.userProfile?.avatarUrl ?? '',
        themeColors: themeColors,
        onNotificationTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isAr ? 'لا توجد إشعارات جديدة حالياً' : 'No new notifications at this time',
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
              backgroundColor: themeColors.surface,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        onAvatarTap: () {
          if (profileState.userProfile != null) {
            _showEditNameDialog(context, ref, profileState.userProfile!.name, themeColors, t);
          }
        },
      ),
      body: Builder(
        builder: (context) {
          if (profileState.isLoading && profileState.userProfile == null) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(brandGold),
              ),
            );
          }

          if (profileState.errorMessage != null && profileState.userProfile == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      profileState.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: themeColors.textPrimary, fontFamily: 'Cairo'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => profileController.loadProfile(),
                      style: ElevatedButton.styleFrom(backgroundColor: brandGold),
                      child: Text(isAr ? 'إعادة المحاولة' : 'Retry', style: const TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            );
          }

          final user = profileState.userProfile!;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 16.0,
              bottom: 110.0, // bottom padded for floating navbar
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Premium Avatar Section
                ProfileAvatarSection(
                  name: user.name,
                  avatarUrl: user.avatarUrl,
                  userType: isAr ? 'عميل' : t.translate('customer_badge'),
                  memberTier: isAr ? 'بريميوم' : t.translate('premium_badge'),
                  themeColors: themeColors,
                  onAvatarEditTap: () {
                    _showEditNameDialog(context, ref, user.name, themeColors, t);
                  },
                ),
                const SizedBox(height: 28),

                // 2. Settings Group Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    isAr ? 'الإعدادات الشخصية' : 'Personal Settings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: themeColors.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // 3. First Settings Section Card (Personal Info, Addresses, Payments)
                Container(
                  decoration: BoxDecoration(
                    color: themeColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: themeColors.border, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: themeColors.isDark ? 0.2 : 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Personal Information Row
                      ProfileMenuTile(
                        icon: Icons.person_outline_rounded,
                        title: t.translate('personal_info'),
                        themeColors: themeColors,
                        showDivider: true,
                        onTap: () {
                          _showEditNameDialog(context, ref, user.name, themeColors, t);
                        },
                      ),
                      // Saved Addresses Row
                      ProfileMenuTile(
                        icon: Icons.map_outlined,
                        title: t.translate('registered_addresses'),
                        themeColors: themeColors,
                        showDivider: true,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isAr ? 'العناوين المسجلة قيد التطوير' : 'Registered Addresses is under development',
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                              backgroundColor: themeColors.surface,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      // Payment Methods Row
                      ProfileMenuTile(
                        icon: Icons.credit_card_rounded,
                        title: t.translate('payment_methods'),
                        themeColors: themeColors,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isAr ? 'طرق الدفع قيد التطوير' : 'Payment Methods is under development',
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                              backgroundColor: themeColors.surface,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 4. System Settings Title
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    t.translate('settings'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: themeColors.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // 5. Second Settings Section Card (Language, Dark Mode)
                Container(
                  decoration: BoxDecoration(
                    color: themeColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: themeColors.border, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: themeColors.isDark ? 0.2 : 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Language Row
                      ProfileMenuTile(
                        icon: Icons.language_rounded,
                        title: t.translate('language'),
                        subtitle: isAr ? 'العربية' : 'English',
                        themeColors: themeColors,
                        showDivider: true,
                        onTap: () {
                          _showLanguageBottomSheet(context, ref, themeColors, t);
                        },
                      ),
                      // Dark Mode Row
                      ProfileMenuTile(
                        icon: Icons.dark_mode_outlined,
                        title: t.translate('theme_dark'),
                        themeColors: themeColors,
                        trailing: Switch.adaptive(
                          value: themeMode == ThemeMode.dark,
                          activeColor: brandGold,
                          activeTrackColor: brandGold.withValues(alpha: 0.3),
                          onChanged: (bool value) {
                            ref.read(themeModeProvider.notifier).toggleTheme();
                          },
                        ),
                        onTap: () {
                          ref.read(themeModeProvider.notifier).toggleTheme();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 6. Support & Help Card
                Container(
                  decoration: BoxDecoration(
                    color: themeColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: themeColors.border, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: themeColors.isDark ? 0.2 : 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Help & Support Row
                      ProfileMenuTile(
                        icon: Icons.headset_mic_outlined,
                        title: t.translate('support'),
                        themeColors: themeColors,
                        showDivider: true,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isAr ? 'الدعم الفني والشكاوى متاح على مدار الساعة' : 'Help & Support is active 24/7',
                                style: const TextStyle(fontFamily: 'Cairo'),
                              ),
                              backgroundColor: themeColors.surface,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                      // Log Out Row (Red Accent)
                      ProfileMenuTile(
                        icon: Icons.logout_rounded,
                        title: t.translate('logout'),
                        themeColors: themeColors,
                        iconColor: Colors.redAccent,
                        textColor: Colors.redAccent,
                        trailing: const SizedBox.shrink(),
                        onTap: () => _showLogoutDialog(context, ref, themeColors, t),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showEditNameDialog(
    BuildContext context,
    WidgetRef ref,
    String currentName,
    dynamic themeColors,
    dynamic t,
  ) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            backgroundColor: themeColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: themeColors.border, width: 1),
            ),
            title: Text(
              t.isArabic ? 'تعديل الاسم' : 'Edit Name',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: themeColors.textPrimary,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: TextField(
              controller: controller,
              style: TextStyle(color: themeColors.textPrimary, fontFamily: 'Cairo'),
              decoration: InputDecoration(
                hintText: t.isArabic ? 'أدخل الاسم الجديد' : 'Enter new name',
                hintStyle: TextStyle(color: themeColors.textSecondary.withValues(alpha: 0.7)),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: themeColors.border)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: themeColors.accent)),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  t.isArabic ? 'إلغاء' : 'Cancel',
                  style: TextStyle(color: themeColors.textSecondary, fontFamily: 'Cairo'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  final newName = controller.text.trim();
                  if (newName.isNotEmpty) {
                    ref.read(profileControllerProvider.notifier).updateProfileName(newName);
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  t.isArabic ? 'حفظ' : 'Save',
                  style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageBottomSheet(
    BuildContext context,
    WidgetRef ref,
    dynamic themeColors,
    dynamic t,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: themeColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: themeColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                t.translate('language'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: themeColors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.language_rounded, color: Colors.blueAccent),
                title: const Text('العربية', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                trailing: t.isArabic ? Icon(Icons.check_circle_rounded, color: themeColors.accent) : null,
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale('ar');
                  Navigator.pop(context);
                },
              ),
              Divider(color: themeColors.border, height: 1),
              ListTile(
                leading: const Icon(Icons.language_rounded, color: Colors.orangeAccent),
                title: const Text('English', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                trailing: !t.isArabic ? Icon(Icons.check_circle_rounded, color: themeColors.accent) : null,
                onTap: () {
                  ref.read(localeProvider.notifier).setLocale('en');
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref, dynamic themeColors, dynamic t) {
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
                onPressed: () {
                  Navigator.pop(context);
                  ref.read(profileControllerProvider.notifier).logout();
                },
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
