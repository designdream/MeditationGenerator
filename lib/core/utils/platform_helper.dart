import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Helper to detect the current platform
class PlatformHelper {
  /// Check if running on web
  static bool get isWeb => kIsWeb;
  
  /// Check if running on iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;
  
  /// Check if running on Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;
  
  /// Check if running on desktop (macOS, Windows, Linux)
  static bool get isDesktop => !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
  
  /// Check if running on mobile (iOS or Android)
  static bool get isMobile => isIOS || isAndroid;
}
