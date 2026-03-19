import 'package:equatable/equatable.dart';
import '../../../../models/khidma_user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class UpdateProfileEvent extends UserEvent {
  final KhidmaUser user;

  const UpdateProfileEvent(this.user);

  @override
  List<Object?> get props => [user];
}

class ChangeSubscriptionEvent extends UserEvent {
  final String newTier;

  const ChangeSubscriptionEvent(this.newTier);

  @override
  List<Object?> get props => [newTier];
}

class ToggleThemeEvent extends UserEvent {}

class FetchUserStatsEvent extends UserEvent {}
