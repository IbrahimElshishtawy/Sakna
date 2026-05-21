// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  phone: json['phone'] as String,
  name: json['name'] as String?,
  email: json['email'] as String?,
  gender: json['gender'] as String?,
  dateOfBirth: json['dateOfBirth'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  offersEnabled: json['offersEnabled'] as bool? ?? true,
  isProfileComplete: json['isProfileComplete'] as bool? ?? false,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'email': instance.email,
      'gender': instance.gender,
      'dateOfBirth': instance.dateOfBirth,
      'avatarUrl': instance.avatarUrl,
      'offersEnabled': instance.offersEnabled,
      'isProfileComplete': instance.isProfileComplete,
    };
