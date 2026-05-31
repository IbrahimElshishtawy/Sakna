enum TrackingTaskStatus {
  completed,
  inProgress,
  pending
}

class TrackingTask {
  final String id;
  final String title;
  final String description;
  final TrackingTaskStatus status;

  const TrackingTask({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });
}
