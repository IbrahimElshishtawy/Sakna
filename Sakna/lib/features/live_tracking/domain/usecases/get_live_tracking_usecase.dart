import '../entities/job_tracking.dart';
import '../repositories/live_tracking_repository.dart';

class GetLiveTrackingUseCase {
  final LiveTrackingRepository _repository;

  const GetLiveTrackingUseCase(this._repository);

  Future<JobTracking> call(String bookingId) async {
    return _repository.getLiveTrackingData(bookingId);
  }
}
