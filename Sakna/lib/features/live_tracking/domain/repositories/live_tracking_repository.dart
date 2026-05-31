import '../entities/job_tracking.dart';

abstract class LiveTrackingRepository {
  Future<JobTracking> getLiveTrackingData(String bookingId);
}
