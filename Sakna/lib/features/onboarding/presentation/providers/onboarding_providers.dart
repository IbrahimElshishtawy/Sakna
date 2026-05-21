import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/onboarding_controller.dart';
import '../states/onboarding_state.dart';

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>((ref) {
  return OnboardingController();
});
