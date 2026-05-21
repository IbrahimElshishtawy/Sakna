import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../states/onboarding_state.dart';

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController() : super(const OnboardingState());

  void setPageIndex(int index) {
    state = state.copyWith(currentIndex: index);
  }

  void nextPage(int totalPages) {
    if (state.currentIndex < totalPages - 1) {
      state = state.copyWith(currentIndex: state.currentIndex + 1);
    }
  }
}
