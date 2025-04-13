import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/services/mock/mock_auth_service.dart';
import 'core/services/mock/mock_meditation_service.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/signup_screen.dart';
import 'features/auth/presentation/screens/reset_password_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/meditation_creator/presentation/screens/meditation_creator_screen.dart';
import 'features/meditation_player/presentation/screens/meditation_player_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/splash/presentation/screens/splash_screen.dart';

/// Shared preferences provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialized in main()');
});

/// Mock auth service provider
final mockAuthServiceProvider = Provider<MockAuthService>((ref) {
  return MockAuthService();
});

/// Mock meditation service provider
final mockMeditationServiceProvider = Provider<MockMeditationService>((ref) {
  return MockMeditationService();
});

/// Auth state provider
final authStateProvider = StreamProvider<MockUser?>((ref) {
  final authService = ref.watch(mockAuthServiceProvider);
  return authService.authStateChanges;
});

/// GoRouter configuration
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppConstants.splashRoute,
    routes: [
      GoRoute(
        path: AppConstants.splashRoute,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppConstants.loginRoute,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.signupRoute,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: AppConstants.resetPasswordRoute,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppConstants.homeRoute,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppConstants.meditationCreatorRoute,
        builder: (context, state) => const MeditationCreatorScreen(),
      ),
      GoRoute(
        path: "${AppConstants.meditationPlayerRoute}/:id",
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return MeditationPlayerScreen(meditationId: id);
        },
      ),
      GoRoute(
        path: AppConstants.profileRoute,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    redirect: (context, state) {
      // Handle auth state redirects
      final isLoggedIn = authState.valueOrNull != null;
      final isGoingToLogin = state.matchedLocation == AppConstants.loginRoute;
      final isGoingToSignup = state.matchedLocation == AppConstants.signupRoute;
      final isGoingToForgotPassword = state.matchedLocation == AppConstants.forgotPasswordRoute;
      final isGoingToSplash = state.matchedLocation == AppConstants.splashRoute;

      // Allow splash screen access regardless of auth state
      if (isGoingToSplash) return null;

      // If not logged in and not going to auth screens, redirect to login
      if (!isLoggedIn && 
          !isGoingToLogin && 
          !isGoingToSignup && 
          !state.matchedLocation.contains(AppConstants.resetPasswordRoute)) {
        return AppConstants.loginRoute;
      }

      // If logged in and going to auth screens, redirect to home
      if (isLoggedIn && (isGoingToLogin || isGoingToSignup || 
          state.matchedLocation.contains(AppConstants.resetPasswordRoute))) {
        return AppConstants.homeRoute;
      }

      return null;
    },
  );
});

/// Initializes the app
Future<void> initializeApp() async {
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize shared preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // Initialize mock services
  final authService = MockAuthService();
  await authService.initialize();
  
  final meditationService = MockMeditationService();
  await meditationService.initialize();
  
  // Return shared preferences for provider
  return sharedPreferences;
}

/// Web compatible app using mock services
class MeditationWebCompatibleApp extends ConsumerWidget {
  const MeditationWebCompatibleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Meditation Creation App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
