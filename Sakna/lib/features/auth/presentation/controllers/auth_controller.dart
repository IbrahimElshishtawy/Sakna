import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/auth_providers.dart';
import '../states/auth_state.dart';

class AuthController extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState.initial();
  }

  Future<void> login(String phoneNumber) async {
    state = const AuthState.loading();
    try {
      final loginUseCase = ref.read(loginUseCaseProvider);
      await loginUseCase(phoneNumber);
      // Wait for OTP
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    try {
      final registerUseCase = ref.read(registerUserUseCaseProvider);
      await registerUseCase(
        name: name,
        phone: phone,
        email: email,
        password: password,
      );
      // Wait for OTP
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    state = const AuthState.loading();
    try {
      final verifyOtpUseCase = ref.read(verifyOtpUseCaseProvider);
      final user = await verifyOtpUseCase(phoneNumber, otp);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> completeProfile(UserEntity user) async {
    state = const AuthState.loading();
    try {
      final completeProfileUseCase = ref.read(completeProfileUseCaseProvider);
      final updatedUser = await completeProfileUseCase(user);
      state = AuthState.authenticated(updatedUser);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  void logout() {
    state = const AuthState.unauthenticated();
  }
}
