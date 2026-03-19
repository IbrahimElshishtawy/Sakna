class KhidmaUser {
  final String id;
  final String name;
  final String role; // 'client' أو 'helper'
  final String city;
  final double rating;
  final String avatarUrl;
  final double? latitude;
  final double? longitude;
  final String subscriptionType; // 'basic', 'pro', 'premium'
  final double walletBalance;
  final List<String> badges;
  final String status; // 'online', 'offline'
  final String availability; // 'available', 'busy'

  KhidmaUser({
    required this.id,
    required this.name,
    required this.role,
    required this.city,
    required this.rating,
    required this.avatarUrl,
    this.latitude,
    this.longitude,
    this.subscriptionType = 'basic',
    this.walletBalance = 0.0,
    this.badges = const [],
    this.status = 'offline',
    this.availability = 'available',
  });
}
