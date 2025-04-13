import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/onboarding_page.dart';

/// The onboarding screen shown to new users
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    // Save that onboarding is completed
    // ref.read(onboardingProvider.notifier).completeOnboarding();
    
    // Navigate to login screen
    context.go('/login');
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: AppColors.primaryGradient,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: _currentPage < _totalPages - 1
                      ? TextButton(
                          onPressed: _skipOnboarding,
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
              ),
              
              // Page content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    // Welcome page
                    OnboardingPage(
                      image: 'assets/images/onboarding_welcome.png',
                      title: 'Create Your Perfect Meditation',
                      description: 'Welcome to the most customizable meditation experience. Tailor every aspect to your preferences.',
                    ),
                    
                    // Personalization page
                    OnboardingPage(
                      image: 'assets/images/onboarding_personalize.png',
                      title: 'Fully Personalized',
                      description: 'Choose your voice guide, background sounds, and meditation content to create your ideal experience.',
                    ),
                    
                    // Features page
                    OnboardingPage(
                      image: 'assets/images/onboarding_features.png',
                      title: 'Premium Features',
                      description: 'Enjoy high-quality audio, multiple voice options, layered sounds, and guided or unguided sessions.',
                    ),
                    
                    // Get started page
                    OnboardingPage(
                      image: 'assets/images/onboarding_getstarted.png',
                      title: 'Ready to Begin?',
                      description: 'Create an account to save your preferences and custom meditations.',
                      showGetStarted: true,
                      onGetStarted: _completeOnboarding,
                    ),
                  ],
                ),
              ),
              
              // Bottom navigation and indicators
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    _currentPage > 0
                        ? IconButton(
                            onPressed: _previousPage,
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                            ),
                          )
                        : const SizedBox(width: 48),
                    
                    // Page indicator
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _totalPages,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: AppColors.accentGentleTeal,
                        dotColor: Colors.white54,
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 4,
                      ),
                    ),
                    
                    // Next button
                    IconButton(
                      onPressed: _nextPage,
                      icon: Icon(
                        _currentPage < _totalPages - 1
                            ? Icons.arrow_forward_rounded
                            : Icons.check_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
