import '../../domain/entities/job_tracking.dart';
import 'tracking_task_model.dart';

class JobTrackingModel extends JobTracking {
  const JobTrackingModel({
    required super.id,
    required super.jobTitle,
    required super.unitNumber,
    required super.complexName,
    required super.elapsedTimeInSeconds,
    required super.tasks,
    required super.liveImages,
  });

  factory JobTrackingModel.fromJson(Map<String, dynamic> json) {
    final tasksList = (json['tasks'] as List)
        .map((t) => TrackingTaskModel.fromJson(t as Map<String, dynamic>))
        .toList();

    return JobTrackingModel(
      id: json['id'] as String,
      jobTitle: json['jobTitle'] as String,
      unitNumber: json['unitNumber'] as String,
      complexName: json['complexName'] as String,
      elapsedTimeInSeconds: json['elapsedTimeInSeconds'] as int,
      tasks: tasksList,
      liveImages: List<String>.from(json['liveImages'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    final tasksJson = tasks.map((t) {
      if (t is TrackingTaskModel) return t.toJson();
      return TrackingTaskModel(
        id: t.id,
        title: t.title,
        description: t.description,
        status: t.status,
      ).toJson();
    }).toList();

    return {
      'id': id,
      'jobTitle': jobTitle,
      'unitNumber': unitNumber,
      'complexName': complexName,
      'elapsedTimeInSeconds': elapsedTimeInSeconds,
      'tasks': tasksJson,
      'liveImages': liveImages,
    };
  }
}
