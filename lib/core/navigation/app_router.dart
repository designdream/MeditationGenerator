import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/discover/presentation/screens/discover_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/meditation_creator/presentation/screens/meditation_creator_screen.dart';
import '../../features/meditation_player/presentation/screens/meditation_player_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../constants/app_constants.dart';

/// Application router configuration using GoRouter
class AppRouter {
  // Private constructor
  AppRouter._();
  
  /// The router configuration
  static final GoRouter router = GoRouter(
    initialLocation: AppConstants.initialRoute,
    debugLogDiagnostics: true,
    routes: [
      // Onboarding flow
      GoRoute(
        path: AppConstants.initialRoute,
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Auth routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      
      // Main app shell with nested routes
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithBottomNavBar(child: child);
        },
        routes: [
          // Home route
          GoRoute(
            path: AppConstants.homeRoute,
            builder: (context, state) => const HomeScreen(),
          ),
          
          // Create meditation route
          GoRoute(
            path: AppConstants.createMeditationRoute,
            builder: (context, state) => const MeditationCreatorScreen(),
          ),
          
          // Library route
          GoRoute(
            path: AppConstants.libraryRoute,
            builder: (context, state) => const LibraryScreen(),
          ),
          
          // Discover route
          GoRoute(
            path: AppConstants.discoverRoute,
            builder: (context, state) => const DiscoverScreen(),
          ),
          
          // Profile route
          GoRoute(
            path: AppConstants.profileRoute,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      // Meditation player (full screen)
      GoRoute(
        path: '${AppConstants.meditationPlayerRoute}/:id',
        builder: (context, state) {
          final meditationId = state.pathParameters['id'] ?? '';
          return MeditationPlayerScreen(meditationId: meditationId);
        },
      ),
      
      // Settings
      GoRoute(
        path: AppConstants.settingsRoute,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    
    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Route not found: ${state.error}'),
      ),
    ),
  );
}

/// Scaffold with bottom navigation bar for the main app shell
class ScaffoldWithBottomNavBar extends StatefulWidget {
  final Widget child;
  
  const ScaffoldWithBottomNavBar({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<ScaffoldWithBottomNavBar> createState() => _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).fullPath ?? '';
    
    if (location.startsWith(AppConstants.homeRoute)) {
      return 0;
    }
    if (location.startsWith(AppConstants.createMeditationRoute)) {
      return 1;
    }
    if (location.startsWith(AppConstants.libraryRoute)) {
      return 2;
    }
    if (location.startsWith(AppConstants.discoverRoute)) {
      return 3;
    }
    if (location.startsWith(AppConstants.profileRoute)) {
      return 4;
    }
    
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(AppConstants.homeRoute);
        break;
      case 1:
        GoRouter.of(context).go(AppConstants.createMeditationRoute);
        break;
      case 2:
        GoRouter.of(context).go(AppConstants.libraryRoute);
        break;
      case 3:
        GoRouter.of(context).go(AppConstants.discoverRoute);
        break;
      case 4:
        GoRouter.of(context).go(AppConstants.profileRoute);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _calculateSelectedIndex(context),
        onTap: (index) => _onItemTapped(index, context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_outlined),
            activeIcon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Discover',
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
