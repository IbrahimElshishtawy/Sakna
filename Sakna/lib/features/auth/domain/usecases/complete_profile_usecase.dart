import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class CompleteProfileUseCase {
  final AuthRepository repository;

  CompleteProfileUseCase(this.repository);

  Future<UserEntity> call(UserEntity user) async {
    return await repository.completeProfile(user);
  }
}
