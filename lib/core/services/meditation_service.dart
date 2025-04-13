import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/meditation.dart';
import '../constants/app_constants.dart';

/// Service for managing meditations
class MeditationService {
  final FirebaseFirestore _firestore;
  
  MeditationService({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;
  
  /// Get meditation collection reference
  CollectionReference<Map<String, dynamic>> get _meditationsCollection => 
      _firestore.collection(AppConstants.meditationsCollection);
  
  /// Get user meditations collection reference
  Query<Map<String, dynamic>> _userMeditationsQuery(String userId) => 
      _meditationsCollection.where('userId', isEqualTo: userId);
  
  /// Stream of all user meditations
  Stream<List<Meditation>> streamUserMeditations(String userId) {
    return _userMeditationsQuery(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Meditation.fromFirestore(doc))
            .toList());
  }
  
  /// Get all user meditations
  Future<List<Meditation>> getUserMeditations(String userId) async {
    try {
      final querySnapshot = await _userMeditationsQuery(userId)
          .orderBy('createdAt', descending: true)
          .get();
          
      return querySnapshot.docs
          .map((doc) => Meditation.fromFirestore(doc))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user meditations: $e');
      }
      throw Exception('Failed to get user meditations: $e');
    }
  }
  
  /// Get favorite meditations
  Future<List<Meditation>> getFavoriteMeditations(String userId) async {
    try {
      final querySnapshot = await _userMeditationsQuery(userId)
          .where('isFavorite', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();
          
      return querySnapshot.docs
          .map((doc) => Meditation.fromFirestore(doc))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting favorite meditations: $e');
      }
      throw Exception('Failed to get favorite meditations: $e');
    }
  }
  
  /// Get recent meditations
  Future<List<Meditation>> getRecentMeditations(String userId, {int limit = 5}) async {
    try {
      final querySnapshot = await _userMeditationsQuery(userId)
          .where('lastPlayedAt', isNull: false)
          .orderBy('lastPlayedAt', descending: true)
          .limit(limit)
          .get();
          
      return querySnapshot.docs
          .map((doc) => Meditation.fromFirestore(doc))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting recent meditations: $e');
      }
      throw Exception('Failed to get recent meditations: $e');
    }
  }
  
  /// Get most played meditations
  Future<List<Meditation>> getMostPlayedMeditations(String userId, {int limit = 5}) async {
    try {
      final querySnapshot = await _userMeditationsQuery(userId)
          .where('playCount', isGreaterThan: 0)
          .orderBy('playCount', descending: true)
          .limit(limit)
          .get();
          
      return querySnapshot.docs
          .map((doc) => Meditation.fromFirestore(doc))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting most played meditations: $e');
      }
      throw Exception('Failed to get most played meditations: $e');
    }
  }
  
  /// Get meditation by ID
  Future<Meditation> getMeditationById(String meditationId) async {
    try {
      final docSnapshot = await _meditationsCollection.doc(meditationId).get();
      
      if (!docSnapshot.exists) {
        throw Exception('Meditation not found');
      }
      
      return Meditation.fromFirestore(docSnapshot);
    } catch (e) {
      if (kDebugMode) {
        print('Error getting meditation by ID: $e');
      }
      throw Exception('Failed to get meditation: $e');
    }
  }
  
  /// Create a new meditation
  Future<Meditation> createMeditation({
    required String userId,
    required String name,
    required String purpose,
    required int durationMinutes,
    required MeditationContent content,
    required MeditationAudio audio,
  }) async {
    try {
      final newMeditationId = const Uuid().v4();
      
      final meditation = Meditation.create(
        id: newMeditationId,
        name: name,
        userId: userId,
        purpose: purpose,
        durationMinutes: durationMinutes,
        content: content,
        audio: audio,
      );
      
      await _meditationsCollection
          .doc(newMeditationId)
          .set(meditation.toFirestore());
          
      return meditation;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating meditation: $e');
      }
      throw Exception('Failed to create meditation: $e');
    }
  }
  
  /// Update an existing meditation
  Future<void> updateMeditation(Meditation meditation) async {
    try {
      await _meditationsCollection
          .doc(meditation.id)
          .update(meditation.toFirestore());
    } catch (e) {
      if (kDebugMode) {
        print('Error updating meditation: $e');
      }
      throw Exception('Failed to update meditation: $e');
    }
  }
  
  /// Delete a meditation
  Future<void> deleteMeditation(String meditationId) async {
    try {
      await _meditationsCollection.doc(meditationId).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting meditation: $e');
      }
      throw Exception('Failed to delete meditation: $e');
    }
  }
  
  /// Toggle favorite status
  Future<Meditation> toggleFavorite(Meditation meditation) async {
    try {
      final updatedMeditation = meditation.toggleFavorite();
      
      await _meditationsCollection
          .doc(meditation.id)
          .update({'isFavorite': updatedMeditation.isFavorite});
          
      return updatedMeditation;
    } catch (e) {
      if (kDebugMode) {
        print('Error toggling favorite: $e');
      }
      throw Exception('Failed to update favorite status: $e');
    }
  }
  
  /// Record a meditation play
  Future<Meditation> recordPlay(Meditation meditation) async {
    try {
      final updatedMeditation = meditation.incrementPlayCount();
      
      await _meditationsCollection
          .doc(meditation.id)
          .update({
            'playCount': updatedMeditation.playCount,
            'lastPlayedAt': Timestamp.fromDate(updatedMeditation.lastPlayedAt!),
          });
          
      return updatedMeditation;
    } catch (e) {
      if (kDebugMode) {
        print('Error recording play: $e');
      }
      throw Exception('Failed to record play: $e');
    }
  }
  
  /// Search meditations by name
  Future<List<Meditation>> searchMeditations(String userId, String query) async {
    try {
      // Basic search implementation - this could be enhanced with Algolia or other search service
      final querySnapshot = await _userMeditationsQuery(userId).get();
      
      final allMeditations = querySnapshot.docs
          .map((doc) => Meditation.fromFirestore(doc))
          .toList();
          
      if (query.isEmpty) {
        return allMeditations;
      }
      
      final lowercaseQuery = query.toLowerCase();
      
      return allMeditations.where((meditation) {
        final nameLower = meditation.name.toLowerCase();
        final purposeLower = meditation.purpose.toLowerCase();
        
        return nameLower.contains(lowercaseQuery) || 
               purposeLower.contains(lowercaseQuery);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error searching meditations: $e');
      }
      throw Exception('Failed to search meditations: $e');
    }
  }
  
  /// Get meditation templates
  Future<List<Meditation>> getMeditationTemplates() async {
    try {
      final querySnapshot = await _meditationsCollection
          .where('isTemplate', isEqualTo: true)
          .orderBy('name')
          .get();
          
      return querySnapshot.docs
          .map((doc) => Meditation.fromFirestore(doc))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting meditation templates: $e');
      }
      throw Exception('Failed to get meditation templates: $e');
    }
  }
}
