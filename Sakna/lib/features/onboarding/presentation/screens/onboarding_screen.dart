import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/onboarding_providers.dart';
import '../widgets/onboarding_page_view.dart';
import '../../data/models/onboarding_page_data.dart';
import '../../../../config/theme/app_colors.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;
  
  final List<OnboardingPageData> pages = [
    OnboardingPageData(
      title: 'خدمات منزلية موثوقة',
      subtitle: 'من السباكة والكهرباء إلى النظافة، نوفر لك الأفضل دائماً.',
      imagePath: 'assets/images/onboarding_1.png',
      buttonText: 'التالي',
    ),
    OnboardingPageData(
      title: 'تتبع لحظي لمقدم الخدمة',
      subtitle: 'تابع الفني الخاص بك على الخريطة مباشرة حتى وصوله لباب منزلك.',
      imagePath: 'assets/images/onboarding_2.png',
      buttonText: 'التالي',
      isMap: true,
    ),
    OnboardingPageData(
      title: 'أمان تام ومدفوعات سهلة',
      subtitle: 'نضمن لك أعلى مستويات الأمان مع خيارات دفع محلية متنوعة.',
      imagePath: 'assets/images/onboarding_3.png',
      buttonText: 'ابدأ الآن',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    final currentIndex = ref.read(onboardingControllerProvider).currentIndex;
    if (currentIndex < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _onSkip() {
    _finishOnboarding();
  }

  void _finishOnboarding() {
    // Navigate to Auth or Home screen using GoRouter
    // context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(onboardingControllerProvider).currentIndex;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: PageView.builder(
          controller: _pageController,
          itemCount: pages.length,
          onPageChanged: (index) {
            ref.read(onboardingControllerProvider.notifier).setPageIndex(index);
          },
          itemBuilder: (context, index) {
            return OnboardingPageView(
              pageData: pages[index],
              currentIndex: currentIndex,
              totalPages: pages.length,
              onNext: _onNext,
              onSkip: _onSkip,
            );
          },
        ),
      ),
    );
  }
}
