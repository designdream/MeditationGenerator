import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final bool isPaused;
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onSkipForward;
  final VoidCallback onSkipBackward;
  final VoidCallback onSleepTimer;
  final bool hasActiveSleepTimer;

  const PlayerControls({
    Key? key,
    required this.isPlaying,
    required this.isPaused,
    required this.onPlay,
    required this.onPause,
    required this.onSkipForward,
    required this.onSkipBackward,
    required this.onSleepTimer,
    required this.hasActiveSleepTimer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Main controls row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Skip backward
            _buildIconButton(
              icon: Icons.replay_10,
              onPressed: onSkipBackward,
              size: 32,
              padded: true,
            ),
            
            const SizedBox(width: 32),
            
            // Play/Pause button
            _buildPlayPauseButton(),
            
            const SizedBox(width: 32),
            
            // Skip forward
            _buildIconButton(
              icon: Icons.forward_10,
              onPressed: onSkipForward,
              size: 32,
              padded: true,
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        
        // Sleep timer button
        GestureDetector(
          onTap: onSleepTimer,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: hasActiveSleepTimer
                  ? AppColors.accentGentleTeal.withOpacity(0.2)
                  : Colors.white.withOpacity(0.1),
              border: hasActiveSleepTimer
                  ? Border.all(color: AppColors.accentGentleTeal, width: 1)
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.nightlight_outlined,
                  color: hasActiveSleepTimer
                      ? AppColors.accentGentleTeal
                      : Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  hasActiveSleepTimer ? 'Sleep Timer Active' : 'Sleep Timer',
                  style: TextStyle(
                    color: hasActiveSleepTimer
                        ? AppColors.accentGentleTeal
                        : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayPauseButton() {
    return GestureDetector(
      onTap: isPlaying ? onPause : onPlay,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: AppColors.primaryDeepIndigo,
            size: 36,
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    required double size,
    bool padded = false,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: padded ? const EdgeInsets.all(12) : EdgeInsets.zero,
        decoration: padded
            ? BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              )
            : null,
        child: Icon(
          icon,
          color: Colors.white,
          size: size,
        ),
      ),
    );
  }
}
