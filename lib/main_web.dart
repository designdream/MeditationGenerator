import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MeditationWebDemo(),
    ),
  );
}

/// A simplified web demo version of the meditation app
class MeditationWebDemo extends StatelessWidget {
  const MeditationWebDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const WebDemoScreen(),
    );
  }
}

/// A demo screen showing the app features
class WebDemoScreen extends StatefulWidget {
  const WebDemoScreen({Key? key}) : super(key: key);

  @override
  State<WebDemoScreen> createState() => _WebDemoScreenState();
}

class _WebDemoScreenState extends State<WebDemoScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditation Creation App - Web Demo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Introduction
              const Text(
                'Welcome to Meditation Creation App',
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              const Text(
                'Create fully personalized meditation experiences with our comprehensive meditation builder. This web demo showcases the app\'s features and design.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Feature Cards
              const Text(
                'Key Features',
                style: TextStyle(
                  fontSize: 24, 
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              _buildFeatureCard(
                title: 'Personalized Meditation Creation',
                description: 'Create custom meditations with our 4-step builder: Purpose, Voice, Sounds, and Content.',
                icon: Icons.create,
              ),
              
              _buildFeatureCard(
                title: 'Voice and Sound Mixing',
                description: 'Choose from a variety of voices and background sounds for your perfect meditation experience.',
                icon: Icons.multitrack_audio,
              ),
              
              _buildFeatureCard(
                title: 'Content Customization',
                description: 'Adjust guidance level, duration, silence periods, and other elements to match your preferences.',
                icon: Icons.tune,
              ),
              
              _buildFeatureCard(
                title: 'Advanced Audio Player',
                description: 'Feature-rich player with sleep timer, playback controls, and visualization.',
                icon: Icons.play_circle_filled,
              ),
              
              _buildFeatureCard(
                title: 'Personal Library',
                description: 'Save, categorize, and access your meditation collection with ease.',
                icon: Icons.library_music,
              ),
              
              const SizedBox(height: 32),
              
              // Demo Notice
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.amber.shade800),
                        const SizedBox(width: 8),
                        const Text(
                          'Web Demo Notice',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This is a simplified web demo of the Meditation Creation App. For the full experience with all features including audio playback and Firebase integration, please run the app on iOS or Android devices.',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music_outlined),
            activeIcon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required String title,
    required String description,
    required IconData icon,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
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
