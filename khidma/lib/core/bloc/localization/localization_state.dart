part of 'localization_bloc.dart';

class LocalizationState extends Equatable {
  final Locale locale;

  const LocalizationState({required this.locale});

  @override
  List<Object> get props => [locale];
}
