import 'package:flutter/material.dart';
import 'service_item.dart';

class ServiceSubCategory {
  final String id;
  final String title;
  final IconData? icon;
  final List<ServiceItem> items;

  const ServiceSubCategory({
    required this.id,
    required this.title,
    this.icon,
    required this.items,
  });
}
