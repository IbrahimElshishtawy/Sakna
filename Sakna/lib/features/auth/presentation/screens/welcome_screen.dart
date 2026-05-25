import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/app_colors.dart';
import '../../../../core/presentation/widgets/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?auto=format&fit=crop&w=1200&q=80',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: AppColors.primary,
                  child: const Center(
                    child: CircularProgressIndicator(color: AppColors.accent),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.primary,
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.white, size: 50),
                  ),
                );
              },
            ),
          ),
          
          // Gradient Overlay to make text readable
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.9),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0.0, 0.6],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Logo (Top Left)
                  Image.asset(
                    'assets/icons/iconApp.png',
                    width: 60,
                    height: 60,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add, color: AppColors.accent, size: 30),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Text Content
                  const Text(
                    'مرحباً بك في خدمة',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'نخبة من الفنيين والكوادر الطبية في خدمتك بلمسة واحدة.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Login Button
                  PrimaryButton(
                    text: 'تسجيل الدخول',
                    color: AppColors.accent,
                    textColor: AppColors.primary,
                    onPressed: () {
                      context.push('/login');
                    },
                  ),
                  const SizedBox(height: 16),
                  
                  // Create Account Button
                  PrimaryButton(
                    text: 'إنشاء حساب جديد',
                    isOutline: true,
                    borderColor: Colors.white,
                    textColor: Colors.white,
                    onPressed: () {
                      context.push('/register');
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
