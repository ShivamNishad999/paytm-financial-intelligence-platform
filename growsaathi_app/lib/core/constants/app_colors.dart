import 'package:flutter/material.dart';

/// GrowSAATHI brand palette.
/// Source: product design brief — Paytm-inspired fintech SaaS look.
class AppColors {
  AppColors._();

  static const Color navy = Color(0xFF002970);
  static const Color brightBlue = Color(0xFF00BAF2);
  static const Color lightBlue = Color(0xFFEAF7FF);
  static const Color green = Color(0xFF18B968);
  static const Color purple = Color(0xFF7C4DFF);
  static const Color orange = Color(0xFFFF9F43);
  static const Color red = Color(0xFFE74C3C);
  static const Color background = Color(0xFFF7FBFF);

  static const Color surface = Colors.white;
  static const Color textPrimary = navy;
  static const Color textSecondary = Color(0xFF5C6B85);
  static const Color divider = Color(0xFFE3EEF9);

  /// Positive / negative trend colors used across KPI + insight widgets.
  static const Color positive = green;
  static const Color negative = red;

  /// AI / insight-flavoured surfaces.
  static const Color aiSurface = Color(0xFFF3EEFF);
  static const Color actionSurface = Color(0xFFFFF3E8);
}
