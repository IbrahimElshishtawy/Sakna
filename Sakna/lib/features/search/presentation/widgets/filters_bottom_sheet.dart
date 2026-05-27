import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../config/theme/theme_provider.dart';
import '../../../localization/presentation/providers/localization_providers.dart';

class FiltersBottomSheet extends ConsumerStatefulWidget {
  const FiltersBottomSheet({super.key});

  @override
  ConsumerState<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends ConsumerState<FiltersBottomSheet> {
  String _sortBy = 'distance'; // distance, price, rating
  RangeValues _priceRange = const RangeValues(100, 400);
  String _selectedRating = '4.0'; // 4.5, 4.0, 3.0
  String _gender = 'female'; // male, female, all
  double _distance = 10.0; // 0 to 50 km

  @override
  Widget build(BuildContext context) {
    final themeColors = ref.watch(themeColorsProvider);
    final t = ref.watch(translationProvider);
    final isAr = t.isArabic;

    final primaryActionColor = themeColors.isDark ? themeColors.accent : themeColors.primary;
    final primaryTextColor = themeColors.isDark ? Colors.black : Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: themeColors.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: Border.all(color: themeColors.border, width: 0.5),
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar at the top
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: themeColors.border,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Header with Title & Close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.translate('filters'),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: themeColors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: themeColors.border),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.close, color: themeColors.textPrimary, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            Divider(height: 32, color: themeColors.border),

            // 1. Sort By
            _buildSectionTitle(t.translate('sort_by'), themeColors),
            _buildRadioOption(t.translate('distance'), 'distance', themeColors, primaryActionColor),
            _buildRadioOption(t.translate('price_low_to_high'), 'price', themeColors, primaryActionColor),
            _buildRadioOption(t.translate('highest_rated'), 'rating', themeColors, primaryActionColor),
            const SizedBox(height: 24),

            // 2. Price Range
            _buildSectionTitle(t.translate('price_range'), themeColors),
            RangeSlider(
              values: _priceRange,
              min: 50,
              max: 500,
              divisions: 9,
              activeColor: primaryActionColor,
              inactiveColor: themeColors.border,
              labels: RangeLabels(
                '${_priceRange.start.round()} ${t.translate('egp')}',
                '${_priceRange.end.round()} ${t.translate('egp')}',
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _priceRange = values;
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_priceRange.start.round()} ${t.translate('egp')}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: themeColors.textSecondary),
                ),
                Text(
                  '${_priceRange.end.round() == 500 ? '500+' : _priceRange.end.round()} ${t.translate('egp')}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: themeColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3. Rating
            _buildSectionTitle(t.translate('rating'), themeColors),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRatingChip('4.5+ ★', '4.5', themeColors, primaryActionColor, primaryTextColor),
                _buildRatingChip('4.0+ ★', '4.0', themeColors, primaryActionColor, primaryTextColor),
                _buildRatingChip('3.0+ ★', '3.0', themeColors, primaryActionColor, primaryTextColor),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Gender
            _buildSectionTitle(t.translate('gender'), themeColors),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: themeColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: themeColors.border, width: 0.5),
              ),
              child: Row(
                children: [
                  _buildGenderTab(t.translate('gender_male'), 'male', themeColors, primaryActionColor),
                  _buildGenderTab(t.translate('gender_female'), 'female', themeColors, primaryActionColor),
                  _buildGenderTab(t.translate('all'), 'all', themeColors, primaryActionColor),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 5. Distance
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle(t.translate('distance'), themeColors),
                Text(
                  '${_distance.round()} ${t.translate('km')}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryActionColor,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
            Slider(
              value: _distance,
              min: 1,
              max: 50,
              divisions: 49,
              activeColor: primaryActionColor,
              inactiveColor: themeColors.border,
              onChanged: (val) {
                setState(() {
                  _distance = val;
                });
              },
            ),
            const SizedBox(height: 32),

            // Bottom Actions: Apply & Clear
            Row(
              children: [
                // Clear all
                TextButton(
                  onPressed: () {
                    setState(() {
                      _sortBy = 'distance';
                      _priceRange = const RangeValues(100, 400);
                      _selectedRating = '4.0';
                      _gender = 'female';
                      _distance = 10.0;
                    });
                  },
                  child: Text(
                    t.translate('clear_all'),
                    style: TextStyle(
                      color: themeColors.textSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Apply button
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryActionColor,
                        foregroundColor: primaryTextColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        t.translate('apply_filters'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, dynamic themeColors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: themeColors.textPrimary,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  Widget _buildRadioOption(String label, String value, dynamic themeColors, Color primaryActionColor) {
    final isSelected = _sortBy == value;
    return InkWell(
      onTap: () {
        setState(() {
          _sortBy = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? primaryActionColor : themeColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? primaryActionColor : themeColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingChip(String label, String value, dynamic themeColors, Color primaryActionColor, Color primaryTextColor) {
    final isSelected = _selectedRating == value;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? primaryTextColor : themeColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      selected: isSelected,
      selectedColor: primaryActionColor,
      backgroundColor: themeColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isSelected ? primaryActionColor : themeColors.border,
        ),
      ),
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedRating = value;
          });
        }
      },
    );
  }

  Widget _buildGenderTab(String label, String value, dynamic themeColors, Color primaryActionColor) {
    final isSelected = _gender == value;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _gender = value;
          });
        },
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: isSelected ? themeColors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: themeColors.isDark ? 0.2 : 0.04),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
            border: isSelected
                ? Border.all(color: themeColors.border, width: 0.5)
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? primaryActionColor : themeColors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
