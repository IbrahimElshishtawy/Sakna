part of 'tracking_bloc.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object> get props => [];
}

class TrackingInitial extends TrackingState {}

class TrackingInProgress extends TrackingState {
  final double latitude;
  final double longitude;

  const TrackingInProgress({required this.latitude, required this.longitude});

  @override
  List<Object> get props => [latitude, longitude];
}

class TrackingStopped extends TrackingState {}
