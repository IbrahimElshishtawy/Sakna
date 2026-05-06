import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final SharedPreferences sharedPreferences;

  AuthBloc({
    required this.authRepository,
    required this.sharedPreferences,
  }) : super(const AuthInitial()) {
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthGoogleLoginRequested>(_onGoogleLoginRequested);
    on<AuthAppleLoginRequested>(_onAppleLoginRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthCheckRequested>(_onCheckRequested);
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    if (event.email.isEmpty || event.password.isEmpty) {
      emit(const AuthFailure(message: 'البريد الإلكتروني وكلمة المرور مطلوبان'));
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(event.email)) {
      emit(const AuthFailure(message: 'صيغة البريد الإلكتروني غير صحيحة'));
      return;
    }

    final result = await authRepository.loginWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(AuthSuccess(
        userId: user.id,
        displayName: user.name,
      )),
    );
  }

  Future<void> _onGoogleLoginRequested(
    AuthGoogleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await authRepository.loginWithGoogle();

    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(AuthSuccess(
        userId: user.id,
        displayName: user.name,
      )),
    );
  }

  Future<void> _onAppleLoginRequested(
    AuthAppleLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await authRepository.loginWithApple();

    result.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => emit(AuthSuccess(
        userId: user.id,
        displayName: user.name,
      )),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await authRepository.logout();
    emit(const AuthUnauthenticated());
  }

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final token = sharedPreferences.getString('auth_token');
    if (token != null && token.isNotEmpty) {
      // In production, you might want to call an API to verify the token is still valid.
      emit(const AuthSuccess(
        userId: 'stored_user',
        displayName: 'مرحباً بك مجدداً',
      ));
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}
