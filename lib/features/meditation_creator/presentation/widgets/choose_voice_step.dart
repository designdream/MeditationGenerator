import 'package:flutter/material.dart';
import '../../../../core/models/meditation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Step 2: Choose meditation voice guide
class ChooseVoiceStep extends StatefulWidget {
  final Meditation meditation;
  final Function(Voice) onSelectVoice;

  const ChooseVoiceStep({
    Key? key,
    required this.meditation,
    required this.onSelectVoice,
  }) : super(key: key);

  @override
  State<ChooseVoiceStep> createState() => _ChooseVoiceStepState();
}

class _ChooseVoiceStepState extends State<ChooseVoiceStep> {
  late Voice _selectedVoice;
  double _voiceSpeed = 1.0;
  double _voiceVolume = 0.7;
  bool _isPlaying = false;

  // Sample voices - in a real app, these would come from a backend service
  final List<Voice> _availableVoices = [
    Voice(
      id: 'calm-female',
      name: 'Calm Female',
      gender: 'female',
      accent: 'American',
      tone: 'calm',
      speed: 1.0,
      volume: 0.7,
      assetPath: 'assets/audio/voices/calm_female.mp3',
    ),
    Voice(
      id: 'soothing-male',
      name: 'Soothing Male',
      gender: 'male',
      accent: 'British',
      tone: 'soothing',
      speed: 1.0,
      volume: 0.7,
      assetPath: 'assets/audio/voices/soothing_male.mp3',
    ),
    Voice(
      id: 'energetic-female',
      name: 'Energetic Female',
      gender: 'female',
      accent: 'American',
      tone: 'energetic',
      speed: 1.0,
      volume: 0.7,
      assetPath: 'assets/audio/voices/energetic_female.mp3',
    ),
    Voice(
      id: 'deep-male',
      name: 'Deep Male',
      gender: 'male',
      accent: 'American',
      tone: 'deep',
      speed: 1.0,
      volume: 0.7,
      assetPath: 'assets/audio/voices/deep_male.mp3',
    ),
    Voice(
      id: 'gentle-female',
      name: 'Gentle Female',
      gender: 'female',
      accent: 'British',
      tone: 'gentle',
      speed: 1.0,
      volume: 0.7,
      assetPath: 'assets/audio/voices/gentle_female.mp3',
    ),
    Voice(
      id: 'warm-male',
      name: 'Warm Male',
      gender: 'male',
      accent: 'Australian',
      tone: 'warm',
      speed: 1.0,
      volume: 0.7,
      assetPath: 'assets/audio/voices/warm_male.mp3',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedVoice = widget.meditation.audio.voice;
    _voiceSpeed = _selectedVoice.speed;
    _voiceVolume = _selectedVoice.volume;
  }

  void _playVoiceSample(Voice voice) {
    // In a real app, this would play audio
    setState(() {
      _isPlaying = true;
    });
    
    // Simulate audio playback ending after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
    
    // Show a snackbar message for now
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing ${voice.name} sample...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateVoice() {
    final updatedVoice = _selectedVoice.copyWith(
      speed: _voiceSpeed,
      volume: _voiceVolume,
    );
    widget.onSelectVoice(updatedVoice);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            'Choose your guide',
            style: AppTypography.subheading2,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Select a voice to guide your meditation. Each voice has unique characteristics.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkGray.withOpacity(0.7),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Voice selection
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Voice filters (gender, accent)
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: true,
                        onSelected: (selected) {
                          // Filter logic would go here
                        },
                      ),
                      FilterChip(
                        label: const Text('Female'),
                        selected: false,
                        onSelected: (selected) {
                          // Filter logic would go here
                        },
                      ),
                      FilterChip(
                        label: const Text('Male'),
                        selected: false,
                        onSelected: (selected) {
                          // Filter logic would go here
                        },
                      ),
                      FilterChip(
                        label: const Text('Calm'),
                        selected: false,
                        onSelected: (selected) {
                          // Filter logic would go here
                        },
                      ),
                      FilterChip(
                        label: const Text('Energetic'),
                        selected: false,
                        onSelected: (selected) {
                          // Filter logic would go here
                        },
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Voice list
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _availableVoices.length,
                    itemBuilder: (context, index) {
                      final voice = _availableVoices[index];
                      final isSelected = voice.id == _selectedVoice.id;
                      
                      return Card(
                        elevation: isSelected ? 2 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: isSelected 
                                ? AppColors.primaryDeepIndigo 
                                : Colors.grey.shade300,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        margin: const EdgeInsets.only(bottom: 12),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedVoice = voice;
                            });
                            _updateVoice();
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                // Voice avatar
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: isSelected
                                      ? AppColors.primaryDeepIndigo
                                      : Colors.grey.shade200,
                                  child: Icon(
                                    voice.gender == 'female'
                                        ? Icons.record_voice_over
                                        : Icons.mic,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.darkGray,
                                  ),
                                ),
                                
                                const SizedBox(width: 16),
                                
                                // Voice info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        voice.name,
                                        style: AppTypography.subheading3,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${voice.accent} · ${voice.tone}',
                                        style: AppTypography.caption.copyWith(
                                          color: AppColors.darkGray.withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // Play button
                                IconButton(
                                  icon: Icon(
                                    _isPlaying ? Icons.stop_circle : Icons.play_circle,
                                    size: 36,
                                  ),
                                  color: AppColors.accentGentleTeal,
                                  onPressed: () => _playVoiceSample(voice),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Voice speed adjustment
                  Text(
                    'Voice Speed',
                    style: AppTypography.subheading3,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      const Icon(
                        Icons.speed,
                        size: 20,
                        color: AppColors.darkGray,
                      ),
                      Expanded(
                        child: Slider(
                          value: _voiceSpeed,
                          min: 0.5,
                          max: 1.5,
                          divisions: 10,
                          label: _getSpeedLabel(_voiceSpeed),
                          onChanged: (value) {
                            setState(() {
                              _voiceSpeed = value;
                            });
                          },
                          onChangeEnd: (value) {
                            _updateVoice();
                          },
                        ),
                      ),
                      Text(
                        _getSpeedLabel(_voiceSpeed),
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Voice volume adjustment
                  Text(
                    'Voice Volume',
                    style: AppTypography.subheading3,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Row(
                    children: [
                      const Icon(
                        Icons.volume_up,
                        size: 20,
                        color: AppColors.darkGray,
                      ),
                      Expanded(
                        child: Slider(
                          value: _voiceVolume,
                          min: 0.1,
                          max: 1.0,
                          divisions: 9,
                          label: '${(_voiceVolume * 100).round()}%',
                          onChanged: (value) {
                            setState(() {
                              _voiceVolume = value;
                            });
                          },
                          onChangeEnd: (value) {
                            _updateVoice();
                          },
                        ),
                      ),
                      Text(
                        '${(_voiceVolume * 100).round()}%',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSpeedLabel(double speed) {
    if (speed < 0.75) {
      return 'Slow';
    } else if (speed < 1.0) {
      return 'Normal -';
    } else if (speed == 1.0) {
      return 'Normal';
    } else if (speed < 1.25) {
      return 'Normal +';
    } else {
      return 'Fast';
    }
  }
}
