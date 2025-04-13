import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Widget displayed when the library is empty
class EmptyLibraryView extends StatelessWidget {
  const EmptyLibraryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Illustration
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.softLavender.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.library_music_outlined,
                size: 96,
                color: AppColors.primaryDeepIndigo.withOpacity(0.7),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Title
            const Text(
              'Your Library is Empty',
              style: AppTypography.heading3,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Description
            Text(
              'Create your first meditation to start building your personal collection. Your creations will appear here.',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.darkGray.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // Create button
            ElevatedButton(
              onPressed: () {
                context.push(AppConstants.meditationCreatorRoute);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDeepIndigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add),
                  const SizedBox(width: 8),
                  Text(
                    'Create Meditation',
                    style: AppTypography.buttonLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
