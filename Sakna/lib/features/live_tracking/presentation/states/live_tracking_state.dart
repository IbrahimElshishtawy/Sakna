import '../../domain/entities/job_tracking.dart';

class LiveTrackingState {
  final JobTracking? jobTracking;
  final bool isLoading;
  final String? errorMessage;

  const LiveTrackingState({
    this.jobTracking,
    this.isLoading = false,
    this.errorMessage,
  });

  LiveTrackingState copyWith({
    JobTracking? jobTracking,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LiveTrackingState(
      jobTracking: jobTracking ?? this.jobTracking,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
