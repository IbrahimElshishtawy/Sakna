import 'package:flutter/material.dart';
import 'service_sub_category.dart';

class ServiceCategory {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final List<ServiceSubCategory> subCategories;

  const ServiceCategory({
    required this.id,
    required this.title,
    required this.icon,
    required this.color,
    this.description = '',
    required this.subCategories,
  });
}
