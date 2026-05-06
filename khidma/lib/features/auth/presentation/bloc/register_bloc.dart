import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  Timer? _otpTimer;

  RegisterBloc() : super(const RegisterState()) {
    on<RegisterBasicInfoUpdated>(_onBasicInfoUpdated);
    on<RegisterSecurityUpdated>(_onSecurityUpdated);
    on<RegisterOtpRequested>(_onOtpRequested);
    on<RegisterOtpUpdated>(_onOtpUpdated);
    on<RegisterOtpVerified>(_onOtpVerified);
    on<RegisterOtpTimerTick>(_onOtpTimerTick);
    on<RegisterFilePicked>(_onFilePicked);
    on<RegisterTermsToggled>(_onTermsToggled);
    on<RegisterNextStep>(_onNextStep);
    on<RegisterPreviousStep>(_onPreviousStep);
    on<RegisterSubmitted>(_onSubmitted);
  }

  // ─── Step 1: Basic Info ───────────────────────────────────────────

  void _onBasicInfoUpdated(
    RegisterBasicInfoUpdated event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(
      formData: state.formData.copyWith(
        name: event.name,
        email: event.email,
        phone: event.phone,
        countryCode: event.countryCode,
      ),
      fieldErrors: {},
    ));
  }

  // ─── Step 2: Security ─────────────────────────────────────────────

  void _onSecurityUpdated(
    RegisterSecurityUpdated event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(
      formData: state.formData.copyWith(
        password: event.password,
        confirmPassword: event.confirmPassword,
      ),
      fieldErrors: {},
    ));
  }

  // ─── Step 3: OTP ──────────────────────────────────────────────────

  Future<void> _onOtpRequested(
    RegisterOtpRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    // TODO: Call actual OTP API
    await Future.delayed(const Duration(seconds: 1));

    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = 60 - timer.tick;
      if (remaining <= 0) {
        timer.cancel();
        add(const RegisterOtpTimerTick(0));
      } else {
        add(RegisterOtpTimerTick(remaining));
      }
    });

    emit(state.copyWith(
      status: RegisterStatus.initial,
      otpSent: true,
      otpCountdown: 60,
    ));
  }

  void _onOtpUpdated(
    RegisterOtpUpdated event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(
      formData: state.formData.copyWith(otpCode: event.otpCode),
    ));
  }

  Future<void> _onOtpVerified(
    RegisterOtpVerified event,
    Emitter<RegisterState> emit,
  ) async {
    emit(state.copyWith(status: RegisterStatus.loading));

    // TODO: Verify OTP with API
    await Future.delayed(const Duration(seconds: 1));

    if (state.formData.otpCode.length == 6) {
      emit(state.copyWith(
        status: RegisterStatus.initial,
        otpVerified: true,
      ));
    } else {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: 'الرمز غير صحيح، أعد المحاولة',
      ));
    }
  }

  void _onOtpTimerTick(
    RegisterOtpTimerTick event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(otpCountdown: event.remainingSeconds));
  }

  // ─── Step 4: KYC ──────────────────────────────────────────────────

  Future<void> _onFilePicked(
    RegisterFilePicked event,
    Emitter<RegisterState> emit,
  ) async {
    // Simulate upload progress
    emit(state.copyWith(uploadProgress: 0));

    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 150));
      emit(state.copyWith(uploadProgress: i * 10.0));
    }

    if (event.isNationalId) {
      emit(state.copyWith(
        formData: state.formData.copyWith(nationalIdFile: event.file),
        uploadProgress: 100,
      ));
    } else {
      emit(state.copyWith(
        formData: state.formData.copyWith(selfieFile: event.file),
        uploadProgress: 100,
      ));
    }
  }

  void _onTermsToggled(
    RegisterTermsToggled event,
    Emitter<RegisterState> emit,
  ) {
    emit(state.copyWith(
      formData: state.formData.copyWith(
        agreedToTerms: !state.formData.agreedToTerms,
      ),
    ));
  }

  // ─── Navigation ───────────────────────────────────────────────────

  void _onNextStep(
    RegisterNextStep event,
    Emitter<RegisterState> emit,
  ) {
    final errors = _validateCurrentStep();
    if (errors.isNotEmpty) {
      emit(state.copyWith(
        fieldErrors: errors,
        status: RegisterStatus.failure,
        errorMessage: errors.values.first,
      ));
      return;
    }

    if (state.currentStep < 3) {
      emit(state.copyWith(
        currentStep: state.currentStep + 1,
        fieldErrors: {},
        status: RegisterStatus.initial,
        errorMessage: null,
      ));
    }
  }

  void _onPreviousStep(
    RegisterPreviousStep event,
    Emitter<RegisterState> emit,
  ) {
    if (state.currentStep > 0) {
      emit(state.copyWith(
        currentStep: state.currentStep - 1,
        fieldErrors: {},
        status: RegisterStatus.initial,
        errorMessage: null,
      ));
    }
  }

  // ─── Validation ───────────────────────────────────────────────────

  Map<String, String> _validateCurrentStep() {
    final data = state.formData;
    final errors = <String, String>{};

    switch (state.currentStep) {
      case 0: // Basic Info
        if (data.name.trim().isEmpty) {
          errors['name'] = 'الاسم مطلوب';
        }
        if (data.email.trim().isEmpty) {
          errors['email'] = 'البريد الإلكتروني مطلوب';
        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(data.email)) {
          errors['email'] = 'صيغة البريد غير صحيحة';
        }
        if (data.phone.trim().isEmpty) {
          errors['phone'] = 'رقم الهاتف مطلوب';
        }
        break;

      case 1: // Security
        if (data.password.isEmpty) {
          errors['password'] = 'كلمة المرور مطلوبة';
        } else if (data.password.length < 8) {
          errors['password'] = 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
        }
        if (data.confirmPassword.isEmpty) {
          errors['confirmPassword'] = 'تأكيد كلمة المرور مطلوب';
        } else if (data.password != data.confirmPassword) {
          errors['confirmPassword'] = 'كلمتا المرور غير متطابقتين';
        }
        break;

      case 2: // OTP
        if (data.otpCode.length != 6) {
          errors['otp'] = 'الرمز يجب أن يكون 6 أرقام';
        }
        break;

      case 3: // KYC
        if (data.nationalIdFile == null) {
          errors['nationalId'] = 'صورة الهوية مطلوبة';
        }
        if (data.selfieFile == null) {
          errors['selfie'] = 'الصورة الشخصية مطلوبة';
        }
        if (!data.agreedToTerms) {
          errors['terms'] = 'يجب الموافقة على الشروط والأحكام';
        }
        break;
    }
    return errors;
  }

  // ─── Final Submission ─────────────────────────────────────────────

  Future<void> _onSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    final errors = _validateCurrentStep();
    if (errors.isNotEmpty) {
      emit(state.copyWith(
        fieldErrors: errors,
        status: RegisterStatus.failure,
        errorMessage: errors.values.first,
      ));
      return;
    }

    emit(state.copyWith(status: RegisterStatus.loading));

    try {
      // TODO: Replace with actual API call using Dio Multipart
      // final formDataDio = FormData.fromMap({
      //   'name': state.formData.name,
      //   'email': state.formData.email,
      //   'phone': '${state.formData.countryCode}${state.formData.phone}',
      //   'password': state.formData.password,
      //   'otp_code': state.formData.otpCode,
      //   'national_id': await MultipartFile.fromFile(
      //     state.formData.nationalIdFile!.path,
      //     filename: 'national_id.jpg',
      //   ),
      //   'selfie': await MultipartFile.fromFile(
      //     state.formData.selfieFile!.path,
      //     filename: 'selfie.jpg',
      //   ),
      // });
      // await apiClient.post('/auth/register', data: formDataDio);

      await Future.delayed(const Duration(seconds: 2));

      emit(state.copyWith(status: RegisterStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: RegisterStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    _otpTimer?.cancel();
    return super.close();
  }
}
