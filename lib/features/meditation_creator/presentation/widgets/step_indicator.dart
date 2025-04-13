import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

/// A step indicator widget for multi-step flows
class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? labels;

  const StepIndicator({
    Key? key,
    required this.currentStep,
    required this.totalSteps,
    this.labels,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress indicator
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index <= currentStep;
            final isCompleted = index < currentStep;
            final isLast = index == totalSteps - 1;
            
            return Expanded(
              child: Row(
                children: [
                  // Step circle
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primaryDeepIndigo : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            )
                          : Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: isActive ? Colors.white : Colors.grey.shade600,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                    ),
                  ),
                  
                  // Connecting line
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: isCompleted ? AppColors.primaryDeepIndigo : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        
        // Step labels
        if (labels != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: List.generate(totalSteps, (index) {
                final isActive = index <= currentStep;
                
                return Expanded(
                  child: Text(
                    labels![index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isActive ? AppColors.primaryDeepIndigo : Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
