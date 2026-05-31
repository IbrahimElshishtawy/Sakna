import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl(this.localDataSource);

  @override
  Future<UserProfile> getUserProfile() async {
    return await localDataSource.getUserProfile();
  }

  @override
  Future<void> updateUserProfile(UserProfile profile) async {
    final model = UserProfileModel.fromEntity(profile);
    await localDataSource.saveUserProfile(model);
  }

  @override
  Future<void> logout() async {
    // In a production application, this would call authentication/logout APIs
    // and clear all local caches. For now, we clear the local cache and simulate delay.
    await Future.delayed(const Duration(milliseconds: 600));
    await localDataSource.clear();
  }
}
