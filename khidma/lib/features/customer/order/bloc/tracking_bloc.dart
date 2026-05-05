import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'tracking_event.dart';
part 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  StreamSubscription<Map<String, double>>? _locationSubscription;

  TrackingBloc() : super(TrackingInitial()) {
    on<StartTracking>(_onStartTracking);
    on<UpdateLocation>(_onUpdateLocation);
    on<StopTracking>(_onStopTracking);
  }

  void _onStartTracking(StartTracking event, Emitter<TrackingState> emit) {
    _locationSubscription?.cancel();
    emit(TrackingInProgress(latitude: 0.0, longitude: 0.0));

    // Simulated stream of coordinates
    _locationSubscription = Stream.periodic(const Duration(seconds: 2), (count) {
      return {'lat': 30.0 + (count * 0.001), 'lng': 31.0 + (count * 0.001)};
    }).listen((location) {
      add(UpdateLocation(latitude: location['lat']!, longitude: location['lng']!));
    });
  }

  void _onUpdateLocation(UpdateLocation event, Emitter<TrackingState> emit) {
    emit(TrackingInProgress(latitude: event.latitude, longitude: event.longitude));
  }

  void _onStopTracking(StopTracking event, Emitter<TrackingState> emit) {
    _locationSubscription?.cancel();
    emit(TrackingStopped());
  }

  @override
  Future<void> close() {
    _locationSubscription?.cancel();
    return super.close();
  }
}
