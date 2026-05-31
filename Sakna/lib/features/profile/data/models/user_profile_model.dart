import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.name,
    required super.avatarUrl,
    required super.userType,
    required super.memberTier,
    required super.walletBalance,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      avatarUrl: json['avatarUrl'] as String? ?? '',
      userType: json['userType'] as String? ?? 'عميل',
      memberTier: json['memberTier'] as String? ?? 'بريميوم',
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'userType': userType,
      'memberTier': memberTier,
      'walletBalance': walletBalance,
    };
  }

  factory UserProfileModel.fromEntity(UserProfile entity) {
    return UserProfileModel(
      id: entity.id,
      name: entity.name,
      avatarUrl: entity.avatarUrl,
      userType: entity.userType,
      memberTier: entity.memberTier,
      walletBalance: entity.walletBalance,
    );
  }
}
