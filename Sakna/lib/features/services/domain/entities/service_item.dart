import 'package:flutter/material.dart';

class ServiceItem {
  final String id;
  final String name;
  final String description;
  final IconData? icon;
  final String priceEstimate;
  final String? duration;
  final bool isEmergency;
  
  // Real Estate specific fields
  final int? rooms;
  final double? area;
  final List<String>? images;
  final bool? has360View;
  final bool? hasVideo;
  final List<String>? facilities;
  final String? type; // "rent" | "sale" | "commercial"

  const ServiceItem({
    required this.id,
    required this.name,
    this.description = '',
    this.icon,
    this.priceEstimate = 'حسب المعاينة',
    this.duration,
    this.isEmergency = false,
    this.rooms,
    this.area,
    this.images,
    this.has360View,
    this.hasVideo,
    this.facilities,
    this.type,
  });
}
