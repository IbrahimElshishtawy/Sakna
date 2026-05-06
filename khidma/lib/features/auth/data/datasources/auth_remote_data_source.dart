import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';
import '../../presentation/models/register_params.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> register(RegisterParams params);

  Future<void> sendOtp({
    required String phone,
    required String countryCode,
  });

  Future<bool> verifyOtp({
    required String phone,
    required String code,
  });

  Future<UserModel> loginWithGoogle();

  Future<UserModel> loginWithApple();

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        'auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException('فشل تسجيل الدخول. يرجى المحاولة مرة أخرى.');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'فشل الاتصال بالخادم');
    }
  }

  @override
  Future<void> register(RegisterParams params) async {
    try {
      final formDataMap = <String, dynamic>{
        'name': params.name,
        'email': params.email,
        'phone': '${params.countryCode}${params.phone}',
        'password': params.password,
        'otp_code': params.otpCode,
      };

      if (params.nationalIdFile != null) {
        formDataMap['national_id'] = await MultipartFile.fromFile(
          params.nationalIdFile!.path,
          filename: params.nationalIdFile!.path.split('/').last,
        );
      }

      if (params.selfieFile != null) {
        formDataMap['selfie'] = await MultipartFile.fromFile(
          params.selfieFile!.path,
          filename: params.selfieFile!.path.split('/').last,
        );
      }

      final formData = FormData.fromMap(formDataMap);

      final response = await apiClient.post(
        'auth/register',
        data: formData,
      );

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw ServerException('فشل إنشاء الحساب. يرجى التحقق من البيانات.');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'فشل إرسال بيانات التسجيل');
    }
  }

  @override
  Future<void> sendOtp({
    required String phone,
    required String countryCode,
  }) async {
    try {
      final response = await apiClient.post(
        'auth/send-otp',
        data: {
          'phone': phone,
          'country_code': countryCode,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException('فشل إرسال رمز التحقق');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'فشل الاتصال بالخادم لإرسال الرمز');
    }
  }

  @override
  Future<bool> verifyOtp({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await apiClient.post(
        'auth/verify-otp',
        data: {
          'phone': phone,
          'code': code,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        return data['verified'] as bool? ?? false;
      }
      return false;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'فشل التحقق من الرمز');
    }
  }

  @override
  Future<UserModel> loginWithGoogle() async {
    // Simulated Google login. In production, integrate google_sign_in package
    await Future.delayed(const Duration(seconds: 1));
    return const UserModel(
      id: 'google-123',
      name: 'مستخدم جوجل',
      email: 'google@khidmahub.com',
      phone: '',
      role: 'client',
      token: 'mock-google-token',
    );
  }

  @override
  Future<UserModel> loginWithApple() async {
    // Simulated Apple login. In production, integrate sign_in_with_apple package
    await Future.delayed(const Duration(seconds: 1));
    return const UserModel(
      id: 'apple-123',
      name: 'مستخدم آبل',
      email: 'apple@khidmahub.com',
      phone: '',
      role: 'client',
      token: 'mock-apple-token',
    );
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.post('auth/logout');
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'فشل تسجيل الخروج من الخادم');
    }
  }
}
