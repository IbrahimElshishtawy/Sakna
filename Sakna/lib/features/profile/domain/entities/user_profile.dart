import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String avatarUrl;
  final String userType;
  final String memberTier;
  final double walletBalance;

  const UserProfile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.userType,
    required this.memberTier,
    required this.walletBalance,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? userType,
    String? memberTier,
    double? walletBalance,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      userType: userType ?? this.userType,
      memberTier: memberTier ?? this.memberTier,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        avatarUrl,
        userType,
        memberTier,
        walletBalance,
      ];
}
