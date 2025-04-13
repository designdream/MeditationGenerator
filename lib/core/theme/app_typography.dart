import 'package:flutter/material.dart';

/// App typography styles using system fonts (temporarily until we add custom fonts)
class AppTypography {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 32,
    height: 1.2,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 28,
    height: 1.2,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
    height: 1.2,
  );
  
  // Subheadings
  static const TextStyle subheading1 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 22,
    height: 1.3,
  );
  
  static const TextStyle subheading2 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    height: 1.3,
  );
  
  static const TextStyle subheading3 = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    height: 1.3,
  );
  
  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 18,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 16,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    height: 1.5,
  );
  
  // Captions
  static const TextStyle caption = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 14,
    height: 1.4,
  );
  
  // Buttons
  static const TextStyle buttonLarge = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    height: 1.2,
    letterSpacing: 0.5,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 1.2,
    letterSpacing: 0.5,
  );
  
  static const TextStyle buttonSmall = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.2,
    letterSpacing: 0.5,
  );
}
