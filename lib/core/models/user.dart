import 'package:cloud_firestore/cloud_firestore.dart';

/// User model representing app user data
class User {
  final String id;
  final String email;
  final String displayName;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final UserPreferences preferences;
  final SubscriptionInfo subscription;
  final UserStats stats;

  User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.createdAt,
    required this.lastLoginAt,
    required this.preferences,
    required this.subscription,
    required this.stats,
  });

  /// Create a new user with default values
  factory User.create({
    required String id,
    required String email,
    String? displayName,
  }) {
    final now = DateTime.now();
    return User(
      id: id,
      email: email,
      displayName: displayName ?? email.split('@').first,
      createdAt: now,
      lastLoginAt: now,
      preferences: UserPreferences.defaultPreferences(),
      subscription: SubscriptionInfo.freeTier(),
      stats: UserStats.initial(),
    );
  }

  /// Create User from Firestore document
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return User(
      id: doc.id,
      email: data['email'] ?? '',
      displayName: data['displayName'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp).toDate(),
      preferences: UserPreferences.fromMap(data['preferences'] ?? {}),
      subscription: SubscriptionInfo.fromMap(data['subscription'] ?? {}),
      stats: UserStats.fromMap(data['stats'] ?? {}),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'displayName': displayName,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLoginAt': Timestamp.fromDate(lastLoginAt),
      'preferences': preferences.toMap(),
      'subscription': subscription.toMap(),
      'stats': stats.toMap(),
    };
  }

  /// Create a copy of User with given parameters
  User copyWith({
    String? id,
    String? email,
    String? displayName,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    UserPreferences? preferences,
    SubscriptionInfo? subscription,
    UserStats? stats,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
      subscription: subscription ?? this.subscription,
      stats: stats ?? this.stats,
    );
  }
}

/// User preferences model
class UserPreferences {
  final List<String> favoriteVoices;
  final List<String> favoriteSounds;
  final int defaultMeditationLength;
  final NotificationSettings notificationSettings;
  final String themePreference;

  UserPreferences({
    required this.favoriteVoices,
    required this.favoriteSounds,
    required this.defaultMeditationLength,
    required this.notificationSettings,
    required this.themePreference,
  });

  /// Create default preferences
  factory UserPreferences.defaultPreferences() {
    return UserPreferences(
      favoriteVoices: [],
      favoriteSounds: [],
      defaultMeditationLength: 10, // 10 minutes
      notificationSettings: NotificationSettings.defaultSettings(),
      themePreference: 'light',
    );
  }

  /// Create from map
  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      favoriteVoices: List<String>.from(map['favoriteVoices'] ?? []),
      favoriteSounds: List<String>.from(map['favoriteSounds'] ?? []),
      defaultMeditationLength: map['defaultMeditationLength'] ?? 10,
      notificationSettings: NotificationSettings.fromMap(map['notificationSettings'] ?? {}),
      themePreference: map['themePreference'] ?? 'light',
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'favoriteVoices': favoriteVoices,
      'favoriteSounds': favoriteSounds,
      'defaultMeditationLength': defaultMeditationLength,
      'notificationSettings': notificationSettings.toMap(),
      'themePreference': themePreference,
    };
  }

  /// Create a copy with updated fields
  UserPreferences copyWith({
    List<String>? favoriteVoices,
    List<String>? favoriteSounds,
    int? defaultMeditationLength,
    NotificationSettings? notificationSettings,
    String? themePreference,
  }) {
    return UserPreferences(
      favoriteVoices: favoriteVoices ?? this.favoriteVoices,
      favoriteSounds: favoriteSounds ?? this.favoriteSounds,
      defaultMeditationLength: defaultMeditationLength ?? this.defaultMeditationLength,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      themePreference: themePreference ?? this.themePreference,
    );
  }
}

/// Notification settings model
class NotificationSettings {
  final bool enabled;
  final String reminderTime;
  final List<String> days;

  NotificationSettings({
    required this.enabled,
    required this.reminderTime,
    required this.days,
  });

  /// Create default notification settings
  factory NotificationSettings.defaultSettings() {
    return NotificationSettings(
      enabled: false,
      reminderTime: '08:00',
      days: ['Monday', 'Wednesday', 'Friday'],
    );
  }

  /// Create from map
  factory NotificationSettings.fromMap(Map<String, dynamic> map) {
    return NotificationSettings(
      enabled: map['enabled'] ?? false,
      reminderTime: map['reminderTime'] ?? '08:00',
      days: List<String>.from(map['days'] ?? ['Monday', 'Wednesday', 'Friday']),
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'enabled': enabled,
      'reminderTime': reminderTime,
      'days': days,
    };
  }

  /// Create a copy with updated fields
  NotificationSettings copyWith({
    bool? enabled,
    String? reminderTime,
    List<String>? days,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      reminderTime: reminderTime ?? this.reminderTime,
      days: days ?? this.days,
    );
  }
}

/// Subscription information model
class SubscriptionInfo {
  final String status; // 'free', 'trial', 'active', 'canceled', 'expired'
  final String plan; // 'free', 'monthly', 'annual', 'family_monthly', 'family_annual'
  final DateTime? startDate;
  final DateTime? endDate;
  final bool autoRenew;
  final String? paymentMethod;

