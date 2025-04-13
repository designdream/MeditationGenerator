import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/meditation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Step 1: Choose meditation purpose
class ChoosePurposeStep extends StatefulWidget {
  final Meditation meditation;
  final Function(String) onUpdate;
  final Function(String) onNameChanged;

  const ChoosePurposeStep({
    Key? key,
    required this.meditation,
    required this.onUpdate,
    required this.onNameChanged,
  }) : super(key: key);

  @override
  State<ChoosePurposeStep> createState() => _ChoosePurposeStepState();
}

class _ChoosePurposeStepState extends State<ChoosePurposeStep> {
  late String _selectedPurpose;
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedPurpose = widget.meditation.purpose;
    _nameController.text = widget.meditation.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
            "What's your focus today?",
            style: AppTypography.subheading2,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Choose a purpose for your meditation to help customize the experience.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkGray.withOpacity(0.7),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Name field
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Meditation Name',
              hintText: 'Enter a name for your meditation',
              prefixIcon: Icon(Icons.edit_outlined),
            ),
            onChanged: widget.onNameChanged,
          ),
          
          const SizedBox(height: 24),
          
          // Purpose grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: AppConstants.meditationCategories.length + 1, // +1 for "Custom"
              itemBuilder: (context, index) {
                if (index < AppConstants.meditationCategories.length) {
                  final purpose = AppConstants.meditationCategories[index];
                  return _buildPurposeCard(purpose);
                } else {
                  // Custom purpose
                  return _buildPurposeCard('Custom');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurposeCard(String purpose) {
    final isSelected = _selectedPurpose == purpose;
    final icon = _getPurposeIcon(purpose);
    final color = _getPurposeColor(purpose);
    
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? color : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedPurpose = purpose;
          });
          widget.onUpdate(purpose);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 36,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                purpose,
                textAlign: TextAlign.center,
                style: AppTypography.subheading3.copyWith(
                  color: isSelected ? color : AppColors.darkGray,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getPurposeIcon(String purpose) {
    switch (purpose.toLowerCase()) {
      case 'sleep':
        return Icons.nightlight_outlined;
      case 'stress relief':
        return Icons.spa_outlined;
      case 'focus':
        return Icons.center_focus_strong_outlined;
      case 'anxiety':
        return Icons.healing_outlined;
      case 'gratitude':
        return Icons.favorite_outlined;
      case 'self-love':
        return Icons.self_improvement_outlined;
      case 'energy':
        return Icons.bolt_outlined;
      case 'manifestation':
        return Icons.auto_awesome_outlined;
      case 'custom':
        return Icons.add_circle_outline;
      default:
        return Icons.spa_outlined;
    }
  }

  Color _getPurposeColor(String purpose) {
    switch (purpose.toLowerCase()) {
      case 'sleep':
        return const Color(0xFF3F51B5); // Indigo
      case 'stress relief':
        return const Color(0xFF4CAF50); // Green
      case 'focus':
        return const Color(0xFF9C27B0); // Purple
      case 'anxiety':
        return const Color(0xFF2196F3); // Blue
      case 'gratitude':
        return const Color(0xFFE91E63); // Pink
      case 'self-love':
        return const Color(0xFFFF9800); // Orange
      case 'energy':
        return const Color(0xFFFFC107); // Amber
      case 'manifestation':
        return const Color(0xFF00BCD4); // Cyan
      case 'custom':
        return AppColors.accentGentleTeal;
      default:
        return AppColors.primaryDeepIndigo;
    }
  }
}
