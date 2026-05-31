import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile.dart';

class ProfileState extends Equatable {
  final bool isLoading;
  final UserProfile? userProfile;
  final String? errorMessage;

  const ProfileState({
    required this.isLoading,
    this.userProfile,
    this.errorMessage,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      isLoading: true,
      userProfile: null,
      errorMessage: null,
    );
  }

  ProfileState copyWith({
    bool? isLoading,
    UserProfile? userProfile,
    String? errorMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      userProfile: userProfile ?? this.userProfile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, userProfile, errorMessage];
}
