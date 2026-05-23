import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class CustomNumericKeyboard extends StatelessWidget {
  final Function(String) onKeyPressed;
  final VoidCallback onDeletePressed;

  const CustomNumericKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 16),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 16),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 16),
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        return _buildKeyButton(
          content: Text(
            key,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Cairo',
            ),
          ),
          onPressed: () => onKeyPressed(key),
        );
      }).toList(),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Delete button
        _buildKeyButton(
          content: const Icon(
            Icons.backspace_outlined,
            color: AppColors.textPrimary,
            size: 24,
          ),
          onPressed: onDeletePressed,
        ),
        // Zero button
        _buildKeyButton(
          content: const Text(
            '0',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Cairo',
            ),
          ),
          onPressed: () => onKeyPressed('0'),
        ),
        // Empty space for layout balance
        const Expanded(
          child: SizedBox(
            height: 60,
          ),
        ),
      ],
    );
  }

  Widget _buildKeyButton({
    required Widget content,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: content,
          ),
        ),
      ),
    );
  }
}
