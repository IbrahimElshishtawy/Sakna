import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../../core/presentation/widgets/primary_button.dart';
import '../../../../core/presentation/widgets/sakna_logo.dart';
import '../../../localization/presentation/providers/localization_providers.dart';
import '../widgets/social_login_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

    return Scaffold(
      backgroundColor: themeColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: themeColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Brand Logo
            const Center(
              child: SaknaLogo(size: 80),
            ),
            const SizedBox(height: 32),
            
            // Title
            Text(
              t.translate('login_title'),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: themeColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 12),
            
            // Subtitle
            Text(
              t.translate('login_subtitle'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: themeColors.textSecondary,
                height: 1.5,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 40),
            
            // Phone input label
            Align(
              alignment: t.isArabic ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                t.translate('phone'),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: themeColors.textPrimary,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Phone Input
            Directionality(
              textDirection: TextDirection.ltr,
              child: IntlPhoneField(
                controller: _phoneController,
                style: TextStyle(color: themeColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: themeColors.border.withValues(alpha: 0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  hintStyle: TextStyle(color: themeColors.textSecondary, fontFamily: 'Cairo'),
                ),
                initialCountryCode: 'EG',
                textAlign: TextAlign.left,
                showDropdownIcon: true,
                dropdownIconPosition: IconPosition.leading,
                flagsButtonPadding: const EdgeInsets.only(left: 16),
                onChanged: (phone) {
                  // handle phone change
                },
              ),
            ),
            const SizedBox(height: 24),
            
            // Send Code Button
            PrimaryButton(
              text: t.translate('send_otp'),
              icon: t.isArabic ? Icons.west : Icons.east,
              iconFirst: false,
              onPressed: () {
                context.push('/otp');
              },
            ),
            const SizedBox(height: 32),
            
            // Divider
            Row(
              children: [
                Expanded(child: Divider(color: themeColors.border, thickness: 1)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    t.translate('or_continue_with'),
                    style: TextStyle(color: themeColors.textSecondary, fontSize: 14, fontFamily: 'Cairo'),
                  ),
                ),
                Expanded(child: Divider(color: themeColors.border, thickness: 1)),
              ],
            ),
            const SizedBox(height: 32),
            
            // Social Buttons
            Row(
              children: [
                SocialLoginButton(
                  label: 'Facebook',
                  fallbackIcon: Icons.facebook,
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                SocialLoginButton(
                  label: 'Google',
                  fallbackIcon: Icons.g_mobiledata,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
