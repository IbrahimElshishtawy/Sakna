part of 'theme_bloc.dart';

enum UserTier { standard, premium, vip }

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final UserTier tier;

  const ThemeState({required this.themeMode, required this.tier});

  ThemeState copyWith({
    ThemeMode? themeMode,
    UserTier? tier,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      tier: tier ?? this.tier,
    );
  }

  ThemeData get themeData {
    // Generate different themes based on tier
    switch (tier) {
      case UserTier.vip:
        return ThemeData(primarySwatch: Colors.amber, brightness: themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light);
      case UserTier.premium:
        return ThemeData(primarySwatch: Colors.purple, brightness: themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light);
      case UserTier.standard:
      default:
        return ThemeData(primarySwatch: Colors.blue, brightness: themeMode == ThemeMode.dark ? Brightness.dark : Brightness.light);
    }
  }

  @override
  List<Object> get props => [themeMode, tier];
}
