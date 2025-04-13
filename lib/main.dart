import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/platform_helper.dart';

// Conditionally import Firebase implementations
import 'core/services/firebase_web_implementation.dart' if (dart.library.io) 'firebase_options.dart';

/// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize Firebase based on platform
  if (PlatformHelper.isWeb) {
    // Use web-specific implementation
    await FirebaseWebService.initialize();
  } else {
    // For mobile platforms, handle differently
    debugPrint('Mobile platform detected, skipping Firebase initialization for demo');
    // In a real app, we would initialize Firebase for mobile here
  }
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Hive adapters (will be implemented later)
  
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // Run the app
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MeditationApp(),
    ),
  );
}

/// Main application widget
class MeditationApp extends ConsumerStatefulWidget {
  const MeditationApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MeditationApp> createState() => _MeditationAppState();
}

class _MeditationAppState extends ConsumerState<MeditationApp> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }
  
  /// Initialize app resources
  Future<void> _initializeApp() async {
    // Additional initialization if needed
  }
  
  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    
    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Will be changed to user preference later
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          // Apply text scaling factor for accessibility
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
