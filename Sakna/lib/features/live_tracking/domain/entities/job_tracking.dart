import 'tracking_task.dart';

class JobTracking {
  final String id;
  final String jobTitle;
  final String unitNumber;
  final String complexName;
  final int elapsedTimeInSeconds;
  final List<TrackingTask> tasks;
  final List<String> liveImages;

  const JobTracking({
    required this.id,
    required this.jobTitle,
    required this.unitNumber,
    required this.complexName,
    required this.elapsedTimeInSeconds,
    required this.tasks,
    required this.liveImages,
  });

  JobTracking copyWith({
    String? id,
    String? jobTitle,
    String? unitNumber,
    String? complexName,
    int? elapsedTimeInSeconds,
    List<TrackingTask>? tasks,
    List<String>? liveImages,
  }) {
    return JobTracking(
      id: id ?? this.id,
      jobTitle: jobTitle ?? this.jobTitle,
      unitNumber: unitNumber ?? this.unitNumber,
      complexName: complexName ?? this.complexName,
      elapsedTimeInSeconds: elapsedTimeInSeconds ?? this.elapsedTimeInSeconds,
      tasks: tasks ?? this.tasks,
      liveImages: liveImages ?? this.liveImages,
    );
  }
}
