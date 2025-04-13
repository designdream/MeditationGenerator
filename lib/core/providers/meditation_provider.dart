import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meditation.dart';
import '../services/meditation_service.dart';
import 'user_provider.dart';

/// Provider for the MeditationService
final meditationServiceProvider = Provider<MeditationService>((ref) {
  return MeditationService();
});

/// Provider for streaming all user meditations
final userMeditationsStreamProvider = StreamProvider.autoDispose<List<Meditation>>((ref) {
  final userId = ref.watch(userIdProvider);
  final meditationService = ref.watch(meditationServiceProvider);
  
  if (userId == null) {
    return Stream.value([]);
  }
  
  return meditationService.streamUserMeditations(userId);
});

/// Provider for all user meditations
final userMeditationsProvider = FutureProvider.autoDispose<List<Meditation>>((ref) async {
  final userId = ref.watch(userIdProvider);
  final meditationService = ref.watch(meditationServiceProvider);
  
  if (userId == null) {
    return [];
  }
  
  return await meditationService.getUserMeditations(userId);
});

/// Provider for favorite meditations
final favoriteMeditationsProvider = FutureProvider.autoDispose<List<Meditation>>((ref) async {
  final userId = ref.watch(userIdProvider);
  final meditationService = ref.watch(meditationServiceProvider);
  
  if (userId == null) {
    return [];
  }
  
  return await meditationService.getFavoriteMeditations(userId);
});

/// Provider for recent meditations
final recentMeditationsProvider = FutureProvider.autoDispose<List<Meditation>>((ref) async {
  final userId = ref.watch(userIdProvider);
  final meditationService = ref.watch(meditationServiceProvider);
  
  if (userId == null) {
    return [];
  }
  
  return await meditationService.getRecentMeditations(userId, limit: 5);
});

/// Provider for most played meditations
final mostPlayedMeditationsProvider = FutureProvider.autoDispose<List<Meditation>>((ref) async {
  final userId = ref.watch(userIdProvider);
  final meditationService = ref.watch(meditationServiceProvider);
  
  if (userId == null) {
    return [];
  }
  
  return await meditationService.getMostPlayedMeditations(userId, limit: 5);
});

/// Provider for meditation templates
final meditationTemplatesProvider = FutureProvider.autoDispose<List<Meditation>>((ref) async {
  final meditationService = ref.watch(meditationServiceProvider);
  return await meditationService.getMeditationTemplates();
});

/// Provider for a specific meditation by ID
final meditationByIdProvider = FutureProvider.family<Meditation?, String>((ref, meditationId) async {
  try {
    final meditationService = ref.watch(meditationServiceProvider);
    return await meditationService.getMeditationById(meditationId);
  } catch (e) {
    return null;
  }
});

/// Notifier for meditation creation
class MeditationCreatorNotifier extends StateNotifier<Meditation?> {
  final MeditationService _meditationService;
  final String _userId;
  
  MeditationCreatorNotifier(this._meditationService, this._userId) : super(null);
  
  /// Initialize with default meditation
  void initialize({String? purpose}) {
    final defaultVoice = Voice(
      id: 'default',
      name: 'Calm Female',
      gender: 'female',
      accent: 'American',
      tone: 'calm',
      speed: 1.0,
      volume: 0.7,
      assetPath: 'assets/audio/voices/calm_female.mp3',
    );
    
    final defaultContent = MeditationContent.defaults(
      theme: purpose ?? 'Relaxation',
    );
    
    final defaultAudio = MeditationAudio.defaults(
      voice: defaultVoice,
    );
    
    state = Meditation.create(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Untitled Meditation',
      userId: _userId,
      purpose: purpose ?? 'Relaxation',
      durationMinutes: 10,
      content: defaultContent,
      audio: defaultAudio,
    );
  }
  
  /// Update meditation name
  void updateName(String name) {
    if (state == null) return;
    state = state!.copyWith(name: name);
  }
  
  /// Update meditation purpose
  void updatePurpose(String purpose) {
    if (state == null) return;
    state = state!.copyWith(purpose: purpose);
  }
  
  /// Update meditation duration
  void updateDuration(int minutes) {
    if (state == null) return;
    state = state!.copyWith(durationMinutes: minutes);
  }
  
  /// Update meditation content
  void updateContent(MeditationContent content) {
    if (state == null) return;
    state = state!.copyWith(content: content);
  }
  
