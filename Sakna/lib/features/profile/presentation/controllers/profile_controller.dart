import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/profile_providers.dart';
import '../states/profile_state.dart';

class ProfileController extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    // Safely trigger initial asynchronous loading on next frame
    Future.microtask(() => loadProfile());
    return ProfileState.initial();
  }

  Future<void> loadProfile() async {
    try {
      state = state.copyWith(isLoading: true, errorMessage: null);
      final getProfileUseCase = ref.read(getProfileUseCaseProvider);
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
      final updateProfileUseCase = ref.read(updateProfileUseCaseProvider);
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
      final logoutUseCase = ref.read(logoutUseCaseProvider);
      await logoutUseCase();
      state = ProfileState.initial();
      // Reload to populate default profile mock values
      await loadProfile();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to log out: ${e.toString()}',
      );
    }
  }
}
