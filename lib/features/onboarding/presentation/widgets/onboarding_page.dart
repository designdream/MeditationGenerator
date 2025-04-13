import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';

/// A single page in the onboarding flow
class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final bool showGetStarted;
  final VoidCallback? onGetStarted;

  const OnboardingPage({
    Key? key,
    required this.image,
    required this.title,
    required this.description,
    this.showGetStarted = false,
    this.onGetStarted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image
          Expanded(
            flex: 5,
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Image.asset(
                image,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback placeholder when image is missing
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 80,
                        color: Colors.white54,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.heading2.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            description,
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Get Started button
          if (showGetStarted)
            ElevatedButton(
              onPressed: onGetStarted,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF3D3A7C),
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            const SizedBox(height: 56),
        ],
      ),
    );
  }
}
