import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/meditation.dart';
import 'mock_auth_service.dart';

/// Mock service for handling meditation data
class MockMeditationService {
  static final MockMeditationService _instance = MockMeditationService._internal();
  factory MockMeditationService() => _instance;
  MockMeditationService._internal();
  
  final List<Meditation> _meditations = [];
  final _meditationsController = StreamController<List<Meditation>>.broadcast();
  final _mockAuth = MockAuthService();
  
  /// Stream of meditations
  Stream<List<Meditation>> get meditationsStream => _meditationsController.stream;
  
  /// Initialize the meditation service
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final meditationsJson = prefs.getString('mock_meditations');
      
      if (meditationsJson != null) {
        // Convert JSON string to List
        final List<dynamic> meditationsList = 
            const JsonDecoder().convert(meditationsJson) as List<dynamic>;
        
        _meditations.clear();
        for (final item in meditationsList) {
          try {
            _meditations.add(Meditation.fromMap(item as Map<String, dynamic>));
          } catch (e) {
            debugPrint('Error parsing meditation: $e');
          }
        }
      }
      
      // If no meditations found, create sample ones
      if (_meditations.isEmpty) {
        await _createSampleMeditations();
      }
      
      _meditationsController.add(_meditations);
    } catch (e) {
      debugPrint('Failed to initialize mock meditation service: $e');
      // Create sample meditations if something went wrong
      await _createSampleMeditations();
      _meditationsController.add(_meditations);
    }
  }
  
  /// Create sample meditations for demo
  Future<void> _createSampleMeditations() async {
    final currentUser = _mockAuth.currentUser;
    if (currentUser == null) return;
    
    final userId = currentUser.uid;
    
    // Create sample meditations
    final meditation1 = Meditation(
      id: 'meditation-${DateTime.now().millisecondsSinceEpoch}-1',
      name: 'Peaceful Sleep',
      userId: userId,
      purpose: 'Sleep',
      durationMinutes: 15,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      lastPlayedAt: DateTime.now().subtract(const Duration(hours: 5)),
      playCount: 3,
      isFavorite: true,
      content: MeditationContent(
        theme: 'Sleep',
        guidanceLevel: 2,
        includeIntroduction: true,
        includeBodyScan: true,
        includeSilencePeriods: true,
        includeClosingGratitude: true,
        silencePeriodDuration: 30,
        breathingPace: 5,
      ),
      audio: MeditationAudio(
        voice: Voice(
          id: 'voice-1',
          name: 'Calm Female',
          gender: 'female',
          accent: 'American',
          tone: 'calm',
          speed: 0.9,
          volume: 1.0,
          assetPath: 'assets/audio/voices/calm_female.mp3',
          url: null,
        ),
        backgroundSounds: [
          Sound(
            id: 'sound-1',
            name: 'Gentle Rain',
            category: 'Nature',
            volume: 0.7,
            assetPath: 'assets/audio/nature/gentle_rain.mp3',
            url: null,
          ),
          Sound(
            id: 'sound-2',
            name: 'Night Crickets',
            category: 'Nature',
            volume: 0.4,
            assetPath: 'assets/audio/nature/night_crickets.mp3',
            url: null,
          ),
        ],
        backgroundVolumeDuringGuidance: 0.5,
      ),
    );
    
    final meditation2 = Meditation(
      id: 'meditation-${DateTime.now().millisecondsSinceEpoch}-2',
      name: 'Morning Focus',
      userId: userId,
      purpose: 'Focus',
      durationMinutes: 10,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      lastPlayedAt: DateTime.now().subtract(const Duration(hours: 24)),
      playCount: 1,
      isFavorite: false,
      content: MeditationContent(
        theme: 'Focus',
        guidanceLevel: 3,
        includeIntroduction: true,
        includeBodyScan: false,
        includeSilencePeriods: true,
        includeClosingGratitude: true,
        silencePeriodDuration: 20,
        breathingPace: 4,
      ),
      audio: MeditationAudio(
        voice: Voice(
          id: 'voice-2',
          name: 'Energetic Male',
          gender: 'male',
          accent: 'British',
          tone: 'energetic',
          speed: 1.0,
          volume: 1.0,
          assetPath: 'assets/audio/voices/energetic_male.mp3',
          url: null,
        ),
        backgroundSounds: [
          Sound(
            id: 'sound-3',
            name: 'Ambient Tones',
            category: 'Ambient',
            volume: 0.6,
            assetPath: 'assets/audio/ambient/ambient_tones.mp3',
            url: null,
          ),
        ],
        backgroundVolumeDuringGuidance: 0.4,
      ),
    );
    
    final meditation3 = Meditation(
      id: 'meditation-${DateTime.now().millisecondsSinceEpoch}-3',
      name: 'Stress Relief',
      userId: userId,
      purpose: 'Stress Relief',
      durationMinutes: 20,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      lastPlayedAt: DateTime.now().subtract(const Duration(days: 2)),
      playCount: 5,
      isFavorite: true,
      content: MeditationContent(
        theme: 'Stress Relief',
        guidanceLevel: 2,
        includeIntroduction: true,
        includeBodyScan: true,
        includeSilencePeriods: true,
        includeClosingGratitude: true,
        silencePeriodDuration: 40,
        breathingPace: 6,
      ),
      audio: MeditationAudio(
        voice: Voice(
          id: 'voice-3',
          name: 'Soothing Female',
          gender: 'female',
          accent: 'Australian',
          tone: 'soothing',
          speed: 0.85,
          volume: 1.0,
          assetPath: 'assets/audio/voices/soothing_female.mp3',
          url: null,
        ),
        backgroundSounds: [
          Sound(
            id: 'sound-4',
            name: 'Ocean Waves',
            category: 'Nature',
            volume: 0.8,
            assetPath: 'assets/audio/nature/ocean_waves.mp3',
            url: null,
          ),
          Sound(
            id: 'sound-5',
            name: 'Gentle Wind',
            category: 'Nature',
            volume: 0.3,
            assetPath: 'assets/audio/nature/gentle_wind.mp3',
            url: null,
          ),
        ],
        backgroundVolumeDuringGuidance: 0.6,
      ),
    );
    
    _meditations.add(meditation1);
    _meditations.add(meditation2);
    _meditations.add(meditation3);
    
    await _saveMeditationsToPrefs();
  }
  
  /// Get all meditations for the current user
  List<Meditation> getMeditations() {
    final currentUser = _mockAuth.currentUser;
    if (currentUser == null) return [];
    
    return _meditations
        .where((m) => m.userId == currentUser.uid)
        .toList();
  }
  
  /// Get meditation by ID
  Meditation? getMeditationById(String id) {
    try {
      return _meditations.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Create a new meditation
  Future<Meditation> createMeditation(Meditation meditation) async {
    final currentUser = _mockAuth.currentUser;
    if (currentUser == null) {
      throw Exception('No user signed in');
    }
    
    // Add a random delay to simulate network latency
    await Future.delayed(Duration(milliseconds: Random().nextInt(500) + 300));
    
    _meditations.add(meditation);
    await _saveMeditationsToPrefs();
    _meditationsController.add(_meditations);
    
    return meditation;
  }
  
  /// Update an existing meditation
  Future<Meditation> updateMeditation(Meditation meditation) async {
    final currentUser = _mockAuth.currentUser;
    if (currentUser == null) {
      throw Exception('No user signed in');
    }
    
    // Add a random delay to simulate network latency
    await Future.delayed(Duration(milliseconds: Random().nextInt(500) + 300));
    
    final index = _meditations.indexWhere((m) => m.id == meditation.id);
    if (index == -1) {
      throw Exception('Meditation not found');
    }
    
    _meditations[index] = meditation;
    await _saveMeditationsToPrefs();
    _meditationsController.add(_meditations);
    
    return meditation;
  }
  
  /// Toggle favorite status for a meditation
  Future<Meditation> toggleFavorite(String meditationId) async {
    final meditation = getMeditationById(meditationId);
    if (meditation == null) {
      throw Exception('Meditation not found');
    }
    
    final updatedMeditation = meditation.toggleFavorite();
    return updateMeditation(updatedMeditation);
  }
  
  /// Record a play for a meditation
  Future<Meditation> recordPlay(String meditationId) async {
    final meditation = getMeditationById(meditationId);
    if (meditation == null) {
      throw Exception('Meditation not found');
    }
    
    final updatedMeditation = meditation.incrementPlayCount();
    return updateMeditation(updatedMeditation);
  }
  
  /// Delete a meditation
  Future<void> deleteMeditation(String meditationId) async {
    final currentUser = _mockAuth.currentUser;
    if (currentUser == null) {
      throw Exception('No user signed in');
    }
    
    // Add a random delay to simulate network latency
    await Future.delayed(Duration(milliseconds: Random().nextInt(500) + 300));
    
    _meditations.removeWhere((m) => m.id == meditationId);
    await _saveMeditationsToPrefs();
    _meditationsController.add(_meditations);
  }
  
  /// Save meditations to SharedPreferences
  Future<void> _saveMeditationsToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> meditationsMap = 
        _meditations.map((m) => m.toMap()).toList();
    
    await prefs.setString('mock_meditations', const JsonEncoder().convert(meditationsMap));
  }
  
  /// Get favorite meditations
  List<Meditation> getFavoriteMeditations() {
    return getMeditations().where((m) => m.isFavorite).toList();
  }
  
  /// Get meditations by purpose
  List<Meditation> getMeditationsByPurpose(String purpose) {
    return getMeditations().where((m) => m.purpose == purpose).toList();
  }
  
  /// Search meditations by name or purpose
  List<Meditation> searchMeditations(String query) {
    if (query.isEmpty) return getMeditations();
    
    final lowercaseQuery = query.toLowerCase();
    return getMeditations().where((m) => 
        m.name.toLowerCase().contains(lowercaseQuery) || 
        m.purpose.toLowerCase().contains(lowercaseQuery)
    ).toList();
  }
  
  /// Dispose resources
  void dispose() {
    _meditationsController.close();
  }
}
