import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/presentation/widgets/primary_button.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _hasError = false; // For demonstration

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 64,
      textStyle: const TextStyle(
        fontSize: 24,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: Colors.red),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.greyLight),
              color: Colors.white,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_forward, color: AppColors.textPrimary, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              // Lock Icon Container
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.lock_outline, color: AppColors.primary, size: 32),
                ),
              ),
              const SizedBox(height: 24),
              
              // Title
              const Text(
                'تأكيد رقم الهاتف',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              
              // Subtitle
              const Text(
                'أدخل الرمز المكون من 6 أرقام المرسل إلى\n010********',
                style: TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              
              // OTP Input
              Directionality(
                textDirection: TextDirection.ltr, // OTP inputs usually LTR
                child: Pinput(
                  length: 6,
                  controller: _otpController,
                  defaultPinTheme: defaultPinTheme,
                  errorPinTheme: errorPinTheme,
                  forceErrorState: _hasError,
                  separatorBuilder: (index) {
                    if (index == 2) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '-',
                          style: TextStyle(fontSize: 24, color: AppColors.greyLight),
                        ),
                      );
                    }
                    return const SizedBox(width: 8);
                  },
                  onChanged: (value) {
                    if (_hasError) setState(() => _hasError = false);
                  },
                  onCompleted: (value) {
                    // Trigger validation
                    // For UI demo, if it doesn't match a certain code, show error
                    if (value != '123456') {
                      setState(() => _hasError = true);
                    } else {
                      setState(() => _hasError = false);
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Error text
              if (_hasError)
                const Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'الرمز الذي أدخلته غير صحيح. يرجى المحاولة مرة أخرى.',
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ],
                ),
              
              const Spacer(),
              
              // Timer and Resend
              Center(
                child: Column(
                  children: [
                    const Text(
                      'إعادة إرسال الرمز خلال 0:59',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: null, // Disabled state
                      child: const Text(
                        'إعادة إرسال الرمز',
                        style: TextStyle(
                          color: AppColors.textSecondary, // Disabled color
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Confirm Button
              PrimaryButton(
                text: 'تأكيد',
                onPressed: () {
                  context.push('/complete-profile');
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
