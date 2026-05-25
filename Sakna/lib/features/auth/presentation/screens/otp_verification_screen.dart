import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/presentation/widgets/primary_button.dart';
import '../providers/auth_providers.dart';
import '../states/auth_state.dart';
import '../widgets/custom_numeric_keyboard.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _hasError = false;
  
  // Timer State variables
  int _secondsRemaining = 14; // Matches the 00:14 starting point in the design
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 14;
      _canResend = false;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _handleKeyPress(String digit) {
    if (_otpController.text.length < 4) {
      setState(() {
        _otpController.text += digit;
        _hasError = false;
      });
    }
  }

  void _handleDeletePress() {
    if (_otpController.text.isNotEmpty) {
      setState(() {
        _otpController.text = _otpController.text.substring(0, _otpController.text.length - 1);
        _hasError = false;
      });
    }
  }

  void _handleResendCode() {
    if (_canResend) {
      _startTimer();
      // Call remote API for resending code
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم إعادة إرسال رمز التحقق بنجاح',
            textAlign: TextAlign.right,
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  void _handleConfirm() async {
    final value = _otpController.text;
    if (value.length < 4) {
      setState(() {
        _hasError = true;
      });
      return;
    }

    // Mock validation
    if (value != '1234') {
      setState(() {
        _hasError = true;
      });
      return;
    }

    final authNotifier = ref.read(authControllerProvider.notifier);
    // Hardcode a default phone or fetch it dynamically.
    // For demo purposes, we will authenticate successfully.
    await authNotifier.verifyOtp('01000000000', value);

    final authState = ref.read(authControllerProvider);
    if (authState is! Error) {
      if (mounted) {
        context.push('/complete-profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      next.maybeWhen(
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
                textAlign: TextAlign.right,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
              backgroundColor: Colors.red,
            ),
          );
        },
        orElse: () {},
      );
    });

    final defaultPinTheme = PinTheme(
      width: 64,
      height: 64,
      textStyle: const TextStyle(
        fontSize: 26,
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
      ),
      decoration: BoxDecoration(
        color: AppColors.greyLight.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: Colors.red, width: 1.5),
      ),
      textStyle: defaultPinTheme.textStyle?.copyWith(color: Colors.red),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.white,
        border: Border.all(color: AppColors.primary, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );

    // Format the time as 00:XX
    final formattedTime = '00:${_secondsRemaining.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'SAKNA',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            letterSpacing: 1.5,
          ),
        ),
        // RTL Back button on the right/left
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    
                    // Dark navy circular badge with a gold shield outline icon in the middle
                    Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.shield_outlined,
                          color: AppColors.accent,
                          size: 44,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Title
                    const Text(
                      'تأكيد رقم الهاتف',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Subtitle (Custom Arabic Text)
                    const Text(
                      'أدخل الرمز المكون من 4 أرقام المرسل إلى رقمك\n01X XXXX XXXX',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 36),
                    
                    // OTP Input Fields (4 digits)
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        length: 4,
                        controller: _otpController,
                        defaultPinTheme: defaultPinTheme,
                        errorPinTheme: errorPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        forceErrorState: _hasError,
                        readOnly: true, // Prevents system keyboard from sliding up
                        separatorBuilder: (index) => const SizedBox(width: 14),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Error message
                    if (_hasError)
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'الرمز غير صحيح. يرجى المحاولة مرة أخرى.',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    
                    const SizedBox(height: 32),
                    
                    // Timer display "إعادة إرسال الرمز خلال 00:14"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'إعادة إرسال الرمز خلال ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          formattedTime,
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    // Resend button (enabled/disabled states)
                    TextButton(
                      onPressed: _canResend ? _handleResendCode : null,
                      child: Text(
                        'إعادة إرسال الرمز',
                        style: TextStyle(
                          color: _canResend ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.5),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Confirm button "تأكيد"
                    PrimaryButton(
                      text: 'تأكيد',
                      icon: Icons.check_circle_outline,
                      onPressed: _handleConfirm,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            // Custom Numeric On-Screen Keypad
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(bottom: 24.0, top: 12.0),
              child: CustomNumericKeyboard(
                onKeyPressed: _handleKeyPress,
                onDeletePressed: _handleDeletePress,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
