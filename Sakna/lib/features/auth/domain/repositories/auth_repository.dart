import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> loginWithPhone(String phoneNumber);
  Future<UserEntity> verifyOtp(String phoneNumber, String otp);
  Future<UserEntity> completeProfile(UserEntity user);
  Future<void> registerUser({
    required String name,
    required String phone,
    required String email,
    required String password,
  });
  Future<UserEntity?> getCurrentUser();
  Future<void> logout();
}
