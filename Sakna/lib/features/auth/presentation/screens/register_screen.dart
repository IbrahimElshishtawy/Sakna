import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../../core/presentation/widgets/primary_button.dart';
import '../../../../core/presentation/widgets/sakna_logo.dart';
import '../../../localization/presentation/providers/localization_providers.dart';
import '../providers/auth_providers.dart';
import '../states/auth_state.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  String? _formError;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onPasswordChanged);
    _confirmPasswordController.addListener(_onConfirmPasswordChanged);
  }

  void _onPasswordChanged() {
    setState(() {});
  }

  void _onConfirmPasswordChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.removeListener(_onPasswordChanged);
    _passwordController.dispose();
    _confirmPasswordController.removeListener(_onConfirmPasswordChanged);
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _showConfirmPassword => _passwordController.text.isNotEmpty;
  bool get _passwordsMatch =>
      _passwordController.text.isNotEmpty &&
      _confirmPasswordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  void _handleRegister(AppTranslator t) async {
    setState(() {
      _formError = null;
    });

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _formError = t.translate('passwords_mismatch');
      });
      return;
    }

    if (!_agreeToTerms) {
      setState(() {
        _formError = t.translate('agree_terms_error');
      });
      return;
    }

    final authNotifier = ref.read(authControllerProvider.notifier);
    await authNotifier.register(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    // If registration was successful, navigate to OTP screen
    final authState = ref.read(authControllerProvider);
    if (authState is! Error) {
      if (mounted) {
        context.push('/otp');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      next.maybeWhen(
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                message,
                textAlign: t.isArabic ? TextAlign.right : TextAlign.left,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
              backgroundColor: Colors.red,
            ),
          );
        },
        orElse: () {},
      );
    });

    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return Scaffold(
      backgroundColor: themeColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Premium Header Block with Gradient & Logo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 80, bottom: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    themeColors.primary,
                    themeColors.isDark ? themeColors.surface : const Color(0xFF0F203C),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  // Brand Logo
                  const Center(
                    child: SaknaLogo(size: 76),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'SAKNA',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: themeColors.accent,
                      letterSpacing: 2,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.translate('sakna_desc'),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
            
            // Elevated card holding the registration form
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: themeColors.surface,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: themeColors.isDark ? 0.2 : 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subtitle header inside card
                      Center(
                        child: Column(
                          children: [
                            Text(
                              t.translate('create_account'),
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: themeColors.textPrimary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              t.translate('join_us'),
                              style: TextStyle(
                                fontSize: 13,
                                color: themeColors.textSecondary,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Name Field
                      _buildFieldLabel(t.translate('fullname'), themeColors),
                      _buildTextFormField(
                        controller: _nameController,
                        hint: t.translate('enter_fullname'),
                        icon: Icons.person_outline,
                        themeColors: themeColors,
                        t: t,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return t.translate('invalid_name');
                          }
                          if (value.trim().split(' ').length < 3) {
                            return t.translate('invalid_name');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Phone Field (Formatted like Screenshot)
                      _buildFieldLabel(t.translate('phone'), themeColors),
                      _buildPhoneInputField(themeColors, t),
                      const SizedBox(height: 16),

                      // Email Field
                      _buildFieldLabel(t.translate('email'), themeColors),
                      _buildTextFormField(
                        controller: _emailController,
                        hint: 'name@example.com',
                        icon: Icons.mail_outline,
                        themeColors: themeColors,
                        t: t,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return t.translate('invalid_email');
                          }
                          final emailRegExp = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                          );
                          if (!emailRegExp.hasMatch(value.trim())) {
                            return t.translate('invalid_email');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      _buildFieldLabel(t.translate('password'), themeColors),
                      _buildPasswordFormField(themeColors, t),

                      // Confirm Password Field (Animated Switcher / Size)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: _showConfirmPassword
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  _buildFieldLabel(t.translate('confirm_password'), themeColors),
                                  _buildConfirmPasswordFormField(themeColors, t),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),

                      // Terms and Conditions and Matching message (Animated Switcher / Size)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: _passwordsMatch
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  // Passwords match badge
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.green.withValues(alpha: 0.5), width: 1),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            t.translate('passwords_match_msg'),
                                            style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'Cairo',
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  // Terms and Conditions checkbox
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Transform.scale(
                                        scale: 0.9,
                                        child: Checkbox(
                                          value: _agreeToTerms,
                                          activeColor: themeColors.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          onChanged: (val) {
                                            setState(() {
                                              _agreeToTerms = val ?? false;
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              final agreed = await context.push<bool>('/terms');
                                              if (agreed == true) {
                                                setState(() {
                                                  _agreeToTerms = true;
                                                });
                                              }
                                            },
                                            child: RichText(
                                              text: TextSpan(
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: themeColors.textSecondary,
                                                  height: 1.5,
                                                  fontFamily: 'Cairo',
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: t.isArabic
                                                        ? 'أوافق على '
                                                        : 'I agree to the ',
                                                  ),
                                                  TextSpan(
                                                    text: t.isArabic
                                                        ? 'الشروط والأحكام و سياسة الخصوصية'
                                                        : 'Terms & Conditions & Privacy Policy',
                                                    style: TextStyle(
                                                      color: themeColors.accent,
                                                      fontWeight: FontWeight.bold,
                                                      decoration: TextDecoration.underline,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: t.isArabic
                                                        ? ' الخاصة بالمنصة.'
                                                        : ' of the platform.',
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox.shrink(),
                      ),

                      if (_formError != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _formError!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],

                      const SizedBox(height: 28),

                      // Submit button
                      isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: themeColors.accent,
                              ),
                            )
                          : PrimaryButton(
                              text: t.translate('create_account'),
                              icon: t.isArabic ? Icons.arrow_back : Icons.arrow_forward,
                              iconFirst: false,
                              onPressed: () => _handleRegister(t),
                            ),

                      const SizedBox(height: 24),

                      // Footer Login link
                      Center(
                        child: GestureDetector(
                          onTap: () => context.push('/login'),
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                              ),
                              children: [
                                TextSpan(
                                  text: '${t.translate('already_have_account')} ',
                                  style: TextStyle(color: themeColors.textSecondary),
                                ),
                                TextSpan(
                                  text: t.translate('login'),
                                  style: TextStyle(
                                    color: themeColors.accent,
                                    fontWeight: FontWeight.bold,
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
              ),
            ),

            // Bottom horizontal row of trust badges
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0, top: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTrustBadge(Icons.verified_user_outlined, t.isArabic ? 'آمن 100%' : '100% Secure', themeColors),
                  _buildTrustBadge(Icons.health_and_safety_outlined, t.isArabic ? 'أطباء معتمدون' : 'Certified Doctors', themeColors),
                  _buildTrustBadge(Icons.thumb_up_alt_outlined, t.isArabic ? 'جودة مضمونة' : 'Guaranteed Quality', themeColors),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, dynamic themeColors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0, right: 4.0),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: themeColors.textPrimary,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required dynamic themeColors,
    required AppTranslator t,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      textAlign: t.isArabic ? TextAlign.right : TextAlign.left,
      style: TextStyle(color: themeColors.textPrimary, fontFamily: 'Cairo'),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: themeColors.textSecondary, fontSize: 14, fontFamily: 'Cairo'),
        filled: true,
        fillColor: themeColors.border.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        suffixIcon: Icon(icon, color: themeColors.textSecondary, size: 22),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
    );
  }

  Widget _buildPasswordFormField(dynamic themeColors, AppTranslator t) {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textAlign: t.isArabic ? TextAlign.right : TextAlign.left,
      style: TextStyle(color: themeColors.textPrimary, fontFamily: 'Cairo'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return t.translate('invalid_password');
        }
        if (value.length < 6) {
          return t.translate('invalid_password');
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: TextStyle(color: themeColors.textSecondary, fontSize: 14, fontFamily: 'Cairo'),
        filled: true,
        fillColor: themeColors.border.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        suffixIcon: Icon(Icons.lock_outline, color: themeColors.textSecondary, size: 22),
        prefixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: themeColors.textSecondary,
            size: 20,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
    );
  }

  Widget _buildConfirmPasswordFormField(dynamic themeColors, AppTranslator t) {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _obscurePassword,
      textAlign: t.isArabic ? TextAlign.right : TextAlign.left,
      style: TextStyle(color: themeColors.textPrimary, fontFamily: 'Cairo'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return t.translate('enter_confirm_password');
        }
        if (value != _passwordController.text) {
          return t.translate('passwords_mismatch');
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: TextStyle(color: themeColors.textSecondary, fontSize: 14, fontFamily: 'Cairo'),
        filled: true,
        fillColor: themeColors.border.withValues(alpha: 0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        suffixIcon: Icon(Icons.lock_outline, color: themeColors.textSecondary, size: 22),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
    );
  }

  Widget _buildPhoneInputField(dynamic themeColors, AppTranslator t) {
    return Row(
      textDirection: TextDirection.ltr,
      children: [
        // Prefix container "+20"
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: themeColors.border.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              '+20',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: themeColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Phone number entry
        Expanded(
          child: TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
            style: TextStyle(color: themeColors.textPrimary, fontFamily: 'Cairo'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return t.translate('invalid_phone');
              }
              if (value.trim().length != 10 && value.trim().length != 11) {
                return t.translate('invalid_phone');
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: '01X XXXX XXXX',
              hintStyle: TextStyle(
                color: themeColors.textSecondary,
                fontSize: 14,
                letterSpacing: 1.5,
                fontFamily: 'Cairo',
              ),
              filled: true,
              fillColor: themeColors.border.withValues(alpha: 0.3),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              suffixIcon: Icon(Icons.phone_outlined, color: themeColors.textSecondary, size: 22),
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrustBadge(IconData icon, String label, dynamic themeColors) {
    return Column(
      children: [
        Icon(icon, color: themeColors.textSecondary, size: 26),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: themeColors.textSecondary,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}
