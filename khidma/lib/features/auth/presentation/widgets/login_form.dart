import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'animated_text_field.dart';

/// Login form with email/password fields and a submit button
/// that transforms into a loading spinner.
class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  late AnimationController _buttonController;
  late Animation<double> _buttonWidthAnimation;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _buttonWidthAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AuthLoginRequested(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          _buttonController.forward();
        } else {
          _buttonController.reverse();
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Email
            AnimatedTextField(
              controller: _emailController,
              label: 'البريد الإلكتروني',
              hint: 'example@email.com',
              prefixIcon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'البريد الإلكتروني مطلوب';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'صيغة البريد الإلكتروني غير صحيحة';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Password
            AnimatedTextField(
              controller: _passwordController,
              label: 'كلمة المرور',
              hint: '••••••••',
              prefixIcon: Icons.lock_rounded,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'كلمة المرور مطلوبة';
                }
                if (value.length < 6) {
                  return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Forgot Password
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // TODO: Navigate to forgot password
                },
                child: Text(
                  'نسيت كلمة المرور؟',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Login Button with loading animation
            AnimatedBuilder(
              animation: _buttonWidthAnimation,
              builder: (context, child) {
                return Center(
                  child: SizedBox(
                    width: _buttonWidthAnimation.value *
                            (MediaQuery.of(context).size.width - 64) +
                        56,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _buttonWidthAnimation.value == 1.0
                          ? _onSubmit
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF0F64FF),
                        elevation: 4,
                        shadowColor: Colors.black.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            _buttonWidthAnimation.value * 16 + 28,
                          ),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: _buttonWidthAnimation.value < 0.3
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF0F64FF),
                                ),
                              ),
                            )
                          : const Text(
                              'تسجيل الدخول',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
