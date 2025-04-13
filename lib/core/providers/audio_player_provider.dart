import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meditation.dart';
import '../services/audio_service.dart';
import 'meditation_provider.dart';

/// Provider for the AudioService
final audioServiceProvider = Provider<AudioService>((ref) {
  final audioService = AudioService();
  ref.onDispose(() {
    audioService.dispose();
  });
  return audioService;
});

/// Provider for the current playback state
final playbackStateProvider = StreamProvider<PlaybackState>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return audioService.playbackStateStream;
});

/// Provider for the current playback position
final playbackPositionProvider = StreamProvider<Duration>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return audioService.positionStream;
});

/// Provider for checking if audio is currently playing
final isPlayingProvider = Provider<bool>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return audioService.isPlaying;
});

/// Provider for checking if audio is currently paused
final isPausedProvider = Provider<bool>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return audioService.isPaused;
});

/// Notifier for managing audio playback
class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  final AudioService _audioService;
  final CurrentMeditationNotifier _currentMeditationNotifier;
  
  AudioPlayerNotifier(this._audioService, this._currentMeditationNotifier) 
      : super(const AudioPlayerState.initial());
  
  /// Initialize the audio service
  Future<void> initialize() async {
    try {
      await _audioService.initialize();
      state = const AudioPlayerState.ready();
    } catch (e) {
      state = AudioPlayerState.error('Failed to initialize audio player: $e');
    }
  }
  
  /// Load a meditation for playback
  Future<void> loadMeditation(Meditation meditation) async {
    try {
      state = const AudioPlayerState.loading();
      
      await _audioService.loadMeditation(meditation);
      _currentMeditationNotifier.setMeditation(meditation);
      
      state = const AudioPlayerState.ready();
    } catch (e) {
      state = AudioPlayerState.error('Failed to load meditation: $e');
    }
  }
  
  /// Play the loaded meditation
  Future<void> play() async {
    try {
      await _audioService.play();
      
      // Record the play
      final currentMeditation = _currentMeditationNotifier.state;
      if (currentMeditation != null) {
        _currentMeditationNotifier.recordPlay();
      }
    } catch (e) {
      state = AudioPlayerState.error('Failed to play meditation: $e');
    }
  }
  
  /// Pause playback
  Future<void> pause() async {
    try {
      await _audioService.pause();
    } catch (e) {
      state = AudioPlayerState.error('Failed to pause meditation: $e');
    }
  }
  
  /// Resume playback
  Future<void> resume() async {
    try {
      await _audioService.resume();
    } catch (e) {
      state = AudioPlayerState.error('Failed to resume meditation: $e');
    }
  }
  
  /// Stop playback
  Future<void> stop() async {
    try {
      await _audioService.stop();
    } catch (e) {
      state = AudioPlayerState.error('Failed to stop meditation: $e');
    }
  }
  
  /// Seek to position
  Future<void> seekTo(Duration position) async {
    try {
      await _audioService.seekTo(position);
    } catch (e) {
      state = AudioPlayerState.error('Failed to seek: $e');
    }
  }
  
  /// Skip forward
  Future<void> skipForward() async {
    try {
      await _audioService.skipForward(const Duration(seconds: 15));
    } catch (e) {
      state = AudioPlayerState.error('Failed to skip forward: $e');
    }
  }
  
  /// Skip backward
  Future<void> skipBackward() async {
    try {
      await _audioService.skipBackward(const Duration(seconds: 15));
    } catch (e) {
      state = AudioPlayerState.error('Failed to skip backward: $e');
    }
  }
  
  /// Set sleep timer
  Future<void> setSleepTimer(Duration duration) async {
    try {
      await _audioService.setSleepTimer(duration);
    } catch (e) {
      state = AudioPlayerState.error('Failed to set sleep timer: $e');
    }
  }
  
  /// Set voice volume
  Future<void> setVoiceVolume(double volume) async {
    try {
      await _audioService.setVoiceVolume(volume);
    } catch (e) {
      state = AudioPlayerState.error('Failed to set voice volume: $e');
    }
  }
  
  /// Set background sound volume
  Future<void> setBackgroundVolume(String soundId, double volume) async {
    try {
      await _audioService.setBackgroundVolume(soundId, volume);
    } catch (e) {
      state = AudioPlayerState.error('Failed to set background volume: $e');
    }
  }
  
  /// Clear error state
  void clearError() {
    if (state is AudioPlayerStateError) {
      state = const AudioPlayerState.ready();
    }
  }
}

/// Provider for the audio player notifier
final audioPlayerNotifierProvider = StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  final currentMeditationNotifier = ref.watch(currentMeditationProvider.notifier);
  
  final notifier = AudioPlayerNotifier(audioService, currentMeditationNotifier);
  notifier.initialize();
  
  return notifier;
});

/// State class for the audio player
class AudioPlayerState {
  final bool isInitial;
  final bool isLoading;
  final bool isReady;
  final bool hasError;
  final String? errorMessage;
  
  const AudioPlayerState({
    this.isInitial = false,
    this.isLoading = false,
    this.isReady = false,
    this.hasError = false,
    this.errorMessage,
  });
  
  /// Initial state
  const AudioPlayerState.initial()
      : isInitial = true,
        isLoading = false,
        isReady = false,
        hasError = false,
        errorMessage = null;
  
  /// Loading state
  const AudioPlayerState.loading()
      : isInitial = false,
        isLoading = true,
        isReady = false,
        hasError = false,
        errorMessage = null;
  
  /// Ready state
  const AudioPlayerState.ready()
      : isInitial = false,
        isLoading = false,
        isReady = true,
        hasError = false,
        errorMessage = null;
  
  /// Error state
  const AudioPlayerState.error(String message)
      : isInitial = false,
        isLoading = false,
        isReady = false,
        hasError = true,
        errorMessage = message;
}