  SubscriptionInfo({
    required this.status,
    required this.plan,
    this.startDate,
    this.endDate,
    required this.autoRenew,
    this.paymentMethod,
  });

  /// Create free tier subscription
  factory SubscriptionInfo.freeTier() {
    return SubscriptionInfo(
      status: 'free',
      plan: 'free',
      autoRenew: false,
    );
  }

  /// Create trial subscription
  factory SubscriptionInfo.trial() {
    final now = DateTime.now();
    return SubscriptionInfo(
      status: 'trial',
      plan: 'trial',
      startDate: now,
      endDate: now.add(const Duration(days: 14)), // 14-day trial
      autoRenew: true,
    );
  }

  /// Create from map
  factory SubscriptionInfo.fromMap(Map<String, dynamic> map) {
    return SubscriptionInfo(
      status: map['status'] ?? 'free',
      plan: map['plan'] ?? 'free',
      startDate: map['startDate'] != null ? (map['startDate'] as Timestamp).toDate() : null,
      endDate: map['endDate'] != null ? (map['endDate'] as Timestamp).toDate() : null,
      autoRenew: map['autoRenew'] ?? false,
      paymentMethod: map['paymentMethod'],
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'plan': plan,
      'startDate': startDate != null ? Timestamp.fromDate(startDate!) : null,
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'autoRenew': autoRenew,
      'paymentMethod': paymentMethod,
    };
  }

  /// Check if subscription is active
  bool get isActive => status == 'active' || status == 'trial';

  /// Check if subscription is premium
  bool get isPremium => isActive && plan != 'free';

  /// Create a copy with updated fields
  SubscriptionInfo copyWith({
    String? status,
    String? plan,
    DateTime? startDate,
    DateTime? endDate,
    bool? autoRenew,
    String? paymentMethod,
  }) {
    return SubscriptionInfo(
      status: status ?? this.status,
      plan: plan ?? this.plan,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      autoRenew: autoRenew ?? this.autoRenew,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}

/// User statistics model
class UserStats {
  final int totalMeditationTime; // in minutes
  final int sessionsCompleted;
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastMeditationDate;

  UserStats({
    required this.totalMeditationTime,
    required this.sessionsCompleted,
    required this.currentStreak,
    required this.longestStreak,
    this.lastMeditationDate,
  });

  /// Create initial stats
  factory UserStats.initial() {
    return UserStats(
      totalMeditationTime: 0,
      sessionsCompleted: 0,
      currentStreak: 0,
      longestStreak: 0,
      lastMeditationDate: null,
    );
  }

  /// Create from map
  factory UserStats.fromMap(Map<String, dynamic> map) {
    return UserStats(
      totalMeditationTime: map['totalMeditationTime'] ?? 0,
      sessionsCompleted: map['sessionsCompleted'] ?? 0,
      currentStreak: map['currentStreak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      lastMeditationDate: map['lastMeditationDate'] != null 
          ? (map['lastMeditationDate'] as Timestamp).toDate() 
          : null,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'totalMeditationTime': totalMeditationTime,
      'sessionsCompleted': sessionsCompleted,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastMeditationDate': lastMeditationDate != null 
          ? Timestamp.fromDate(lastMeditationDate!) 
          : null,
    };
  }

  /// Create a copy with updated fields
  UserStats copyWith({
    int? totalMeditationTime,
    int? sessionsCompleted,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastMeditationDate,
  }) {
    return UserStats(
      totalMeditationTime: totalMeditationTime ?? this.totalMeditationTime,
      sessionsCompleted: sessionsCompleted ?? this.sessionsCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastMeditationDate: lastMeditationDate ?? this.lastMeditationDate,
    );
  }

  /// Add a new meditation session
  UserStats addSession(int durationMinutes) {
    final now = DateTime.now();
    final newTotalTime = totalMeditationTime + durationMinutes;
    final newSessionsCompleted = sessionsCompleted + 1;
    
    // Calculate streak
    int newCurrentStreak = currentStreak;
    int newLongestStreak = longestStreak;
    
    if (lastMeditationDate == null) {
      // First meditation
      newCurrentStreak = 1;
      newLongestStreak = 1;
    } else {
      final lastDate = DateTime(
        lastMeditationDate!.year,
        lastMeditationDate!.month,
        lastMeditationDate!.day,
      );
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      
      if (lastDate.isAtSameMomentAs(yesterday)) {
        // Meditated yesterday, streak continues
        newCurrentStreak += 1;
        if (newCurrentStreak > newLongestStreak) {
          newLongestStreak = newCurrentStreak;
        }
      } else if (lastDate.isBefore(yesterday)) {
        // Missed a day, streak resets
        newCurrentStreak = 1;
      }
      // If meditated today already, streak remains unchanged
    }
    
    return UserStats(
      totalMeditationTime: newTotalTime,
      sessionsCompleted: newSessionsCompleted,
      currentStreak: newCurrentStreak,
      longestStreak: newLongestStreak,
      lastMeditationDate: now,
    );
  }
}
