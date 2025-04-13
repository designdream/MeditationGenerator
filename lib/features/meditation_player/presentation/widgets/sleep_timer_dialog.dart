import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class SleepTimerDialog extends StatelessWidget {
  final Duration? currentTimer;
  final Function(Duration?) onTimerSelected;

  const SleepTimerDialog({
    Key? key,
    this.currentTimer,
    required this.onTimerSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timerOptions = [
      _TimerOption(minutes: 5, label: '5 min'),
      _TimerOption(minutes: 10, label: '10 min'),
      _TimerOption(minutes: 15, label: '15 min'),
      _TimerOption(minutes: 30, label: '30 min'),
      _TimerOption(minutes: 45, label: '45 min'),
      _TimerOption(minutes: 60, label: '1 hour'),
      _TimerOption(minutes: null, label: 'End of session'),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Title
                const Text(
                  'Sleep Timer',
                  style: AppTypography.heading3,
                ),
                
                const SizedBox(height: 8),
                
                // Description
                Text(
                  'Your meditation will automatically pause after the selected time.',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.darkGray.withOpacity(0.7),
                  ),
                ),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
          
          // Options list
          for (final option in timerOptions)
            _buildTimerOption(
              context,
              option.minutes != null
                  ? Duration(minutes: option.minutes!)
                  : null,
              option.label,
            ),
          
          // Cancel button
          if (currentTimer != null) ...[
            const SizedBox(height: 8),
            const Divider(height: 1),
            
            // Cancel current timer
            InkWell(
              onTap: () => onTimerSelected(null),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Center(
                  child: Text(
                    'Cancel Timer',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
          
          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildTimerOption(
    BuildContext context,
    Duration? duration,
    String label,
  ) {
    final isSelected = duration != null && currentTimer != null
        ? duration.inMinutes == currentTimer!.inMinutes
        : duration == null && currentTimer == null;

    return InkWell(
      onTap: () => onTimerSelected(duration),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentGentleTeal.withOpacity(0.1) : null,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? AppColors.accentGentleTeal : AppColors.darkGray,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.accentGentleTeal,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

class _TimerOption {
  final int? minutes;
  final String label;

  _TimerOption({required this.minutes, required this.label});
}
