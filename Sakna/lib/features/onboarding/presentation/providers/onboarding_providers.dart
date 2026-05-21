import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/onboarding_controller.dart';
import '../states/onboarding_state.dart';

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingState>(OnboardingController.new);
