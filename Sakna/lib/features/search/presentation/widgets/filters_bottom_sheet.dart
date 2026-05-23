import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class FiltersBottomSheet extends StatefulWidget {
  const FiltersBottomSheet({super.key});

  @override
  State<FiltersBottomSheet> createState() => _FiltersBottomSheetState();
}

class _FiltersBottomSheetState extends State<FiltersBottomSheet> {
  String _sortBy = 'distance'; // distance, price, rating
  RangeValues _priceRange = const RangeValues(100, 400);
  String _selectedRating = '4.0'; // 4.5, 4.0, 3.0
  String _gender = 'female'; // male, female, all
  double _distance = 10.0; // 0 to 50 km

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
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
                  color: AppColors.greyLight,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Header with Title & Close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الفلاتر',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Cairo',
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.greyLight),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textPrimary, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const Divider(height: 32, color: AppColors.greyLight),

            // 1. Sort By ("ترتيب حسب")
            _buildSectionTitle('ترتيب حسب'),
            _buildRadioOption('المسافة', 'distance'),
            _buildRadioOption('السعر (من الأقل للأعلى)', 'price'),
            _buildRadioOption('الأعلى تقييماً', 'rating'),
            const SizedBox(height: 24),

            // 2. Price Range ("نطاق السعر")
            _buildSectionTitle('نطاق السعر'),
            RangeSlider(
              values: _priceRange,
              min: 50,
              max: 500,
              divisions: 9,
              activeColor: AppColors.primary,
              inactiveColor: AppColors.greyLight,
              labels: RangeLabels(
                '${_priceRange.start.round()} ج.م',
                '${_priceRange.end.round()} ج.م',
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
                  '${_priceRange.start.round()} ج.م',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
                Text(
                  '${_priceRange.end.round() == 500 ? '500+' : _priceRange.end.round()} ج.م',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 3. Rating ("التقييم")
            _buildSectionTitle('التقييم'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRatingChip('4.5+ ★', '4.5'),
                _buildRatingChip('4.0+ ★', '4.0'),
                _buildRatingChip('3.0+ ★', '3.0'),
              ],
            ),
            const SizedBox(height: 24),

            // 4. Gender ("الجنس")
            _buildSectionTitle('الجنس'),
            Container(
              decoration: BoxDecoration(
                color: AppColors.greyLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _buildGenderTab('ذكر', 'male'),
                  _buildGenderTab('أنثى', 'female'),
                  _buildGenderTab('الكل', 'all'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 5. Distance ("المسافة")
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle('المسافة'),
                Text(
                  '${_distance.round()} كم',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
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
              activeColor: AppColors.primary,
              inactiveColor: AppColors.greyLight,
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
                // Clear all link
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
                  child: const Text(
                    'مسح الكل',
                    style: TextStyle(
                      color: AppColors.textSecondary,
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
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        // Dismiss and apply filter results
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'تطبيق الفلاتر',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          fontFamily: 'Cairo',
        ),
      ),
    );
  }

  Widget _buildRadioOption(String label, String value) {
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
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                fontFamily: 'Cairo',
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingChip(String label, String value) {
    final isSelected = _selectedRating == value;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
      ),
      selected: isSelected,
      selectedColor: AppColors.primary,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.greyLight,
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

  Widget _buildGenderTab(String label, String value) {
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
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
