import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'privacy_event.dart';
part 'privacy_state.dart';

class PrivacyBloc extends Bloc<PrivacyEvent, PrivacyState> {
  PrivacyBloc() : super(const PrivacyState()) {
    on<ToggleLocationSharing>(_onToggleLocationSharing);
    on<ToggleDataUsage>(_onToggleDataUsage);
    on<ToggleMarketingSMS>(_onToggleMarketingSMS);
  }

  void _onToggleLocationSharing(ToggleLocationSharing event, Emitter<PrivacyState> emit) {
    emit(state.copyWith(isLocationSharingEnabled: event.isEnabled));
  }

  void _onToggleDataUsage(ToggleDataUsage event, Emitter<PrivacyState> emit) {
    emit(state.copyWith(isDataUsageEnabled: event.isEnabled));
  }

  void _onToggleMarketingSMS(ToggleMarketingSMS event, Emitter<PrivacyState> emit) {
    emit(state.copyWith(isMarketingSMSEnabled: event.isEnabled));
  }
}
