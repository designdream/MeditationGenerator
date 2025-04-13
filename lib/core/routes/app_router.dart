import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/meditation_creator/presentation/screens/meditation_creator_screen.dart';
import '../../features/meditation_player/presentation/screens/meditation_player_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../constants/app_constants.dart';
import '../providers/auth_provider.dart';

/// Shell route for main navigation with bottom navigation bar
class AppShell extends StatefulWidget {
  final Widget child;
  final String location;

  const AppShell({
    Key? key,
    required this.child,
    required this.location,
  }) : super(key: key);

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _calculateSelectedIndex() {
    final location = widget.location;
    
    if (location.startsWith(AppConstants.homeRoute)) {
      return 0;
    } else if (location.startsWith(AppConstants.libraryRoute)) {
      return 1;
    } else if (location.startsWith(AppConstants.profileRoute)) {
      return 2;
    }
    
    // Default to home tab
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(),
        onTap: (index) {
          switch (index) {
            case 0:
              if (widget.location != AppConstants.homeRoute) {
                context.go(AppConstants.homeRoute);
              }
              break;
            case 1:
              if (widget.location != AppConstants.libraryRoute) {
                context.go(AppConstants.libraryRoute);
              }
              break;
            case 2:
              if (widget.location != AppConstants.profileRoute) {
                context.go(AppConstants.profileRoute);
              }
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_outlined),
            activeIcon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

/// App router configuration using go_router
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return GoRouter(
    initialLocation: AppConstants.splashRoute,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      // Handle auth redirects
      final isLoggedIn = authState.value != null;
      final isGoingToLogin = state.location == AppConstants.loginRoute ||
          state.location == AppConstants.registerRoute ||
          state.location == AppConstants.resetPasswordRoute;
      final isGoingToOnboarding = state.location == AppConstants.onboardingRoute;
      final isGoingToSplash = state.location == AppConstants.splashRoute;
      
      // Allow splash screen access
      if (isGoingToSplash) {
        return null;
      }
      
      // Handle first-time onboarding
      if (isGoingToOnboarding) {
        return null;
      }
      
      // If not logged in and not going to auth or onboarding screens, redirect to login
      if (!isLoggedIn && !isGoingToLogin && !isGoingToOnboarding) {
        return AppConstants.loginRoute;
      }
      
      // If logged in and going to auth screens, redirect to home
      if (isLoggedIn && isGoingToLogin) {
        return AppConstants.homeRoute;
      }
      
      // No redirect needed
      return null;
    },
    routes: [
      // Splash screen
      GoRoute(
        path: AppConstants.splashRoute,
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Onboarding
      GoRoute(
        path: AppConstants.onboardingRoute,
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Auth routes
      GoRoute(
        path: AppConstants.loginRoute,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.registerRoute,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppConstants.resetPasswordRoute,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      
      // Shell route (for main navigation with bottom bar)
      ShellRoute(
        builder: (context, state, child) => AppShell(
          child: child,
          location: state.location,
        ),
        routes: [
          // Home
          GoRoute(
            path: AppConstants.homeRoute,
            builder: (context, state) => const HomeScreen(),
          ),
          
          // Library
          GoRoute(
            path: AppConstants.libraryRoute,
            builder: (context, state) => const LibraryScreen(),
          ),
          
          // Profile
          GoRoute(
            path: AppConstants.profileRoute,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      // Meditation creator (outside of shell)
      GoRoute(
        path: AppConstants.meditationCreatorRoute,
        builder: (context, state) => const MeditationCreatorScreen(),
      ),
      
      // Meditation player (outside of shell)
      GoRoute(
        path: '${AppConstants.meditationPlayerRoute}/:id',
        builder: (context, state) => MeditationPlayerScreen(
          meditationId: state.params['id']!,
        ),
      ),
    ],
  );
});
