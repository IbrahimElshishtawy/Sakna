import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';
import '../../presentation/models/register_params.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, UserModel>> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.loginWithEmailAndPassword(
          email: email,
          password: password,
        );
        if (userModel.token != null) {
          await sharedPreferences.setString('auth_token', userModel.token!);
        }
        return Right(userModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on UnauthorizedException {
        return const Left(UnauthorizedFailure('اسم المستخدم أو كلمة المرور غير صحيحة'));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(OfflineFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, void>> register(RegisterParams params) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.register(params);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(OfflineFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, void>> sendOtp({
    required String phone,
    required String countryCode,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.sendOtp(phone: phone, countryCode: countryCode);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(OfflineFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final isVerified = await remoteDataSource.verifyOtp(phone: phone, code: code);
        return Right(isVerified);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(OfflineFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> loginWithGoogle() async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.loginWithGoogle();
        if (userModel.token != null) {
          await sharedPreferences.setString('auth_token', userModel.token!);
        }
        return Right(userModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(OfflineFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> loginWithApple() async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.loginWithApple();
        if (userModel.token != null) {
          await sharedPreferences.setString('auth_token', userModel.token!);
        }
        return Right(userModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(OfflineFailure('لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await sharedPreferences.remove('auth_token');
      return const Right(null);
    } catch (e) {
      // Even if API logout fails, clear local token
      await sharedPreferences.remove('auth_token');
      return const Right(null);
    }
  }
}
