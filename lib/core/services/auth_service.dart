import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart' as app_models;

/// Authentication service for handling user authentication
class AuthService {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  
  AuthService({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : 
    _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
    _firestore = firestore ?? FirebaseFirestore.instance;
  
  /// Stream of authentication state changes
  Stream<firebase_auth.User?> get authStateChanges => 
      _firebaseAuth.authStateChanges();
  
  /// Current user from Firebase Auth
  firebase_auth.User? get currentUser => _firebaseAuth.currentUser;
  
  /// Check if user is signed in
  bool get isSignedIn => currentUser != null;
  
  /// Sign in with email and password
  Future<app_models.User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = result.user;
      if (user == null) {
        throw Exception('Sign in failed: No user returned from Firebase');
      }
      
      // Update last login time
      await _updateLastLogin(user.uid);
      
      // Get user data from Firestore
      return await getUserData(user.uid);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  /// Create account with email and password
  Future<app_models.User> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final user = result.user;
      if (user == null) {
        throw Exception('Account creation failed: No user returned from Firebase');
      }
      
      // Update display name if provided
      if (displayName != null) {
        await user.updateDisplayName(displayName);
      }
      
      // Create user document in Firestore
      final appUser = app_models.User.create(
        id: user.uid,
        email: user.email ?? email,
        displayName: displayName,
      );
      
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(appUser.toFirestore());
          
      return appUser;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  /// Sign in with Apple
  Future<app_models.User> signInWithApple() async {
    try {
      // Apple sign-in implementation
      throw UnimplementedError('Apple sign-in not implemented yet');
    } catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  /// Sign in with Google
  Future<app_models.User> signInWithGoogle() async {
    try {
      // Google sign-in implementation
      throw UnimplementedError('Google sign-in not implemented yet');
    } catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  /// Sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  /// Get user data from Firestore
  Future<app_models.User> getUserData(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      
      if (!doc.exists) {
        // Create user document if it doesn't exist
        final authUser = _firebaseAuth.currentUser;
        if (authUser == null) {
          throw Exception('User not found and not authenticated');
        }
        
        final newUser = app_models.User.create(
          id: authUser.uid,
          email: authUser.email ?? '',
          displayName: authUser.displayName,
        );
        
        await _firestore
            .collection('users')
            .doc(userId)
            .set(newUser.toFirestore());
            
        return newUser;
      }
      
      return app_models.User.fromFirestore(doc);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user data: $e');
      }
      throw Exception('Failed to get user data: $e');
    }
  }
  
  /// Update user data in Firestore
  Future<void> updateUserData(app_models.User user) async {
    try {
      await _firestore
          .collection('users')
          .doc(user.id)
          .update(user.toFirestore());
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user data: $e');
      }
      throw Exception('Failed to update user data: $e');
    }
  }
  
  /// Update last login time
  Future<void> _updateLastLogin(String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .update({
            'lastLoginAt': Timestamp.now(),
          });
    } catch (e) {
      if (kDebugMode) {
        print('Error updating last login: $e');
      }
      // Don't throw here, just log the error
    }
  }
  
  /// Handle authentication exceptions
  Exception _handleAuthException(dynamic e) {
    if (kDebugMode) {
      print('Auth error: $e');
    }
    
    if (e is firebase_auth.FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return Exception('No user found with this email');
        case 'wrong-password':
          return Exception('Incorrect password');
        case 'email-already-in-use':
          return Exception('Email is already in use');
        case 'weak-password':
          return Exception('Password is too weak');
        case 'invalid-email':
          return Exception('Invalid email address');
        case 'user-disabled':
          return Exception('This account has been disabled');
        case 'too-many-requests':
          return Exception('Too many attempts. Try again later');
        case 'operation-not-allowed':
          return Exception('Operation not allowed');
        default:
          return Exception('Authentication error: ${e.message}');
      }
    }
    
    return Exception('Authentication error: $e');
  }
}
