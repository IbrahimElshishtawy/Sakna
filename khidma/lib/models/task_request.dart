class TaskRequest {
  final String category;
  final String serviceType;
  final String description;
  final double hourlyPrice;
  final String location;
  final int hours; // عدد الساعات
  final bool isUrgent;
  final DateTime? scheduledAt;
  final double latitude;
  final double longitude;

  TaskRequest({
    required this.category,
    required this.serviceType,
    required this.description,
    required this.hourlyPrice,
    required this.location,
    required this.hours,
    this.isUrgent = false,
    this.scheduledAt,
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  Map<String, dynamic> toJson() => {
    'category': category,
    'serviceType': serviceType,
    'description': description,
    'hourlyPrice': hourlyPrice,
    'address': location,
    'hours': hours,
    'isUrgent': isUrgent,
    'scheduledAt': scheduledAt?.toIso8601String(),
    'lat': latitude,
    'lng': longitude,
  };
}
