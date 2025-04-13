import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart' as app_models;
import '../services/auth_service.dart';

/// Provider for the AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

/// Provider for Firebase user authentication state
final authStateProvider = StreamProvider<firebase_auth.User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

/// Provider for the current Firebase user
final firebaseUserProvider = Provider<firebase_auth.User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );
});

/// Provider for the current user's ID
final userIdProvider = Provider<String?>((ref) {
  final user = ref.watch(firebaseUserProvider);
  return user?.uid;
});

/// Provider for checking if a user is signed in
final isSignedInProvider = Provider<bool>((ref) {
  final userId = ref.watch(userIdProvider);
  return userId != null;
});

/// Provider for the current application user model
final userProvider = FutureProvider<app_models.User?>((ref) async {
  final userId = ref.watch(userIdProvider);
  final authService = ref.watch(authServiceProvider);
  
  if (userId == null) {
    return null;
  }
  
  try {
    return await authService.getUserData(userId);
  } catch (e) {
    return null;
  }
});

/// Notifier for managing user data
class UserNotifier extends StateNotifier<app_models.User?> {
  final AuthService _authService;
  
  UserNotifier(this._authService) : super(null);
  
  /// Update the user in state
  void setUser(app_models.User user) {
    state = user;
  }
  
  /// Clear the user from state
  void clearUser() {
    state = null;
  }
  
  /// Update user data in Firestore and state
  Future<void> updateUser(app_models.User user) async {
    await _authService.updateUserData(user);
    state = user;
  }
  
  /// Update user preferences
  Future<void> updatePreferences(app_models.UserPreferences preferences) async {
    if (state == null) return;
    
    final updatedUser = state!.copyWith(preferences: preferences);
    await updateUser(updatedUser);
  }
  
  /// Update user notification settings
  Future<void> updateNotificationSettings(app_models.NotificationSettings settings) async {
    if (state == null) return;
    
    final updatedPreferences = state!.preferences.copyWith(
      notificationSettings: settings,
    );
    
    final updatedUser = state!.copyWith(preferences: updatedPreferences);
    await updateUser(updatedUser);
  }
  
  /// Add a meditation session to user stats
  Future<void> addMeditationSession(int durationMinutes) async {
    if (state == null) return;
    
    final updatedStats = state!.stats.addSession(durationMinutes);
    final updatedUser = state!.copyWith(stats: updatedStats);
    await updateUser(updatedUser);
  }
  
  /// Toggle theme preference
  Future<void> toggleTheme() async {
    if (state == null) return;
    
    final currentTheme = state!.preferences.themePreference;
    final newTheme = currentTheme == 'light' ? 'dark' : 'light';
    
    final updatedPreferences = state!.preferences.copyWith(
      themePreference: newTheme,
    );
    
    final updatedUser = state!.copyWith(preferences: updatedPreferences);
    await updateUser(updatedUser);
  }
  
  /// Add a voice to favorites
  Future<void> addFavoriteVoice(String voiceId) async {
    if (state == null) return;
    
    final currentFavorites = List<String>.from(state!.preferences.favoriteVoices);
    if (!currentFavorites.contains(voiceId)) {
      currentFavorites.add(voiceId);
      
      final updatedPreferences = state!.preferences.copyWith(
        favoriteVoices: currentFavorites,
      );
      
      final updatedUser = state!.copyWith(preferences: updatedPreferences);
      await updateUser(updatedUser);
    }
  }
  
  /// Remove a voice from favorites
  Future<void> removeFavoriteVoice(String voiceId) async {
    if (state == null) return;
    
    final currentFavorites = List<String>.from(state!.preferences.favoriteVoices);
    if (currentFavorites.contains(voiceId)) {
      currentFavorites.remove(voiceId);
      
      final updatedPreferences = state!.preferences.copyWith(
        favoriteVoices: currentFavorites,
      );
      
      final updatedUser = state!.copyWith(preferences: updatedPreferences);
      await updateUser(updatedUser);
    }
  }
  
  /// Add a sound to favorites
  Future<void> addFavoriteSound(String soundId) async {
    if (state == null) return;
    
    final currentFavorites = List<String>.from(state!.preferences.favoriteSounds);
    if (!currentFavorites.contains(soundId)) {
      currentFavorites.add(soundId);
      
      final updatedPreferences = state!.preferences.copyWith(
        favoriteSounds: currentFavorites,
      );
      
      final updatedUser = state!.copyWith(preferences: updatedPreferences);
      await updateUser(updatedUser);
    }
  }
  
  /// Remove a sound from favorites
  Future<void> removeFavoriteSound(String soundId) async {
    if (state == null) return;
    
    final currentFavorites = List<String>.from(state!.preferences.favoriteSounds);
    if (currentFavorites.contains(soundId)) {
      currentFavorites.remove(soundId);
      
      final updatedPreferences = state!.preferences.copyWith(
        favoriteSounds: currentFavorites,
      );
      
      final updatedUser = state!.copyWith(preferences: updatedPreferences);
      await updateUser(updatedUser);
    }
  }
  
  /// Update default meditation length
  Future<void> updateDefaultMeditationLength(int minutes) async {
    if (state == null) return;
    
    final updatedPreferences = state!.preferences.copyWith(
      defaultMeditationLength: minutes,
    );
    
    final updatedUser = state!.copyWith(preferences: updatedPreferences);
    await updateUser(updatedUser);
  }
}

/// Provider for the user notifier
final userNotifierProvider = StateNotifierProvider<UserNotifier, app_models.User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return UserNotifier(authService);
});
