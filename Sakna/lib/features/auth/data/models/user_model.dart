import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String phone,
    String? name,
    String? email,
    String? gender,
    String? dateOfBirth,
    String? avatarUrl,
    @Default(true) bool offersEnabled,
    @Default(false) bool isProfileComplete,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      phone: phone,
      name: name,
      email: email,
      gender: gender,
      dateOfBirth: dateOfBirth,
      avatarUrl: avatarUrl,
      offersEnabled: offersEnabled,
      isProfileComplete: isProfileComplete,
    );
  }
}

extension UserEntityX on UserEntity {
  UserModel toModel() {
    return UserModel(
      id: id,
      phone: phone,
      name: name,
      email: email,
      gender: gender,
      dateOfBirth: dateOfBirth,
      avatarUrl: avatarUrl,
      offersEnabled: offersEnabled,
      isProfileComplete: isProfileComplete,
    );
  }
}
