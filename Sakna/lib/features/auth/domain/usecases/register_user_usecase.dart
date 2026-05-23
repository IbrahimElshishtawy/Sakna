import '../repositories/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<void> call({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    return await repository.registerUser(
      name: name,
      phone: phone,
      email: email,
      password: password,
    );
  }
}
