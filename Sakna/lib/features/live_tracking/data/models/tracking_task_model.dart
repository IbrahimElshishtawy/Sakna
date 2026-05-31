import '../../domain/entities/tracking_task.dart';

class TrackingTaskModel extends TrackingTask {
  const TrackingTaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.status,
  });

  factory TrackingTaskModel.fromJson(Map<String, dynamic> json) {
    return TrackingTaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      status: TrackingTaskStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => TrackingTaskStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.name,
    };
  }
}
