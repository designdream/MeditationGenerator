/// Application-wide constants
class AppConstants {
  // Private constructor to prevent instantiation
  AppConstants._();
  
  // App Info
  static const String appName = 'Meditation Creation App';
  static const String appVersion = '1.0.0';
  
  // Routes
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String resetPasswordRoute = '/reset-password';
  static const String homeRoute = '/home';
  static const String libraryRoute = '/library';
  static const String profileRoute = '/profile';
  static const String meditationCreatorRoute = '/create-meditation';
  static const String meditationPlayerRoute = '/player';
  static const String settingsRoute = '/settings';
  
  // Shared Preferences Keys
  static const String keyIsFirstLaunch = 'is_first_launch';
  static const String keyUserOnboardingCompleted = 'user_onboarding_completed';
  static const String keySelectedTheme = 'selected_theme';
  static const String keyCurrentUser = 'current_user';
  
  // Hive Box Names
  static const String userPreferencesBox = 'user_preferences';
  static const String meditationsBox = 'meditations';
  static const String offlineAssetsBox = 'offline_assets';
  
  // Default Values
  static const int defaultMeditationDuration = 10; // minutes
  static const double defaultMusicVolume = 0.5;
  static const double defaultVoiceVolume = 0.7;
  
  // Subscription Plans
  static const double monthlySubscriptionPrice = 9.99;
  static const double annualSubscriptionPrice = 79.99;
  static const double familyMonthlyPrice = 14.99;
  static const double familyAnnualPrice = 119.99;
  static const int trialPeriodDays = 14;
  
  // Audio Asset Paths
  static const String voicesPath = 'assets/audio/voices/';
  static const String musicPath = 'assets/audio/music/';
  static const String naturePath = 'assets/audio/nature/';
  static const String ambientPath = 'assets/audio/ambient/';
  
  // Firebase Collections
  static const String usersCollection = 'users';
  static const String meditationsCollection = 'meditations';
  static const String voicesCollection = 'voices';
  static const String soundsCollection = 'sounds';
  static const String themesCollection = 'themes';
  
  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorAuth = 'Authentication error. Please sign in again.';
  static const String errorSubscription = 'Subscription required for this feature.';
  
  // Success Messages
  static const String successMeditationCreated = 'Meditation created successfully!';
  static const String successMeditationSaved = 'Meditation saved successfully!';
  static const String successProfileUpdated = 'Profile updated successfully!';
  
  // Meditation Categories
  static const List<String> meditationCategories = [
    'Sleep',
    'Stress Relief',
    'Focus',
    'Anxiety',
    'Gratitude',
    'Self-Love',
    'Energy',
    'Manifestation',
  ];
}
