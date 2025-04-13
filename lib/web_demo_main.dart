import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'web_compatible_app.dart';

/// Web demo entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    // Initialize app
    final sharedPreferences = await initializeApp();
    
    // Run app with providers
    runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ],
        child: const MeditationWebCompatibleApp(),
      ),
    );
  } catch (error) {
    print('Error initializing app: $error');
    
    // Fallback to a simple error app if initialization fails
    runApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: const Color(0xFF3D3A7C),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Oops! Something went wrong.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  error.toString(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