  /// Update voice
  void updateVoice(Voice voice) {
    if (state == null) return;
    final updatedAudio = state!.audio.copyWith(voice: voice);
    state = state!.copyWith(audio: updatedAudio);
  }
  
  /// Add background sound
  void addBackgroundSound(Sound sound) {
    if (state == null) return;
    final currentSounds = List<Sound>.from(state!.audio.backgroundSounds);
    currentSounds.add(sound);
    
    final updatedAudio = state!.audio.copyWith(backgroundSounds: currentSounds);
    state = state!.copyWith(audio: updatedAudio);
  }
  
  /// Remove background sound
  void removeBackgroundSound(String soundId) {
    if (state == null) return;
    final currentSounds = List<Sound>.from(state!.audio.backgroundSounds);
    currentSounds.removeWhere((sound) => sound.id == soundId);
    
    final updatedAudio = state!.audio.copyWith(backgroundSounds: currentSounds);
    state = state!.copyWith(audio: updatedAudio);
  }
  
  /// Update background sound volume
  void updateBackgroundSoundVolume(String soundId, double volume) {
    if (state == null) return;
    final currentSounds = List<Sound>.from(state!.audio.backgroundSounds);
    final index = currentSounds.indexWhere((sound) => sound.id == soundId);
    
    if (index >= 0) {
      currentSounds[index] = currentSounds[index].copyWith(volume: volume);
      
      final updatedAudio = state!.audio.copyWith(backgroundSounds: currentSounds);
      state = state!.copyWith(audio: updatedAudio);
    }
  }
  
  /// Update background volume during guidance
  void updateBackgroundVolumeDuringGuidance(double volume) {
    if (state == null) return;
    final updatedAudio = state!.audio.copyWith(backgroundVolumeDuringGuidance: volume);
    state = state!.copyWith(audio: updatedAudio);
  }
  
  /// Reset to defaults
  void reset() {
    state = null;
  }
  
  /// Save the meditation
  Future<Meditation> saveMeditation() async {
    if (state == null) {
      throw Exception('No meditation to save');
    }
    
    // For an existing meditation, update it
    if (!state!.id.startsWith('temp_')) {
      await _meditationService.updateMeditation(state!);
      return state!;
    }
    
    // For a new meditation, create it
    final meditation = await _meditationService.createMeditation(
      userId: _userId,
      name: state!.name,
      purpose: state!.purpose,
      durationMinutes: state!.durationMinutes,
      content: state!.content,
      audio: state!.audio,
    );
    
    state = meditation;
    return meditation;
  }
}

/// Provider for the meditation creator
final meditationCreatorProvider = StateNotifierProvider.autoDispose<MeditationCreatorNotifier, Meditation?>((ref) {
  final meditationService = ref.watch(meditationServiceProvider);
  final userId = ref.watch(userIdProvider) ?? '';
  return MeditationCreatorNotifier(meditationService, userId);
});

/// Notifier for the current playing meditation
class CurrentMeditationNotifier extends StateNotifier<Meditation?> {
  final MeditationService _meditationService;
  
  CurrentMeditationNotifier(this._meditationService) : super(null);
  
  /// Set the current meditation
  void setMeditation(Meditation meditation) {
    state = meditation;
  }
  
  /// Clear the current meditation
  void clearMeditation() {
    state = null;
  }
  
  /// Record a play for the current meditation
  Future<void> recordPlay() async {
    if (state == null) return;
    
    try {
      final updatedMeditation = await _meditationService.recordPlay(state!);
      state = updatedMeditation;
    } catch (e) {
      // Just log the error, don't crash
      print('Error recording play: $e');
    }
  }
  
  /// Toggle favorite status for the current meditation
  Future<void> toggleFavorite() async {
    if (state == null) return;
    
    try {
      final updatedMeditation = await _meditationService.toggleFavorite(state!);
      state = updatedMeditation;
    } catch (e) {
      // Just log the error, don't crash
      print('Error toggling favorite: $e');
    }
  }
}

/// Provider for the current meditation
final currentMeditationProvider = StateNotifierProvider<CurrentMeditationNotifier, Meditation?>((ref) {
  final meditationService = ref.watch(meditationServiceProvider);
  return CurrentMeditationNotifier(meditationService);
});
