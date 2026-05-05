import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'localization_event.dart';
part 'localization_state.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc() : super(const LocalizationState(locale: Locale('en', 'US'))) {
    on<LanguageChanged>(_onLanguageChanged);
  }

  void _onLanguageChanged(LanguageChanged event, Emitter<LocalizationState> emit) {
    emit(LocalizationState(locale: event.locale));
  }
}
