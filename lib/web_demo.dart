import 'package:flutter/material.dart';

void main() {
  runApp(const MeditationWebDemo());
}

/// A simplified web demo version of the meditation app
class MeditationWebDemo extends StatelessWidget {
  const MeditationWebDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditation Creation App',
      theme: ThemeData(
        primaryColor: const Color(0xFF3D3A7C), // Deep Indigo
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3D3A7C),
          secondary: const Color(0xFFB8B5FF), // Soft Lavender
        ),
        useMaterial3: true,
      ),
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
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
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
              
              const SizedBox(height: 32),
              
              // Builder Demo
              _buildMeditationCreatorDemo(),
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

  Widget _buildMeditationCreatorDemo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Meditation Builder Preview',
          style: TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 16),
        
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Text(
                  'Step 1: Choose Purpose',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                const Text(
                  'Select the purpose of your meditation:',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Purpose options grid
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildPurposeCard('Sleep', Icons.nightlight, Colors.indigo, true),
                    _buildPurposeCard('Stress Relief', Icons.spa, Colors.green, false),
                    _buildPurposeCard('Focus', Icons.psychology, Colors.orange, false),
                    _buildPurposeCard('Anxiety', Icons.healing, Colors.purple, false),
                    _buildPurposeCard('Gratitude', Icons.favorite, Colors.pink, false),
                    _buildPurposeCard('Energy', Icons.bolt, Colors.amber, false),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Navigation buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Next: Voice'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPurposeCard(
    String title, 
    IconData icon, 
    Color color, 
    bool selected
  ) {
    return Card(
      elevation: selected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: selected 
            ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? Theme.of(context).primaryColor : color,
                size: 36,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  color: selected ? Theme.of(context).primaryColor : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
