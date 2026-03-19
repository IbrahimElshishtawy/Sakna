import 'package:equatable/equatable.dart';
import '../../../../models/khidma_user.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserProfileLoaded extends UserState {
  final KhidmaUser user;
  final bool isDarkMode;
  final String currentLocale;

  const UserProfileLoaded({
    required this.user,
    this.isDarkMode = false,
    this.currentLocale = 'ar',
  });

  @override
  List<Object?> get props => [user, isDarkMode, currentLocale];

  UserProfileLoaded copyWith({
    KhidmaUser? user,
    bool? isDarkMode,
    String? currentLocale,
  }) {
    return UserProfileLoaded(
      user: user ?? this.user,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      currentLocale: currentLocale ?? this.currentLocale,
    );
  }
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}
