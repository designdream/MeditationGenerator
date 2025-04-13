import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Mock user class that simulates Firebase User
class MockUser {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  
  MockUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });
  
  Map<String, dynamic> toJson() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
  };
  
  factory MockUser.fromJson(Map<String, dynamic> json) => MockUser(
    uid: json['uid'],
    email: json['email'],
    displayName: json['displayName'],
    photoUrl: json['photoUrl'],
  );
}

/// Mock authentication service that simulates Firebase Auth
class MockAuthService {
  static final MockAuthService _instance = MockAuthService._internal();
  factory MockAuthService() => _instance;
  MockAuthService._internal();
  
  MockUser? _currentUser;
  final _authStateController = StreamController<MockUser?>.broadcast();
  
  /// Get the current user
  MockUser? get currentUser => _currentUser;
  
  /// Stream of auth state changes
  Stream<MockUser?> get authStateChanges => _authStateController.stream;
  
  /// Initialize the auth service
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('mock_user');
      
      if (userJson != null) {
        // Convert JSON string to Map
        final Map<String, dynamic> userMap = Map<String, dynamic>.from(
          const JsonDecoder().convert(userJson) as Map
        );
        
        _currentUser = MockUser.fromJson(userMap);
        _authStateController.add(_currentUser);
      } else {
        _authStateController.add(null);
      }
    } catch (e) {
      debugPrint('Failed to initialize mock auth: $e');
      _authStateController.add(null);
    }
  }
  
  /// Sign in with email and password
  Future<MockUser> signInWithEmailAndPassword(String email, String password) async {
    // Demo credentials for testing
    if (email == 'demo@example.com' && password == 'password') {
      final user = MockUser(
        uid: 'demo-user-123',
        email: email,
        displayName: 'Demo User',
        photoUrl: null,
      );
      
      _currentUser = user;
      _saveUserToPrefs(user);
      _authStateController.add(user);
      
      return user;
    } else {
      throw Exception('Invalid email or password');
    }
  }
  
  /// Create a new user with email and password
  Future<MockUser> createUserWithEmailAndPassword(String email, String password) async {
    // For demo purposes, just create a new user
    final user = MockUser(
      uid: 'user-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      displayName: email.split('@').first,
      photoUrl: null,
    );
    
    _currentUser = user;
    _saveUserToPrefs(user);
    _authStateController.add(user);
    
    return user;
  }
  
  /// Sign out the current user
  Future<void> signOut() async {
    _currentUser = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('mock_user');
    
    _authStateController.add(null);
  }
  
  /// Update user profile
  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    if (_currentUser == null) {
      throw Exception('No user signed in');
    }
    
    _currentUser = MockUser(
      uid: _currentUser!.uid,
      email: _currentUser!.email,
      displayName: displayName ?? _currentUser!.displayName,
      photoUrl: photoUrl ?? _currentUser!.photoUrl,
    );
    
    _saveUserToPrefs(_currentUser!);
    _authStateController.add(_currentUser);
  }
  
  /// Send password reset email (mock)
  Future<void> sendPasswordResetEmail(String email) async {
    // Just simulate sending an email
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Password reset email sent to $email (mock)');
  }
  
  /// Save user to SharedPreferences
  Future<void> _saveUserToPrefs(MockUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('mock_user', const JsonEncoder().convert(user.toJson()));
  }
  
  /// Dispose resources
  void dispose() {
    _authStateController.close();
  }
}
