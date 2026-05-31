import '../../domain/entities/job_tracking.dart';
import '../../domain/entities/tracking_task.dart';
import '../../domain/repositories/live_tracking_repository.dart';

class LiveTrackingRepositoryImpl implements LiveTrackingRepository {
  @override
  Future<JobTracking> getLiveTrackingData(String bookingId) async {
    // Simulate minor network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return const JobTracking(
      id: 'active_booking_1',
      jobTitle: 'صيانة شبكة المياه الداخلية',
      unitNumber: '402',
      complexName: 'مجمع النخيل',
      elapsedTimeInSeconds: 6320, // 1 hour, 45 minutes, 20 seconds
      tasks: [
        TrackingTask(
          id: 'task_1',
          title: 'الفحص المبدئي وتحديد التسرب',
          description: 'تم الكشف عن موقع التسرب في الحمام الرئيسي.',
          status: TrackingTaskStatus.completed,
        ),
        TrackingTask(
          id: 'task_2',
          title: 'استبدال الأنابيب التالفة',
          description: 'جاري فك الأنابيب القديمة وتركيب الوصلات النحاسية الجديدة.',
          status: TrackingTaskStatus.inProgress,
        ),
        TrackingTask(
          id: 'task_3',
          title: 'اختبار الضغط والتنظيف',
          description: 'سيتم الاختبار بعد جفاف المواد اللاصقة.',
          status: TrackingTaskStatus.pending,
        ),
      ],
      liveImages: [
        'assets/images/plumbing_copper_pipes.png',
      ],
    );
  }
}
