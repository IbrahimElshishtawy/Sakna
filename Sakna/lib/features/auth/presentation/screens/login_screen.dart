import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/presentation/widgets/primary_button.dart';
import '../widgets/social_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  
  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // No back button shown in design, but we can add one if needed.
        // leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Logo Container
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Icon(Icons.add_circle_outline, color: AppColors.accent, size: 50), // Placeholder for actual logo
              ),
            ),
            const SizedBox(height: 32),
            
            // Title
            const Text(
              'تسجيل الدخول',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            
            // Subtitle
            const Text(
              'أهلاً بك مجدداً، يرجى إدخال رقم هاتفك للمتابعة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 40),
            
            // Phone input label
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'رقم الهاتف',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            
            // Phone Input
            Directionality(
              textDirection: TextDirection.ltr,
              child: IntlPhoneField(
                controller: _phoneController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.greyLight.withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                ),
                initialCountryCode: 'EG',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
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
              text: 'أرسل رمز التحقق',
              icon: Icons.west, // Left pointing arrow
              iconFirst: false,
              onPressed: () {
                context.push('/otp');
              },
            ),
            const SizedBox(height: 32),
            
            // Divider
            Row(
              children: [
                Expanded(child: Divider(color: AppColors.greyLight, thickness: 1)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'أو المتابعة عبر',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ),
                Expanded(child: Divider(color: AppColors.greyLight, thickness: 1)),
              ],
            ),
            const SizedBox(height: 32),
            
            // Social Buttons
            Row(
              children: [
                SocialLoginButton(
                  label: 'Apple',
                  fallbackIcon: Icons.apple,
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
