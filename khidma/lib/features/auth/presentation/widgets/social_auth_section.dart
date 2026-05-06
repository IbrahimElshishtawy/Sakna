import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

/// Social authentication buttons (Google & Apple) section.
class SocialAuthSection extends StatelessWidget {
  const SocialAuthSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "or"
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'أو المتابعة بـ',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Social Buttons Row
        Row(
          children: [
            // Google Button
            Expanded(
              child: _SocialButton(
                label: 'Google',
                icon: Icons.g_mobiledata_rounded,
                iconSize: 28,
                onTap: () {
                  context
                      .read<AuthBloc>()
                      .add(const AuthGoogleLoginRequested());
                },
              ),
            ),
            const SizedBox(width: 16),

            // Apple Button
            Expanded(
              child: _SocialButton(
                label: 'Apple',
                icon: Icons.apple_rounded,
                iconSize: 24,
                onTap: () {
                  context
                      .read<AuthBloc>()
                      .add(const AuthAppleLoginRequested());
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SocialButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final double iconSize;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.iconSize,
    required this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withValues(alpha: 0.1),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: Colors.white,
                size: widget.iconSize,
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
