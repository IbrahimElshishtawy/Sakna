class TaskRequest {
  final String category;
  final String serviceType;
  final String description;
  final double hourlyPrice;
  final String location;
  final int hours; // عدد الساعات
  final bool isUrgent;
  final DateTime? scheduledAt;

  TaskRequest({
    required this.category,
    required this.serviceType,
    required this.description,
    required this.hourlyPrice,
    required this.location,
    required this.hours,
    this.isUrgent = false,
    this.scheduledAt,
  });
}
