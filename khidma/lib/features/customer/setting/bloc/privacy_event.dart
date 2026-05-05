part of 'privacy_bloc.dart';

abstract class PrivacyEvent extends Equatable {
  const PrivacyEvent();

  @override
  List<Object> get props => [];
}

class ToggleLocationSharing extends PrivacyEvent {
  final bool isEnabled;

  const ToggleLocationSharing(this.isEnabled);

  @override
  List<Object> get props => [isEnabled];
}

class ToggleDataUsage extends PrivacyEvent {
  final bool isEnabled;

  const ToggleDataUsage(this.isEnabled);

  @override
  List<Object> get props => [isEnabled];
}

class ToggleMarketingSMS extends PrivacyEvent {
  final bool isEnabled;

  const ToggleMarketingSMS(this.isEnabled);

  @override
  List<Object> get props => [isEnabled];
}
