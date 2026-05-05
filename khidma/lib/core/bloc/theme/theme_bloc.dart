import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.system, tier: UserTier.standard)) {
    on<ThemeChanged>(_onThemeChanged);
    on<TierChanged>(_onTierChanged);
  }

  void _onThemeChanged(ThemeChanged event, Emitter<ThemeState> emit) {
    emit(state.copyWith(themeMode: event.themeMode));
  }

  void _onTierChanged(TierChanged event, Emitter<ThemeState> emit) {
    emit(state.copyWith(tier: event.tier));
  }
}
