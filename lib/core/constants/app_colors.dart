import 'package:flutter/material.dart';

/// RecycleX brand color palette
class AppColors {
  AppColors._();

  // Green color theme (Requirement 2)
  /// Primary green text and brand identity: #0A8037
  static const Color greenText = Color(0xFF0A8037);
  static const Color primary = Color(0xFF0A8037);

  /// Vibrant green for all buttons: #53F19D
  static const Color buttonGreen = Color(0xFF53F19D);
  static const Color buttonText = Color(0xFF0A8037);
  static const Color primaryLight = Color(0xFF53F19D);
  static const Color primaryLighter = Color(0xFFA5D6A7);

  // Accent / EcoCoin gold
  static const Color accent = Color(0xFFFFC107);

  // Backgrounds - Pure White across all screens (Requirement 1)
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFFFFFFFF);

  // Card / section backgrounds
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color sectionBg = Color(0xFFF8FBF8);
  static const Color border = Color(0xFFE5E7EB);

  // Text
  static const Color textPrimary = Color(0xFF1B1B1B);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnButton = Color(0xFF0A8037);

  // Status
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFFB8C00);
  static const Color error = Color(0xFFE53935);
  static const Color info = Color(0xFF1E88E5);

  // Role colours (Requirement 3: Kebele & Community collectors)
  static const Color customerRole = Color(0xFF1565C0);
  static const Color kebeleCollectorRole = Color(0xFF0A8037);
  static const Color communityCollectorRole = Color(0xFF00897B);
  static const Color collectorRole = Color(0xFF0A8037);
  static const Color companyRole = Color(0xFF6A1B9A);
  static const Color adminRole = Color(0xFFC62828);
}
