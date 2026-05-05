part of 'tracking_bloc.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object> get props => [];
}

class StartTracking extends TrackingEvent {}

class UpdateLocation extends TrackingEvent {
  final double latitude;
  final double longitude;

  const UpdateLocation({required this.latitude, required this.longitude});

  @override
  List<Object> get props => [latitude, longitude];
}

class StopTracking extends TrackingEvent {}
