part of 'localization_bloc.dart';

abstract class LocalizationEvent extends Equatable {
  const LocalizationEvent();

  @override
  List<Object> get props => [];
}

class LanguageChanged extends LocalizationEvent {
  final Locale locale;

  const LanguageChanged({required this.locale});

  @override
  List<Object> get props => [locale];
}
