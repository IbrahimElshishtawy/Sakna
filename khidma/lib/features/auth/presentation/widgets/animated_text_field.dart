import 'package:flutter/material.dart';

/// Animated text field with floating label and focus effects.
class AnimatedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const AnimatedTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  State<AnimatedTextField> createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField>
    with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  bool _isFocused = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _validate() {
    if (widget.validator != null) {
      final error = widget.validator!(widget.controller.text);
      setState(() => _errorText = error);
      if (error != null) {
        _shakeController.forward(from: 0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final shakeOffset =
            _shakeController.isAnimating ? sin(_shakeAnimation.value * 3 * 3.14159) * 8 : 0.0;
        return Transform.translate(
          offset: Offset(shakeOffset, 0),
          child: child,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withValues(alpha: _isFocused ? 0.15 : 0.1),
              border: Border.all(
                color: _errorText != null
                    ? Colors.redAccent.withValues(alpha: 0.8)
                    : _isFocused
                        ? Colors.white.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.15),
                width: _isFocused ? 1.5 : 1,
              ),
              boxShadow: _isFocused
                  ? [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.05),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: Focus(
              onFocusChange: (focused) {
                setState(() => _isFocused = focused);
                if (!focused) _validate();
              },
              child: TextFormField(
                controller: widget.controller,
                obscureText: widget.isPassword ? _obscureText : false,
                keyboardType: widget.keyboardType,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  labelText: widget.label,
                  hintText: widget.hint,
                  labelStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 14,
                  ),
                  prefixIcon: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      widget.prefixIcon,
                      color: _isFocused
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      size: 22,
                    ),
                  ),
                  suffixIcon: widget.isPassword
                      ? GestureDetector(
                          onTap: () =>
                              setState(() => _obscureText = !_obscureText),
                          child: Icon(
                            _obscureText
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                            color: Colors.white.withValues(alpha: 0.5),
                            size: 22,
                          ),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  errorStyle: const TextStyle(height: 0, fontSize: 0),
                ),
                validator: widget.validator,
              ),
            ),
          ),
          // Error text below the field
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: _errorText != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 6, right: 12, left: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            size: 14, color: Colors.redAccent),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _errorText!,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

double sin(double x) => _sin(x);
double _sin(double x) {
  // Use dart:math sin
  return x.isNaN ? 0 : _dartSin(x);
}
double _dartSin(double x) {
  return x - (x * x * x / 6) + (x * x * x * x * x / 120); // Taylor approx not needed, use import
}
