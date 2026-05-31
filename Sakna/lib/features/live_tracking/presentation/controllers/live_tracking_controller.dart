import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_live_tracking_usecase.dart';
import '../providers/live_tracking_providers.dart';
import '../states/live_tracking_state.dart';

class LiveTrackingController extends Notifier<LiveTrackingState> {
  Timer? _timer;

  @override
  LiveTrackingState build() {
    // Clean up timer when notifier is disposed
    ref.onDispose(() {
      _timer?.cancel();
    });

    // Automatically load data on init
    Future.microtask(() => fetchTrackingData('active_booking_1'));

    return const LiveTrackingState(isLoading: true);
  }

  Future<void> fetchTrackingData(String bookingId) async {
    _timer?.cancel();
    state = state.copyWith(isLoading: true);
    
    try {
      final getLiveTrackingUseCase = ref.read(getLiveTrackingUseCaseProvider);
      final jobTracking = await getLiveTrackingUseCase(bookingId);
      state = LiveTrackingState(jobTracking: jobTracking, isLoading: false);
      
      // Start real-time ticking timer
      _startTimer();
    } catch (e) {
      state = LiveTrackingState(
        jobTracking: state.jobTracking,
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final job = state.jobTracking;
      if (job != null) {
        state = state.copyWith(
          jobTracking: job.copyWith(
            elapsedTimeInSeconds: job.elapsedTimeInSeconds + 1,
          ),
        );
      }
    });
  }
}

final liveTrackingControllerProvider =
    NotifierProvider<LiveTrackingController, LiveTrackingState>(LiveTrackingController.new);
