import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/meditation.dart';
import '../../../../core/providers/audio_player_provider.dart';
import '../../../../core/providers/meditation_provider.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/circular_progress_indicator.dart';
import '../widgets/player_controls.dart';
import '../widgets/sleep_timer_dialog.dart';

/// Meditation player screen for playing meditations
class MeditationPlayerScreen extends ConsumerStatefulWidget {
  final String meditationId;

  const MeditationPlayerScreen({
    Key? key,
    required this.meditationId,
  }) : super(key: key);

  @override
  ConsumerState<MeditationPlayerScreen> createState() => _MeditationPlayerScreenState();
}

class _MeditationPlayerScreenState extends ConsumerState<MeditationPlayerScreen>
    with SingleTickerProviderStateMixin {
  bool _showControls = true;
  late AnimationController _fadeController;
  Duration? _sleepTimer;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeController.forward();

    // Initialize meditation player
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMeditation();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadMeditation() async {
    // Load the meditation by ID if not already loaded
    final currentMeditation = ref.read(currentMeditationProvider);
    
    if (currentMeditation == null || currentMeditation.id != widget.meditationId) {
      final meditationAsync = ref.read(meditationByIdProvider(widget.meditationId));
      
      meditationAsync.whenData((meditation) {
        if (meditation != null) {
          // Set as current meditation
          ref.read(currentMeditationProvider.notifier).setMeditation(meditation);
          
          // Load meditation in audio player
          ref.read(audioPlayerNotifierProvider.notifier).loadMeditation(meditation);
        }
      });
    } else {
      // Meditation already loaded, just prepare audio player
      ref.read(audioPlayerNotifierProvider.notifier).loadMeditation(currentMeditation);
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      _fadeController.forward();
    } else {
      _fadeController.reverse();
    }
  }

  void _toggleFavorite() {
    ref.read(currentMeditationProvider.notifier).toggleFavorite();
  }

  void _showSleepTimerDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => SleepTimerDialog(
        currentTimer: _sleepTimer,
        onTimerSelected: (duration) {
          setState(() {
            _sleepTimer = duration;
          });
          
          if (duration != null) {
            ref.read(audioPlayerNotifierProvider.notifier).setSleepTimer(duration);
          }
          
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _closePlayer() {
    // Stop playback
    ref.read(audioPlayerNotifierProvider.notifier).stop();
    
    // Go back
    context.go(AppConstants.homeRoute);
  }

  @override
  Widget build(BuildContext context) {
    final meditationAsync = ref.watch(meditationByIdProvider(widget.meditationId));
    final audioPlayerState = ref.watch(audioPlayerNotifierProvider);
    final isPlaying = ref.watch(isPlayingProvider);
    final isPaused = ref.watch(isPausedProvider);
    final playbackPositionStream = ref.watch(playbackPositionProvider);
    
    return Scaffold(
      backgroundColor: AppColors.primaryDeepIndigo,
      body: meditationAsync.when(
        data: (meditation) {
          if (meditation == null) {
            return const Center(
              child: Text(
                'Meditation not found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          
          return GestureDetector(
            onTap: _toggleControls,
            child: SafeArea(
              child: Stack(
                children: [
                  // Background gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primaryDeepIndigo,
                          Color(0xFF272654),
                        ],
                      ),
                    ),
                  ),
                  
                  // Main content
                  Column(
                    children: [
                      // Header with close button and favorite
                      FadeTransition(
                        opacity: _fadeController,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Close button
                              IconButton(
                                icon: const Icon(Icons.close),
                                color: Colors.white,
                                onPressed: _closePlayer,
                              ),
                              
                              // Meditation name
                              Expanded(
                                child: Text(
                                  meditation.name,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              
                              // Favorite button
                              IconButton(
                                icon: Icon(
                                  meditation.isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                ),
                                color: meditation.isFavorite
                                    ? AppColors.accentGentleTeal
                                    : Colors.white,
                                onPressed: _toggleFavorite,
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Circular progress
                      Expanded(
                        child: Center(
                          child: playbackPositionStream.when(
                            data: (position) {
                              final duration = meditation.durationMinutes * 60;
                              final progress = position.inSeconds / duration;
                              
                              return CircularProgressIndicatorWidget(
                                progress: progress.clamp(0.0, 1.0),
                                currentTime: position,
                                totalTime: Duration(seconds: duration),
                                isPlaying: isPlaying,
                              );
                            },
                            loading: () => const CircularProgressIndicatorWidget(
                              progress: 0,
                              currentTime: Duration.zero,
                              totalTime: Duration.zero,
                              isPlaying: false,
                            ),
                            error: (_, __) => const CircularProgressIndicatorWidget(
                              progress: 0,
                              currentTime: Duration.zero,
                              totalTime: Duration.zero,
                              isPlaying: false,
                            ),
                          ),
                        ),
                      ),
                      
                      // Player controls
                      FadeTransition(
                        opacity: _fadeController,
                        child: PlayerControls(
                          isPlaying: isPlaying,
                          isPaused: isPaused,
                          onPlay: () {
                            if (isPaused) {
                              ref.read(audioPlayerNotifierProvider.notifier).resume();
                            } else {
                              ref.read(audioPlayerNotifierProvider.notifier).play();
                            }
                          },
                          onPause: () {
                            ref.read(audioPlayerNotifierProvider.notifier).pause();
                          },
                          onSkipForward: () {
                            ref.read(audioPlayerNotifierProvider.notifier).skipForward();
                          },
                          onSkipBackward: () {
                            ref.read(audioPlayerNotifierProvider.notifier).skipBackward();
                          },
                          onSleepTimer: _showSleepTimerDialog,
                          hasActiveSleepTimer: _sleepTimer != null,
                        ),
                      ),
                      
                      // Bottom padding
                      const SizedBox(height: 24),
                    ],
                  ),
                  
                  // Loading or error overlay
                  if (audioPlayerState is AudioPlayerStateLoading)
                    Container(
                      color: Colors.black54,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  
                  // Error message
                  if (audioPlayerState is AudioPlayerStateError)
                    Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.white,
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              audioPlayerState.errorMessage ?? 'An error occurred',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                ref.read(audioPlayerNotifierProvider.notifier).clearError();
                                _loadMeditation();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppColors.primaryDeepIndigo,
                              ),
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading meditation: $error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.go(AppConstants.homeRoute);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryDeepIndigo,
                  ),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
