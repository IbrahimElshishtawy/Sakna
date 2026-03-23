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

  factory KhidmaUser.fromMap(Map<String, dynamic> map) {
    return KhidmaUser(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      role: map['role'] ?? 'client',
      city: map['city'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 5.0,
      avatarUrl: map['avatarUrl'] ?? '',
      latitude: map['location']?['coordinates']?[1]?.toDouble(),
      longitude: map['location']?['coordinates']?[0]?.toDouble(),
      subscriptionType: map['subscriptionType'] ?? 'basic',
      walletBalance: (map['walletBalance'] as num?)?.toDouble() ?? 0.0,
      badges: List<String>.from(map['badges'] ?? []),
      status: map['status'] ?? 'offline',
      availability: map['availability'] ?? 'available',
    );
  }
}
