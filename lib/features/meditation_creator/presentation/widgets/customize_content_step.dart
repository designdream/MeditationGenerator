import 'package:flutter/material.dart';
import '../../../../core/models/meditation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Step 4: Customize meditation content
class CustomizeContentStep extends StatefulWidget {
  final Meditation meditation;
  final Function(MeditationContent) onUpdateContent;
  final Function(int) onUpdateDuration;

  const CustomizeContentStep({
    Key? key,
    required this.meditation,
    required this.onUpdateContent,
    required this.onUpdateDuration,
  }) : super(key: key);

  @override
  State<CustomizeContentStep> createState() => _CustomizeContentStepState();
}

class _CustomizeContentStepState extends State<CustomizeContentStep> {
  late int _durationMinutes;
  late int _guidanceLevel;
  late bool _includeIntroduction;
  late bool _includeBodyScan;
  late bool _includeSilencePeriods;
  late bool _includeClosingGratitude;
  late int _silencePeriodDuration;
  late int _breathingPace;
  bool _showAdvancedOptions = false;

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  void _initializeValues() {
    _durationMinutes = widget.meditation.durationMinutes;
    _guidanceLevel = widget.meditation.content.guidanceLevel;
    _includeIntroduction = widget.meditation.content.includeIntroduction;
    _includeBodyScan = widget.meditation.content.includeBodyScan;
    _includeSilencePeriods = widget.meditation.content.includeSilencePeriods;
    _includeClosingGratitude = widget.meditation.content.includeClosingGratitude;
    _silencePeriodDuration = widget.meditation.content.silencePeriodDuration;
    _breathingPace = widget.meditation.content.breathingPace;
  }

  void _updateContent() {
    final updatedContent = MeditationContent(
      theme: widget.meditation.content.theme,
      guidanceLevel: _guidanceLevel,
      includeIntroduction: _includeIntroduction,
      includeBodyScan: _includeBodyScan,
      includeSilencePeriods: _includeSilencePeriods,
      includeClosingGratitude: _includeClosingGratitude,
      silencePeriodDuration: _silencePeriodDuration,
      breathingPace: _breathingPace,
    );
    
    widget.onUpdateContent(updatedContent);
  }

