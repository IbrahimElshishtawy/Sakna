import 'package:flutter/material.dart';

class OnboardingPageData {
  final String title;
  final String subtitle;
  final String imagePath;
  final String buttonText;
  final bool isMap; // To show different top layout for map

  OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.buttonText,
    this.isMap = false,
  });
}
