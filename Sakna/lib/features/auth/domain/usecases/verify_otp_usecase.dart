import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<UserEntity> call(String phoneNumber, String otp) async {
    return await repository.verifyOtp(phoneNumber, otp);
  }
}
