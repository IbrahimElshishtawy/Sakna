import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../../core/presentation/widgets/primary_button.dart';
import '../../../../core/presentation/widgets/sakna_logo.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);

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
                  color: themeColors.primary,
                  child: Center(
                    child: CircularProgressIndicator(color: themeColors.accent),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: themeColors.primary,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Colors.white,
                      size: 50,
                    ),
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
                    themeColors.primary.withValues(alpha: 0.95),
                    Colors.transparent,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: const [0.0, 0.65],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Logo & Floating Toggles in a clean top header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SaknaLogo(size: 60),
                      Row(
                        children: [
                          // Language Toggle
                          GestureDetector(
                            onTap: () {
                              ref.read(localeProvider.notifier).toggleLocale();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: themeColors.accent, width: 1.5),
                              ),
                              child: Text(
                                t.isArabic ? 'EN' : 'عربي',
                                style: TextStyle(
                                  color: themeColors.accent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Theme Toggle Button
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black38,
                              border: Border.all(color: themeColors.accent, width: 1.5),
                            ),
                            child: IconButton(
                              icon: Icon(
                                themeColors.isDark ? Icons.wb_sunny : Icons.nightlight_round,
                                color: themeColors.accent,
                                size: 18,
                              ),
                              onPressed: () {
                                ref.read(themeModeProvider.notifier).toggleTheme();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Text Content
                  Text(
                    t.translate('welcome_title'),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    t.translate('welcome_subtitle'),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Login Button
                  PrimaryButton(
                    text: t.translate('login'),
                    color: themeColors.accent,
                    textColor: themeColors.primary,
                    onPressed: () {
                      context.push('/login');
                    },
                  ),
                  const SizedBox(height: 16),

                  // Create Account Button
                  PrimaryButton(
                    text: t.translate('create_account'),
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
