import 'package:flutter/material.dart';
import '../../data/models/onboarding_page_data.dart';
import '../../../../config/theme/app_colors.dart';
import 'onboarding_progress_dots.dart';

class OnboardingPageView extends StatelessWidget {
  final OnboardingPageData pageData;
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const OnboardingPageView({
    super.key,
    required this.pageData,
    required this.currentIndex,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Top Section (Image or Map)
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.6,
          child: _buildTopSection(context),
        ),

        // Skip Button for specific pages (like Map or 3rd page)
        if (pageData.isMap || currentIndex == 2)
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: currentIndex == 2
                ? IconButton(
                    icon: const Icon(Icons.arrow_forward, color: AppColors.primary), // RTL back arrow
                    onPressed: () {},
                  )
                : TextButton(
                    onPressed: onSkip,
                    child: const Text(
                      'تخطي',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
          ),

        // Bottom Section (White Container)
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(32.0),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle for 3rd page
                if (currentIndex == 2)
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: AppColors.greyLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  )
                else
                  const SizedBox(height: 16),

                // Dots for page 1
                if (currentIndex == 0) ...[
                  OnboardingProgressDots(
                    currentIndex: currentIndex,
                    totalPages: totalPages,
                  ),
                  const SizedBox(height: 24),
                ],

                // Title
                Text(
                  pageData.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Subtitle
                Text(
                  pageData.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),

                // Dots for page 2 and 3
                if (currentIndex == 1 || currentIndex == 2) ...[
                  OnboardingProgressDots(
                    currentIndex: currentIndex,
                    totalPages: totalPages,
                  ),
                  const SizedBox(height: 32),
                ],

                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_back, color: AppColors.white, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          pageData.buttonText,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Skip text at bottom for page 1
                if (currentIndex == 0) ...[
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: onSkip,
                    child: const Text(
                      'تخطي',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopSection(BuildContext context) {
    if (pageData.isMap) {
      // Map representation (normally Google Maps widget, here we use a placeholder image)
      return Container(
        color: const Color(0xFFF0F4F8), // Light map background
        child: Image.asset(
          pageData.imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              const Center(child: Icon(Icons.map, size: 64, color: AppColors.greyLight)),
        ),
      );
    } else {
      // Regular image
      return Image.asset(
        pageData.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.background,
          child: const Center(child: Icon(Icons.image, size: 64, color: AppColors.greyLight)),
        ),
      );
    }
  }
}
