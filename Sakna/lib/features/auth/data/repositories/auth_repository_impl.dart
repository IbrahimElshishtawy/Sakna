import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<void> loginWithPhone(String phoneNumber) async {
    await remoteDataSource.loginWithPhone(phoneNumber);
  }

  @override
  Future<UserEntity> verifyOtp(String phoneNumber, String otp) async {
    final userModel = await remoteDataSource.verifyOtp(phoneNumber, otp);
    await localDataSource.cacheUser(userModel);
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> completeProfile(UserEntity user) async {
    final updatedUserModel = await remoteDataSource.completeProfile(user.toModel());
    await localDataSource.cacheUser(updatedUserModel);
    return updatedUserModel.toEntity();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final cachedUser = await localDataSource.getCachedUser();
    return cachedUser?.toEntity();
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearCache();
  }
}
