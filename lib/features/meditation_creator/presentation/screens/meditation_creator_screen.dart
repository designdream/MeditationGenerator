import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/meditation.dart';
import '../../../../core/providers/meditation_provider.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/choose_purpose_step.dart';
import '../widgets/choose_sounds_step.dart';
import '../widgets/choose_voice_step.dart';
import '../widgets/customize_content_step.dart';
import '../widgets/step_indicator.dart';

/// A screen for creating custom meditations
class MeditationCreatorScreen extends ConsumerStatefulWidget {
  const MeditationCreatorScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MeditationCreatorScreen> createState() => _MeditationCreatorScreenState();
}

class _MeditationCreatorScreenState extends ConsumerState<MeditationCreatorScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;
  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Initialize a new meditation if one doesn't exist
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final meditationCreator = ref.read(meditationCreatorProvider);
      if (meditationCreator == null) {
        final userId = ref.read(userIdProvider);
        if (userId != null) {
          ref.read(meditationCreatorProvider.notifier).initialize();
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _saveMeditation();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _saveMeditation() async {
    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      final meditation = await ref.read(meditationCreatorProvider.notifier).saveMeditation();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(AppConstants.successMeditationCreated),
            backgroundColor: AppColors.success,
          ),
        );
        
        // Navigate to the player
        final currentMeditation = ref.read(currentMeditationProvider.notifier);
        currentMeditation.setMeditation(meditation);
        context.go('${AppConstants.meditationPlayerRoute}/${meditation.id}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _cancelCreation() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Creation?'),
        content: const Text('Are you sure you want to cancel? Your meditation will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('No, Keep Editing'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(meditationCreatorProvider.notifier).reset();
              context.go(AppConstants.homeRoute);
            },
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Choose Purpose';
      case 1:
        return 'Select Voice';
      case 2:
        return 'Choose Sounds';
      case 3:
        return 'Customize Content';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final meditation = ref.watch(meditationCreatorProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_getStepTitle(_currentStep)),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _cancelCreation,
        ),
        actions: [
          // Preview button (to be implemented in future)
          if (_currentStep == _totalSteps - 1)
            IconButton(
              icon: const Icon(Icons.preview_outlined),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Preview feature coming soon'),
                  ),
                );
              },
            ),
        ],
      ),
      body: meditation == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Step indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: StepIndicator(
                    currentStep: _currentStep,
                    totalSteps: _totalSteps,
                    labels: const [
                      'Purpose',
                      'Voice',
                      'Sounds',
                      'Content',
                    ],
                  ),
                ),
                
                // Error message
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Colors.red[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                
                // Page content
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                    children: [
                      // Step 1: Choose Purpose
                      ChoosePurposeStep(
                        meditation: meditation,
                        onUpdate: (purpose) {
                          ref.read(meditationCreatorProvider.notifier).updatePurpose(purpose);
                        },
                        onNameChanged: (name) {
                          ref.read(meditationCreatorProvider.notifier).updateName(name);
                        },
                      ),
                      
                      // Step 2: Select Voice
                      ChooseVoiceStep(
                        meditation: meditation,
                        onSelectVoice: (voice) {
                          ref.read(meditationCreatorProvider.notifier).updateVoice(voice);
                        },
                      ),
                      
                      // Step 3: Choose Sounds
                      ChooseSoundsStep(
                        meditation: meditation,
                        onAddSound: (sound) {
                          ref.read(meditationCreatorProvider.notifier).addBackgroundSound(sound);
                        },
                        onRemoveSound: (soundId) {
                          ref.read(meditationCreatorProvider.notifier).removeBackgroundSound(soundId);
                        },
                        onUpdateVolume: (soundId, volume) {
                          ref.read(meditationCreatorProvider.notifier)
                              .updateBackgroundSoundVolume(soundId, volume);
                        },
                        onUpdateBackgroundVolume: (volume) {
                          ref.read(meditationCreatorProvider.notifier)
                              .updateBackgroundVolumeDuringGuidance(volume);
                        },
                      ),
                      
                      // Step 4: Customize Content
                      CustomizeContentStep(
                        meditation: meditation,
                        onUpdateContent: (content) {
                          ref.read(meditationCreatorProvider.notifier).updateContent(content);
                        },
                        onUpdateDuration: (minutes) {
                          ref.read(meditationCreatorProvider.notifier).updateDuration(minutes);
                        },
                      ),
                    ],
                  ),
                ),
                
                // Bottom navigation
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        offset: const Offset(0, -1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back button
                      _currentStep > 0
                          ? OutlinedButton.icon(
                              icon: const Icon(Icons.arrow_back_rounded),
                              label: const Text('Back'),
                              onPressed: _previousStep,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 16,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      
                      // Next/Create button
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: _currentStep > 0 ? 16 : 0),
                          child: ElevatedButton.icon(
                            icon: Icon(
                              _currentStep < _totalSteps - 1
                                  ? Icons.arrow_forward_rounded
                                  : Icons.check_rounded,
                            ),
                            label: Text(
                              _currentStep < _totalSteps - 1 ? 'Next' : 'Create',
                            ),
                            onPressed: _isSaving ? null : _nextStep,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
