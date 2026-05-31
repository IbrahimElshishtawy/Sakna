enum BookingStatus {
  active,
  completed,
  cancelled
}

class Booking {
  final String id;
  final String serviceName;
  final String providerName;
  final DateTime dateTime;
  final double price;
  final BookingStatus status;

  const Booking({
    required this.id,
    required this.serviceName,
    required this.providerName,
    required this.dateTime,
    required this.price,
    required this.status,
  });
}
