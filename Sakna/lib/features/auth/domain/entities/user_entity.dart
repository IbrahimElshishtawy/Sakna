import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

@freezed
abstract class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String phone,
    String? name,
    String? email,
    String? gender,
    String? dateOfBirth,
    String? avatarUrl,
    @Default(true) bool offersEnabled,
    @Default(false) bool isProfileComplete,
  }) = _UserEntity;
}
