import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khidma/config/theme/theme_provider.dart';

class BottomActionNav extends ConsumerWidget {
  const BottomActionNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeColors = ref.watch(themeColorsProvider);

    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16,
        top: 14,
      ),
      decoration: BoxDecoration(
        color: themeColors.surface,
        border: Border(
          top: BorderSide(
            color: themeColors.border,
            width: 0.8,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Book now action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'احجز الآن',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              // Chat action
            },
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: themeColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: themeColors.border,
                  width: 1.2,
                ),
              ),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                color: themeColors.primary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
