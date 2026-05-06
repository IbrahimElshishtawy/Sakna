import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/user_model.dart';
import '../../presentation/models/register_params.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> register(RegisterParams params);

  Future<Either<Failure, void>> sendOtp({
    required String phone,
    required String countryCode,
  });

  Future<Either<Failure, bool>> verifyOtp({
    required String phone,
    required String code,
  });

  Future<Either<Failure, UserModel>> loginWithGoogle();

  Future<Either<Failure, UserModel>> loginWithApple();

  Future<Either<Failure, void>> logout();
}