  String _getDurationFormatted(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '$hours hour${hours > 1 ? 's' : ''}';
      } else {
        return '$hours hour${hours > 1 ? 's' : ''} $remainingMinutes min';
      }
    }
  }

  String _getGuidanceLevelLabel(int level) {
    switch (level) {
      case 1:
        return 'Minimal';
      case 2:
        return 'Moderate';
      case 3:
        return 'Detailed';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            Text(
              'Customize your experience',
              style: AppTypography.subheading2,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Adjust the final details for your meditation to create the perfect experience.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkGray.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Duration slider
            Text(
              'Duration',
              style: AppTypography.subheading3,
            ),
            
            const SizedBox(height: 4),
            
            Text(
              'How long would you like your meditation to be?',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.darkGray.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                const Icon(
                  Icons.timer_outlined,
                  size: 20,
                  color: AppColors.darkGray,
                ),
                Expanded(
                  child: Slider(
                    value: _durationMinutes.toDouble(),
                    min: 1,
                    max: 60,
                    divisions: 59,
                    label: _getDurationFormatted(_durationMinutes),
                    onChanged: (value) {
                      setState(() {
                        _durationMinutes = value.round();
                      });
                    },
                    onChangeEnd: (value) {
                      widget.onUpdateDuration(_durationMinutes);
                    },
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    _getDurationFormatted(_durationMinutes),
                    style: AppTypography.bodySmall,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Guidance level
            Text(
              'Guidance Level',
              style: AppTypography.subheading3,
            ),
            
            const SizedBox(height: 4),
            
            Text(
              'How much verbal guidance would you like?',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.darkGray.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildGuidanceLevelButton(1, 'Minimal'),
                _buildGuidanceLevelButton(2, 'Moderate'),
                _buildGuidanceLevelButton(3, 'Detailed'),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Toggle options
            Text(
              'Components',
              style: AppTypography.subheading3,
            ),
            
            const SizedBox(height: 4),
            
            Text(
              'Select which components to include in your meditation',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.darkGray.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildToggleOption(
              'Include introduction',
              'A brief welcome and session overview',
              _includeIntroduction,
              (value) {
                setState(() {
                  _includeIntroduction = value ?? false;
                });
                _updateContent();
              },
            ),
            
            _buildToggleOption(
              'Include body scan',
              'Guided awareness through different parts of your body',
              _includeBodyScan,
              (value) {
                setState(() {
                  _includeBodyScan = value ?? false;
                });
                _updateContent();
              },
            ),
            
            _buildToggleOption(
              'Include silence periods',
              'Periods of silence for self-guided meditation',
              _includeSilencePeriods,
              (value) {
                setState(() {
                  _includeSilencePeriods = value ?? false;
                });
                _updateContent();
              },
            ),
            
            _buildToggleOption(
              'Include closing gratitude',
              'End meditation with expressions of gratitude',
              _includeClosingGratitude,
              (value) {
                setState(() {
                  _includeClosingGratitude = value ?? false;
                });
                _updateContent();
              },
            ),
            
            const SizedBox(height: 24),
            
            // Advanced options toggle
            InkWell(
              onTap: () {
                setState(() {
                  _showAdvancedOptions = !_showAdvancedOptions;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Icon(
                      _showAdvancedOptions
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: AppColors.primaryDeepIndigo,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Advanced Options',
                      style: AppTypography.subheading3,
                    ),
                  ],
                ),
              ),
            ),
            
            // Advanced options
            if (_showAdvancedOptions) ...[
              const SizedBox(height: 16),
              
              // Silence period duration (if silence periods are included)
              if (_includeSilencePeriods) ...[
                Text(
                  'Silence Period Duration',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  'How long each period of silence should last',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.darkGray.withOpacity(0.7),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Row(
                  children: [
                    const Icon(
                      Icons.hourglass_empty,
                      size: 20,
                      color: AppColors.darkGray,
                    ),
                    Expanded(
                      child: Slider(
                        value: _silencePeriodDuration.toDouble(),
                        min: 10,
                        max: 120,
                        divisions: 11,
                        label: '${_silencePeriodDuration} sec',
                        onChanged: (value) {
                          setState(() {
                            _silencePeriodDuration = value.round();
                          });
                        },
                        onChangeEnd: (value) {
                          _updateContent();
                        },
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        '${_silencePeriodDuration} sec',
                        style: AppTypography.bodySmall,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
              ],
              
              // Breathing pace
              Text(
                'Breathing Pace',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(height: 4),
              
              Text(
                'Seconds per breath cycle (inhale and exhale)',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.darkGray.withOpacity(0.7),
                ),
              ),
              
              const SizedBox(height: 8),
              
              Row(
                children: [
                  const Icon(
                    Icons.air,
                    size: 20,
                    color: AppColors.darkGray,
                  ),
                  Expanded(
                    child: Slider(
                      value: _breathingPace.toDouble(),
                      min: 2,
                      max: 10,
                      divisions: 8,
                      label: '${_breathingPace} sec',
                      onChanged: (value) {
                        setState(() {
                          _breathingPace = value.round();
                        });
                      },
                      onChangeEnd: (value) {
                        _updateContent();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      '${_breathingPace} sec',
                      style: AppTypography.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
            
            // Bottom spacing
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidanceLevelButton(int level, String label) {
    final isSelected = _guidanceLevel == level;
    
    return InkWell(
      onTap: () {
        setState(() {
          _guidanceLevel = level;
        });
        _updateContent();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDeepIndigo : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryDeepIndigo : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _getGuidanceLevelIcon(level),
              color: isSelected ? Colors.white : AppColors.darkGray,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.darkGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleOption(
    String title,
    String description,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.scale(
            scale: 1.1,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.darkGray.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getGuidanceLevelIcon(int level) {
    switch (level) {
      case 1:
        return Icons.chat_bubble_outline;
      case 2:
        return Icons.chat_bubble;
      case 3:
        return Icons.chat;
      default:
        return Icons.chat_bubble_outline;
    }
  }
}
