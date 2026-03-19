class Order {
  final String id;
  final String title;
  final String location;
  final DateTime dateTime;
  final double price;
  final String status; // 'pending', 'matched', 'in_progress', 'completed'
  final bool isUrgent;
  final List<String> progressPhotos;
  final String? clientId;
  final String? helperId;

  Order({
    required this.id,
    required this.title,
    required this.location,
    required this.dateTime,
    required this.price,
    required this.status,
    this.isUrgent = false,
    this.progressPhotos = const [],
    this.clientId,
    this.helperId,
  });
}
