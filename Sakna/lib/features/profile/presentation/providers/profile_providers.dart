import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/datasources/profile_local_data_source.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../controllers/profile_controller.dart';
import '../states/profile_state.dart';

// --- Data Sources ---
final profileLocalDataSourceProvider = Provider<ProfileLocalDataSource>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return ProfileLocalDataSourceImpl(sharedPrefs);
});

// --- Repositories ---
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final localDataSource = ref.watch(profileLocalDataSourceProvider);
  return ProfileRepositoryImpl(localDataSource);
});

// --- Use Cases ---
final getProfileUseCaseProvider = Provider<GetProfileUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return GetProfileUseCase(repository);
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return UpdateProfileUseCase(repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return LogoutUseCase(repository);
});

// --- Controller ---
final profileControllerProvider =
    StateNotifierProvider<ProfileController, ProfileState>((ref) {
  final getProfile = ref.watch(getProfileUseCaseProvider);
  final updateProfile = ref.watch(updateProfileUseCaseProvider);
  final logout = ref.watch(logoutUseCaseProvider);

  return ProfileController(
    getProfileUseCase: getProfile,
    updateProfileUseCase: updateProfile,
    logoutUseCase: logout,
  );
});
