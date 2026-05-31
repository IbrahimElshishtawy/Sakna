import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../states/profile_state.dart';

class ProfileController extends StateNotifier<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final LogoutUseCase logoutUseCase;

  ProfileController({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
    required this.logoutUseCase,
  }) : super(ProfileState.initial()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final profile = await getProfileUseCase();
      state = state.copyWith(isLoading: false, userProfile: profile);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load profile: ${e.toString()}',
      );
    }
  }

  Future<void> updateProfileName(String newName) async {
    final currentProfile = state.userProfile;
    if (currentProfile == null) return;

    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final updatedProfile = currentProfile.copyWith(name: newName);
      await updateProfileUseCase(updatedProfile);
      state = state.copyWith(isLoading: false, userProfile: updatedProfile);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to update profile: ${e.toString()}',
      );
    }
  }

  Future<void> logout() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      await logoutUseCase();
      state = ProfileState.initial();
      // After logout, reload to populate the default mock profile
      await loadProfile();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to log out: ${e.toString()}',
      );
    }
  }
}
