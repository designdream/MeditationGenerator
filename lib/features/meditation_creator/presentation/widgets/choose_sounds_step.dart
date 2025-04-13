import 'package:flutter/material.dart';
import '../../../../core/models/meditation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Step 3: Choose background sounds for meditation
class ChooseSoundsStep extends StatefulWidget {
  final Meditation meditation;
  final Function(Sound) onAddSound;
  final Function(String) onRemoveSound;
  final Function(String, double) onUpdateVolume;
  final Function(double) onUpdateBackgroundVolume;

  const ChooseSoundsStep({
    Key? key,
    required this.meditation,
    required this.onAddSound,
    required this.onRemoveSound,
    required this.onUpdateVolume,
    required this.onUpdateBackgroundVolume,
  }) : super(key: key);

  @override
  State<ChooseSoundsStep> createState() => _ChooseSoundsStepState();
}

class _ChooseSoundsStepState extends State<ChooseSoundsStep> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'Nature';
  bool _isPlaying = false;
  String? _playingId;
  double _backgroundVolumeDuringGuidance = 0.5;

  // Sample sounds - in a real app, these would come from a backend service
  final List<Sound> _natureSounds = [
    Sound(
      id: 'rain',
      name: 'Gentle Rain',
      category: 'nature',
      volume: 0.7,
      assetPath: 'assets/audio/nature/rain.mp3',
    ),
    Sound(
      id: 'forest',
      name: 'Forest Sounds',
      category: 'nature',
      volume: 0.7,
      assetPath: 'assets/audio/nature/forest.mp3',
    ),
    Sound(
      id: 'waves',
      name: 'Ocean Waves',
      category: 'nature',
      volume: 0.7,
      assetPath: 'assets/audio/nature/waves.mp3',
    ),
    Sound(
      id: 'stream',
      name: 'Flowing Stream',
      category: 'nature',
      volume: 0.7,
      assetPath: 'assets/audio/nature/stream.mp3',
    ),
    Sound(
      id: 'birds',
      name: 'Birdsong',
      category: 'nature',
      volume: 0.7,
      assetPath: 'assets/audio/nature/birds.mp3',
    ),
    Sound(
      id: 'thunder',
      name: 'Distant Thunder',
      category: 'nature',
      volume: 0.7,
      assetPath: 'assets/audio/nature/thunder.mp3',
    ),
  ];

  final List<Sound> _musicSounds = [
    Sound(
      id: 'piano',
      name: 'Peaceful Piano',
      category: 'music',
      volume: 0.7,
      assetPath: 'assets/audio/music/piano.mp3',
    ),
    Sound(
      id: 'ambient',
      name: 'Ambient Melody',
      category: 'music',
      volume: 0.7,
      assetPath: 'assets/audio/music/ambient.mp3',
    ),
    Sound(
      id: 'strings',
      name: 'Soothing Strings',
      category: 'music',
      volume: 0.7,
      assetPath: 'assets/audio/music/strings.mp3',
    ),
    Sound(
      id: 'bowls',
      name: 'Singing Bowls',
      category: 'music',
      volume: 0.7,
      assetPath: 'assets/audio/music/bowls.mp3',
    ),
  ];

  final List<Sound> _ambientSounds = [
    Sound(
      id: 'whitenoise',
      name: 'White Noise',
      category: 'ambient',
      volume: 0.7,
      assetPath: 'assets/audio/ambient/whitenoise.mp3',
    ),
    Sound(
      id: 'brownoise',
      name: 'Brown Noise',
      category: 'ambient',
      volume: 0.7,
      assetPath: 'assets/audio/ambient/brownoise.mp3',
    ),
    Sound(
      id: 'pinknoise',
      name: 'Pink Noise',
      category: 'ambient',
      volume: 0.7,
      assetPath: 'assets/audio/ambient/pinknoise.mp3',
    ),
    Sound(
      id: 'fan',
      name: 'Fan Sound',
      category: 'ambient',
      volume: 0.7,
      assetPath: 'assets/audio/ambient/fan.mp3',
    ),
    Sound(
      id: 'fireplace',
      name: 'Crackling Fire',
      category: 'ambient',
      volume: 0.7,
      assetPath: 'assets/audio/ambient/fireplace.mp3',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabChange);
    _backgroundVolumeDuringGuidance = widget.meditation.audio.backgroundVolumeDuringGuidance;
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        switch (_tabController.index) {
          case 0:
            _selectedCategory = 'Nature';
            break;
          case 1:
            _selectedCategory = 'Music';
            break;
          case 2:
            _selectedCategory = 'Ambient';
            break;
        }
      });
    }
  }

  void _playSound(Sound sound) {
    // In a real app, this would play audio
    setState(() {
      _isPlaying = true;
      _playingId = sound.id;
    });
    
    // Simulate audio playback ending after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _playingId == sound.id) {
        setState(() {
          _isPlaying = false;
          _playingId = null;
        });
      }
    });
    
    // Show a snackbar message for now
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Playing ${sound.name} sample...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addSound(Sound sound) {
    final selectedSounds = widget.meditation.audio.backgroundSounds;
    
    // Check if already added
    if (selectedSounds.any((s) => s.id == sound.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This sound is already added'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    // Check if maximum sounds reached (3)
    if (selectedSounds.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum of 3 sounds can be added'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    widget.onAddSound(sound);
  }

  List<Sound> _getSoundsByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'nature':
        return _natureSounds;
      case 'music':
        return _musicSounds;
      case 'ambient':
        return _ambientSounds;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedSounds = widget.meditation.audio.backgroundSounds;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            'Choose your soundscape',
            style: AppTypography.subheading2,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Select background sounds to enhance your meditation. You can add up to 3 sounds and control their volumes individually.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkGray.withOpacity(0.7),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Selected sounds
          if (selectedSounds.isNotEmpty) ...[
            Text(
              'Selected Sounds',
              style: AppTypography.subheading3,
            ),
            
            const SizedBox(height: 8),
            
            // List of selected sounds with sliders
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedSounds.length,
              itemBuilder: (context, index) {
                final sound = selectedSounds[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        // Sound icon
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.secondarySoftLavender,
                          child: Icon(
                            _getSoundIcon(sound.category),
                            color: AppColors.primaryDeepIndigo,
                          ),
                        ),
                        
                        const SizedBox(width: 12),
                        
                        // Sound name
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sound.name,
                                style: AppTypography.subheading3,
                              ),
                              
                              // Volume slider
                              Slider(
                                value: sound.volume,
                                min: 0.0,
                                max: 1.0,
                                divisions: 10,
                                label: '${(sound.volume * 100).round()}%',
                                onChanged: (value) {
                                  widget.onUpdateVolume(sound.id, value);
                                },
                              ),
                            ],
                          ),
                        ),
                        
                        // Remove button
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => widget.onRemoveSound(sound.id),
                          color: Colors.redAccent,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 8),
            
            // Divider
            const Divider(),
            
            const SizedBox(height: 8),
          ],
          
          // Background volume during guidance
          Text(
            'Background Volume During Guidance',
            style: AppTypography.subheading3,
          ),
          
          const SizedBox(height: 4),
          
          Text(
            'Adjust how loud the background sounds are when the voice guide is speaking',
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.darkGray.withOpacity(0.7),
            ),
          ),
          
          Row(
            children: [
              const Icon(
                Icons.volume_down,
                size: 20,
                color: AppColors.darkGray,
              ),
              Expanded(
                child: Slider(
                  value: _backgroundVolumeDuringGuidance,
                  min: 0.1,
                  max: 1.0,
                  divisions: 9,
                  label: '${(_backgroundVolumeDuringGuidance * 100).round()}%',
                  onChanged: (value) {
                    setState(() {
                      _backgroundVolumeDuringGuidance = value;
                    });
                    widget.onUpdateBackgroundVolume(value);
                  },
                ),
              ),
              const Icon(
                Icons.volume_up,
                size: 20,
                color: AppColors.darkGray,
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Category tabs
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primaryDeepIndigo,
            unselectedLabelColor: AppColors.darkGray,
            indicatorColor: AppColors.primaryDeepIndigo,
            tabs: const [
              Tab(text: 'Nature'),
              Tab(text: 'Music'),
              Tab(text: 'Ambient'),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Sound grid by category
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSoundGrid(_natureSounds),
                _buildSoundGrid(_musicSounds),
                _buildSoundGrid(_ambientSounds),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoundGrid(List<Sound> sounds) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: sounds.length,
      itemBuilder: (context, index) {
        final sound = sounds[index];
        final isPlaying = _isPlaying && _playingId == sound.id;
        final isAdded = widget.meditation.audio.backgroundSounds.any((s) => s.id == sound.id);
        
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isAdded 
                  ? AppColors.accentGentleTeal 
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: () => _playSound(sound),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Sound icon
                  Icon(
                    _getSoundIcon(sound.category),
                    size: 36,
                    color: _getIconColor(sound.category),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Sound name
                  Text(
                    sound.name,
                    textAlign: TextAlign.center,
                    style: AppTypography.subheading3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const Spacer(),
                  
                  // Play/Add buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Play button
                      IconButton(
                        icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                        onPressed: () => _playSound(sound),
                        color: AppColors.primaryDeepIndigo,
                      ),
                      
                      // Add button
                      IconButton(
                        icon: Icon(isAdded ? Icons.check_circle : Icons.add_circle_outline),
                        onPressed: isAdded ? null : () => _addSound(sound),
                        color: isAdded 
                            ? AppColors.accentGentleTeal 
                            : AppColors.primaryDeepIndigo,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getSoundIcon(String category) {
    switch (category.toLowerCase()) {
      case 'nature':
        return Icons.terrain_outlined;
      case 'music':
        return Icons.music_note_outlined;
      case 'ambient':
        return Icons.surround_sound_outlined;
      default:
        return Icons.audio_file_outlined;
    }
  }

  Color _getIconColor(String category) {
    switch (category.toLowerCase()) {
      case 'nature':
        return Colors.green;
      case 'music':
        return Colors.blue;
      case 'ambient':
        return Colors.purple;
      default:
        return AppColors.primaryDeepIndigo;
    }
  }
}
