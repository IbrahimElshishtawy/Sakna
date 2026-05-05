part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class ThemeChanged extends ThemeEvent {
  final ThemeMode themeMode;

  const ThemeChanged({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}

class TierChanged extends ThemeEvent {
  final UserTier tier;

  const TierChanged({required this.tier});

  @override
  List<Object> get props => [tier];
}
