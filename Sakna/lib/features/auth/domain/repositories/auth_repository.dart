import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> loginWithPhone(String phoneNumber);
  Future<UserEntity> verifyOtp(String phoneNumber, String otp);
  Future<UserEntity> completeProfile(UserEntity user);
  Future<UserEntity?> getCurrentUser();
  Future<void> logout();
}
