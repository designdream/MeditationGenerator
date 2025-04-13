import 'package:flutter/material.dart';

/// App color palette based on the UI mockups description
class AppColors {
  // Primary Colors
  static const Color primaryDeepIndigo = Color(0xFF3D3A7C);
  static const Color secondarySoftLavender = Color(0xFFB8B5FF);
  static const Color accentGentleTeal = Color(0xFF5CBDB9);
  
  // Neutrals
  static const Color backgroundSoftWhite = Color(0xFFF8F7FF);
  static const Color lightGray = Color(0xFFE6E6E6);
  static const Color darkGray = Color(0xFF333333);
  
  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE57373);
  static const Color warning = Color(0xFFFFB74D);
  static const Color info = Color(0xFF64B5F6);
  
  // Gradient Colors
  static const List<Color> primaryGradient = [
    primaryDeepIndigo,
    Color(0xFF6A61C0),
  ];
  
  // Transparent colors for overlays
  static const Color blackOverlay = Color(0x80000000);
  static const Color whiteOverlay = Color(0x80FFFFFF);
}
