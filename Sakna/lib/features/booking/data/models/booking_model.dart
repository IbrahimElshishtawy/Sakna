import '../../domain/entities/booking.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.serviceName,
    required super.providerName,
    required super.dateTime,
    required super.price,
    required super.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      serviceName: json['serviceName'] as String,
      providerName: json['providerName'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      price: (json['price'] as num).toDouble(),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.active,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': serviceName,
      'providerName': providerName,
      'dateTime': dateTime.toIso8601String(),
      'price': price,
      'status': status.name,
    };
  }
}
