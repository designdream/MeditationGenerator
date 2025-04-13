import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

/// Service for Firebase initialization and management
class FirebaseService {
  // Private constructor to prevent instantiation
  FirebaseService._();
  
  static FirebaseAnalytics? _analytics;
  static FirebasePerformance? _performance;
  
  /// Get Firebase Analytics instance
  static FirebaseAnalytics get analytics {
    if (_analytics == null) {
      throw Exception('Firebase Analytics not initialized');
    }
    return _analytics!;
  }
  
  /// Get Firebase Performance instance
  static FirebasePerformance get performance {
    if (_performance == null) {
      throw Exception('Firebase Performance not initialized');
    }
    return _performance!;
  }
  
  /// Initialize Firebase services
  static Future<void> initialize() async {
    try {
      // Initialize Firebase Core
      await Firebase.initializeApp();
      
      // Initialize Analytics
      _analytics = FirebaseAnalytics.instance;
      
      // Initialize Performance Monitoring
      _performance = FirebasePerformance.instance;
      
      // Configure Crashlytics
      if (!kDebugMode) {
        // Enable Crashlytics in release mode
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
        
        // Pass all Flutter errors to Crashlytics
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
      } else {
        // Disable Crashlytics in debug mode
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      }
      
      if (kDebugMode) {
        print('Firebase initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Firebase: $e');
      }
      rethrow;
    }
  }
  
  /// Log analytics event
  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      await analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error logging event: $e');
      }
      // Don't throw here, just log the error
    }
  }
  
  /// Set user ID for analytics
  static Future<void> setUserId(String userId) async {
    try {
      await analytics.setUserId(id: userId);
    } catch (e) {
      if (kDebugMode) {
        print('Error setting user ID: $e');
      }
      // Don't throw here, just log the error
    }
  }
  
  /// Set user properties for analytics
  static Future<void> setUserProperty({
    required String name,
    required String? value,
  }) async {
    try {
      await analytics.setUserProperty(
        name: name,
        value: value,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error setting user property: $e');
      }
      // Don't throw here, just log the error
    }
  }
  
  /// Start a performance trace
  static Trace? startTrace(String name) {
    try {
      return performance.newTrace(name);
    } catch (e) {
      if (kDebugMode) {
        print('Error starting trace: $e');
      }
      return null;
    }
  }
  
  /// Record error to Crashlytics
  static Future<void> recordError(
    dynamic exception,
    StackTrace stack, {
    dynamic reason,
    Iterable<DiagnosticsNode>? information,
    bool fatal = false,
  }) async {
    try {
      await FirebaseCrashlytics.instance.recordError(
        exception,
        stack,
        reason: reason,
        information: information,
        fatal: fatal,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error recording to Crashlytics: $e');
      }
      // Don't throw here, just log the error
    }
  }
}
