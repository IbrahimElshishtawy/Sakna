import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../models/khidma_user.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<SocialAuthRequested>(_onSocialAuthRequested);
    on<OTPVerificationRequested>(_onOTPVerificationRequested);
  }

  void _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    // Simulate login
    await Future.delayed(const Duration(seconds: 1));
    emit(AuthAuthenticated(user: KhidmaUser(id: '1', name: 'Test User', email: 'test@example.com', role: 'customer', location: null, urgencyLevel: 'low')));
  }

  void _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) {
    emit(AuthUnauthenticated());
  }

  void _onSocialAuthRequested(SocialAuthRequested event, Emitter<AuthState> emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(seconds: 1));
      // Simulate requiring OTP after social login
      emit(AuthPartiallyAuthenticated(userId: 'temp_id', provider: event.provider));
  }

  void _onOTPVerificationRequested(OTPVerificationRequested event, Emitter<AuthState> emit) async {
      if (state is AuthPartiallyAuthenticated) {
          emit(AuthLoading());
          await Future.delayed(const Duration(seconds: 1));
          // Simulate OTP verification success
          emit(AuthAuthenticated(user: KhidmaUser(id: '1', name: 'Social User', email: 'social@example.com', role: 'customer', location: null, urgencyLevel: 'low')));
      }
  }
}
