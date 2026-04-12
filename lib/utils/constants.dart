import 'package:flutter/material.dart';

class AppConstants {
  // App Colors
  static const Color primaryColor = Color(0xFFFF3131);
  static const Color backgroundColor = Color(0xFF151515);
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color inputColor = Color(0xFF252525);

  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.white70;
  static const Color textMuted = Colors.white54;

  // App UI Constants
  static const double borderRadius = 20.0;
  static const double padding = 40.0;
  static const double maxWidth = 1400.0;

  // Movie Metadata Defaults
  static const String defaultCurrency = "Rp";
  static const String defaultAgeRating = "SU";
  static const int defaultTicketPrice = 60000;

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
}
