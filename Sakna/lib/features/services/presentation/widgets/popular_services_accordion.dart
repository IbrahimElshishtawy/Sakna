import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class PopularServicesAccordion extends StatefulWidget {
  final Function(String categoryId, String subCategoryId) onSubCategoryTap;

  const PopularServicesAccordion({
    super.key,
    required this.onSubCategoryTap,
  });

  @override
  State<PopularServicesAccordion> createState() => _PopularServicesAccordionState();
}

class _PopularServicesAccordionState extends State<PopularServicesAccordion> {
  bool _maintenanceExpanded = true;
  bool _medicalExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'خدمات شائعة لك',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: 'Cairo',
          ),
        ),
        const SizedBox(height: 12),

        // Accordion 1: صيانة عامة
        _buildAccordionHeader(
          title: 'صيانة عامة',
          icon: Icons.plumbing_rounded,
          isExpanded: _maintenanceExpanded,
          onToggle: () {
            setState(() {
              _maintenanceExpanded = !_maintenanceExpanded;
            });
          },
        ),
        _buildAccordionContent(
          isExpanded: _maintenanceExpanded,
          chips: [
            {'label': 'كهرباء', 'id': 'electricity', 'catId': 'maintenance', 'color': Colors.blue},
            {'label': 'سباكة', 'id': 'plumbing', 'catId': 'maintenance', 'color': Colors.orange},
            {'label': 'تكييف', 'id': 'ac_cooling', 'catId': 'maintenance', 'color': Colors.cyan},
            {'label': 'أجهزة', 'id': 'appliances', 'catId': 'maintenance', 'color': Colors.green},
          ],
        ),

        const SizedBox(height: 12),

        // Accordion 2: رعاية صحية منزلية
        _buildAccordionHeader(
          title: 'رعاية صحية منزلية',
          icon: Icons.medical_services_rounded,
          isExpanded: _medicalExpanded,
          onToggle: () {
            setState(() {
              _medicalExpanded = !_medicalExpanded;
            });
          },
        ),
        _buildAccordionContent(
          isExpanded: _medicalExpanded,
          chips: [
            {'label': 'تمريض', 'id': 'nursing', 'catId': 'medical', 'color': Colors.red},
            {'label': 'علاج طبيعي', 'id': 'physio', 'catId': 'medical', 'color': Colors.purple},
            {'label': 'تحاليل', 'id': 'nursing', 'catId': 'medical', 'color': Colors.indigo}, // Map to nursing or visits for demo
            {'label': 'زيارة طبيب', 'id': 'physio', 'catId': 'medical', 'color': Colors.teal},
          ],
        ),
      ],
    );
  }

  Widget _buildAccordionHeader({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isExpanded ? AppColors.accent.withValues(alpha: 0.3) : AppColors.greyLight,
          width: 1,
        ),
      ),
      child: ListTile(
        onTap: onToggle,
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: 'Cairo',
          ),
        ),
        trailing: AnimatedRotation(
          turns: isExpanded ? 0.5 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
        ),
      ),
    );
  }

  Widget _buildAccordionContent({
    required bool isExpanded,
    required List<Map<String, dynamic>> chips,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: isExpanded ? 72 : 0,
      child: isExpanded
          ? SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 4.0, right: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: chips.map((chip) {
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ActionChip(
                          onPressed: () => widget.onSubCategoryTap(chip['catId'], chip['id']),
                          backgroundColor: Colors.grey.shade50,
                          elevation: 0,
                          side: BorderSide(color: Colors.grey.shade200, width: 1),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          label: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor: chip['color'],
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  chip['label'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
