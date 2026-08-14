import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const blue900 = Color(0xFF0F1F3D);
  static const blue700 = Color(0xFF1A3A6E);
  static const blue500 = Color(0xFF2563EB);
  static const blue400 = Color(0xFF3B82F6);
  static const blue100 = Color(0xFFDBEAFE);
  static const blue50 = Color(0xFFEFF6FF);

  static const gray900 = Color(0xFF111827);
  static const gray600 = Color(0xFF4B5563);
  static const gray300 = Color(0xFFD1D5DB);
  static const gray100 = Color(0xFFF3F4F6);

  static const white = Color(0xFFFFFFFF);

  static const accent = Color(0xFF2826C9);

  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: blue900.withOpacity(0.08),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: blue900.withOpacity(0.06),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: blue900.withOpacity(0.12),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: blue900.withOpacity(0.08),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowLg = [
    BoxShadow(
      color: blue900.withOpacity(0.16),
      blurRadius: 32,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: blue900.withOpacity(0.10),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  static const radius = 14.0;
}
