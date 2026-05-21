import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_page_data.freezed.dart';

@freezed
abstract class OnboardingPageData with _$OnboardingPageData {
  const factory OnboardingPageData({
    required String title,
    required String subtitle,
    required String imagePath,
    required String buttonText,
    @Default(false) bool isMap, // To show different top layout for map
  }) = _OnboardingPageData;
}
