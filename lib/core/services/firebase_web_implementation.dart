import 'package:firebase_core/firebase_core.dart';
import '../utils/platform_helper.dart';
import '../../firebase_options.dart';

/// Firebase service initialization specifically optimized for web
class FirebaseWebService {
  /// Initialize Firebase for web platform
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.web,
      );
      print('Firebase Web initialized successfully');
    } catch (e) {
      print('Failed to initialize Firebase Web: $e');
      // On web, we'll continue even if Firebase fails to initialize
      // This allows the app to still run in demo mode
    }
  }
}
