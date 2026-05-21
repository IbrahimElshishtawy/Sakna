import 'package:dio/dio.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> loginWithPhone(String phoneNumber);
  Future<UserModel> verifyOtp(String phoneNumber, String otp);
  Future<UserModel> completeProfile(UserModel user);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<void> loginWithPhone(String phoneNumber) async {
    // Implement actual API call here
    // await dio.post('/auth/login', data: {'phone': phoneNumber});
    await Future.delayed(const Duration(seconds: 1)); // Mock delay
  }

  @override
  Future<UserModel> verifyOtp(String phoneNumber, String otp) async {
    // Implement actual API call here
    await Future.delayed(const Duration(seconds: 1)); // Mock delay
    return UserModel(id: '123', phone: phoneNumber);
  }

  @override
  Future<UserModel> completeProfile(UserModel user) async {
    // Implement actual API call here
    await Future.delayed(const Duration(seconds: 1)); // Mock delay
    return user.copyWith(isProfileComplete: true);
  }
}
