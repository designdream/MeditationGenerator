import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import '../models/meditation.dart';

/// Service for handling audio playback and management
class AudioService {
  // Audio players
  final AudioPlayer _voicePlayer = AudioPlayer();
  final List<AudioPlayer> _backgroundPlayers = [];
  
  // Current meditation
  Meditation? _currentMeditation;
  
  // Playback state
  bool _isPlaying = false;
  bool _isPaused = false;
  int _currentPosition = 0;
  
  // Stream controllers
  final _playbackStateController = StreamController<PlaybackState>.broadcast();
  final _positionController = StreamController<Duration>.broadcast();
  
  // Getters
  Stream<PlaybackState> get playbackStateStream => _playbackStateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  bool get isPlaying => _isPlaying;
  bool get isPaused => _isPaused;
  int get currentPosition => _currentPosition;
  Meditation? get currentMeditation => _currentMeditation;

  /// Initialize the audio service
  Future<void> initialize() async {
    try {
      // Configure audio session for meditation playback
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          usage: AndroidAudioUsage.media,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ));
      
      // Set up position tracking
      _voicePlayer.positionStream.listen((position) {
        _currentPosition = position.inMilliseconds;
        _positionController.add(position);
      });
      
      // Set up playback state tracking
      _voicePlayer.playerStateStream.listen((playerState) {
        _isPlaying = playerState.playing;
        _isPaused = !playerState.playing && playerState.processingState != ProcessingState.completed;
        
        _updatePlaybackState();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing audio service: $e');
      }
      throw Exception('Failed to initialize audio service: $e');
    }
  }
  
  /// Load a meditation for playback
  Future<void> loadMeditation(Meditation meditation) async {
    try {
      _currentMeditation = meditation;
      
      // Clear any existing players
      await _stopAndDisposeAll();
      
      // Load voice guidance
      await _loadVoice(meditation.audio.voice);
      
      // Load background sounds
      await _loadBackgroundSounds(meditation.audio.backgroundSounds, meditation.audio.backgroundVolumeDuringGuidance);
      
      _updatePlaybackState();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading meditation: $e');
      }
      throw Exception('Failed to load meditation: $e');
    }
  }
  
  /// Play the loaded meditation
  Future<void> play() async {
    if (_currentMeditation == null) {
      throw Exception('No meditation loaded');
    }
    
    try {
      // Start voice guidance
      await _voicePlayer.play();
      
      // Start background sounds
      for (final player in _backgroundPlayers) {
        await player.play();
      }
      
      _isPlaying = true;
      _isPaused = false;
      _updatePlaybackState();
    } catch (e) {
      if (kDebugMode) {
        print('Error playing meditation: $e');
      }
      throw Exception('Failed to play meditation: $e');
    }
  }
  
  /// Pause playback
  Future<void> pause() async {
    try {
      // Pause voice guidance
      await _voicePlayer.pause();
      
      // Pause background sounds
      for (final player in _backgroundPlayers) {
        await player.pause();
      }
      
      _isPlaying = false;
      _isPaused = true;
      _updatePlaybackState();
    } catch (e) {
      if (kDebugMode) {
        print('Error pausing meditation: $e');
      }
      throw Exception('Failed to pause meditation: $e');
    }
  }
  
  /// Resume playback
  Future<void> resume() async {
    try {
      // Resume voice guidance
      await _voicePlayer.play();
      
      // Resume background sounds
      for (final player in _backgroundPlayers) {
        await player.play();
      }
      
      _isPlaying = true;
      _isPaused = false;
      _updatePlaybackState();
    } catch (e) {
      if (kDebugMode) {
        print('Error resuming meditation: $e');
      }
      throw Exception('Failed to resume meditation: $e');
    }
  }
  
  /// Stop playback
  Future<void> stop() async {
    try {
      // Stop voice guidance
      await _voicePlayer.stop();
      
      // Stop background sounds
      for (final player in _backgroundPlayers) {
        await player.stop();
      }
      
      _isPlaying = false;
      _isPaused = false;
      _updatePlaybackState();
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping meditation: $e');
      }
      throw Exception('Failed to stop meditation: $e');
    }
  }
  
  /// Seek to position
  Future<void> seekTo(Duration position) async {
    try {
      await _voicePlayer.seek(position);
    } catch (e) {
      if (kDebugMode) {
        print('Error seeking: $e');
      }
      throw Exception('Failed to seek: $e');
    }
  }
  
  /// Skip forward
  Future<void> skipForward(Duration duration) async {
    try {
      final currentPosition = _voicePlayer.position;
      final newPosition = currentPosition + duration;
      await _voicePlayer.seek(newPosition);
    } catch (e) {
      if (kDebugMode) {
        print('Error skipping forward: $e');
      }
      throw Exception('Failed to skip forward: $e');
    }
  }
  
  /// Skip backward
  Future<void> skipBackward(Duration duration) async {
    try {
      final currentPosition = _voicePlayer.position;
      final newPosition = currentPosition - duration;
      await _voicePlayer.seek(newPosition < Duration.zero ? Duration.zero : newPosition);
    } catch (e) {
      if (kDebugMode) {
        print('Error skipping backward: $e');
      }
      throw Exception('Failed to skip backward: $e');
    }
  }
  
  /// Set sleep timer
  Future<void> setSleepTimer(Duration duration) async {
    try {
      // Implement sleep timer logic
      Timer(duration, () {
        if (_isPlaying) {
          stop();
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error setting sleep timer: $e');
      }
      throw Exception('Failed to set sleep timer: $e');
    }
  }
  
  /// Adjust voice volume
  Future<void> setVoiceVolume(double volume) async {
    try {
      await _voicePlayer.setVolume(volume);
    } catch (e) {
      if (kDebugMode) {
        print('Error setting voice volume: $e');
      }
      throw Exception('Failed to set voice volume: $e');
    }
  }
  
  /// Adjust background sound volume
  Future<void> setBackgroundVolume(String soundId, double volume) async {
    try {
      final index = _currentMeditation?.audio.backgroundSounds.indexWhere((sound) => sound.id == soundId) ?? -1;
      
      if (index >= 0 && index < _backgroundPlayers.length) {
        await _backgroundPlayers[index].setVolume(volume);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error setting background volume: $e');
      }
      throw Exception('Failed to set background volume: $e');
    }
  }
  
  /// Dispose resources
  Future<void> dispose() async {
    await _stopAndDisposeAll();
    
    _playbackStateController.close();
    _positionController.close();
  }
  
  // Private methods
  
  /// Load voice guidance audio
  Future<void> _loadVoice(Voice voice) async {
    try {
      String? audioSource;
      
      if (voice.assetPath != null) {
        // Load from asset
        audioSource = voice.assetPath;
        await _voicePlayer.setAsset(audioSource);
      } else if (voice.url != null) {
        // Load from URL or download for offline use
        final file = await _getAudioFile(voice.url!);
        audioSource = file.path;
        await _voicePlayer.setFilePath(audioSource);
      } else {
        throw Exception('No audio source found for voice');
      }
      
      // Set voice properties
      await _voicePlayer.setVolume(voice.volume);
      await _voicePlayer.setSpeed(voice.speed);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading voice: $e');
      }
      throw Exception('Failed to load voice: $e');
    }
  }
  
  /// Load background sounds
  Future<void> _loadBackgroundSounds(List<Sound> sounds, double backgroundVolumeDuringGuidance) async {
    try {
      // Dispose any existing background players
      for (final player in _backgroundPlayers) {
        await player.dispose();
      }
      _backgroundPlayers.clear();
      
      // Create and configure new players for each sound
      for (final sound in sounds) {
        final player = AudioPlayer();
        
        String? audioSource;
        
        if (sound.assetPath != null) {
          // Load from asset
          audioSource = sound.assetPath;
          await player.setAsset(audioSource);
        } else if (sound.url != null) {
          // Load from URL or download for offline use
          final file = await _getAudioFile(sound.url!);
          audioSource = file.path;
          await player.setFilePath(audioSource);
        } else {
          continue; // Skip this sound
        }
        
        // Set looping and volume
        await player.setLoopMode(LoopMode.all);
        await player.setVolume(sound.volume);
        
        // Add to background players
        _backgroundPlayers.add(player);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading background sounds: $e');
      }
      throw Exception('Failed to load background sounds: $e');
    }
  }
  
  /// Get audio file from URL (download if needed)
  Future<File> _getAudioFile(String url) async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final fileName = url.split('/').last;
      final filePath = '${cacheDir.path}/$fileName';
      final file = File(filePath);
      
      if (await file.exists()) {
        // Use cached file
        return file;
      }
      
      // Download file
      final response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      
      await file.writeAsBytes(response.data);
      return file;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting audio file: $e');
      }
      throw Exception('Failed to get audio file: $e');
    }
  }
  
  /// Stop and dispose all players
  Future<void> _stopAndDisposeAll() async {
    try {
      // Stop and reset voice player
      await _voicePlayer.stop();
      await _voicePlayer.seek(Duration.zero);
      
      // Stop and dispose background players
      for (final player in _backgroundPlayers) {
        await player.stop();
        await player.dispose();
      }
      _backgroundPlayers.clear();
    } catch (e) {
      if (kDebugMode) {
        print('Error stopping and disposing players: $e');
      }
      // Don't throw here, just log the error
    }
  }
  
  /// Update playback state
  void _updatePlaybackState() {
    _playbackStateController.add(
      PlaybackState(
        isPlaying: _isPlaying,
        isPaused: _isPaused,
        currentPosition: Duration(milliseconds: _currentPosition),
        totalDuration: _voicePlayer.duration ?? Duration.zero,
      ),
    );
  }
}

/// Playback state model
class PlaybackState {
  final bool isPlaying;
  final bool isPaused;
  final Duration currentPosition;
  final Duration totalDuration;
  
  PlaybackState({
    required this.isPlaying,
    required this.isPaused,
    required this.currentPosition,
    required this.totalDuration,
  });
}
