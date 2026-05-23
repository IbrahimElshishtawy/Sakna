class OrderEntity {
  final String id;
  final String serviceType;
  final String description;
  final String arrivalTime;
  final double progress; // 0.0 to 1.0 representing shipping visual progress

  const OrderEntity({
    required this.id,
    required this.serviceType,
    required this.description,
    required this.arrivalTime,
    required this.progress,
  });

  OrderEntity copyWith({
    String? id,
    String? serviceType,
    String? description,
    String? arrivalTime,
    double? progress,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      serviceType: serviceType ?? this.serviceType,
      description: description ?? this.description,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      progress: progress ?? this.progress,
    );
  }
}
