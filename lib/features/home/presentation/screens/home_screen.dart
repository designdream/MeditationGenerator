import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/meditation.dart';
import '../../../../core/providers/meditation_provider.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Home screen - main landing page for logged in users
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);
    final recentMeditations = ref.watch(recentMeditationsProvider);
    
    // Get time of day for greeting
    final hour = DateTime.now().hour;
    String greeting;
    
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Scaffold(
      body: SafeArea(
        child: userAsync.when(
          data: (user) {
            if (user == null) {
              // If user is null, redirect to login
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.go('/login');
              });
              return const Center(child: CircularProgressIndicator());
            }
            
            // User is logged in, show home screen
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(userProvider);
                ref.invalidate(recentMeditationsProvider);
              },
              child: CustomScrollView(
                slivers: [
                  // App bar with greeting
                  SliverAppBar(
                    floating: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$greeting,',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.darkGray.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          user.displayName,
                          style: AppTypography.heading3,
                        ),
                      ],
                    ),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () {
                          // Navigate to notifications (to be implemented)
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Notifications not yet implemented')),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined),
                        onPressed: () {
                          context.push(AppConstants.settingsRoute);
                        },
                      ),
                    ],
                  ),

                  // Meditation stats
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const Text(
                                'Your Meditation Journey',
                                style: AppTypography.subheading2,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  // Total time
                                  StatItem(
                                    value: _formatDuration(user.stats.totalMeditationTime),
                                    label: 'Total Time',
                                    icon: Icons.timer_outlined,
                                  ),
                                  // Current streak
                                  StatItem(
                                    value: user.stats.currentStreak.toString(),
                                    label: 'Current Streak',
                                    icon: Icons.local_fire_department_outlined,
                                  ),
                                  // Sessions
                                  StatItem(
                                    value: user.stats.sessionsCompleted.toString(),
                                    label: 'Sessions',
                                    icon: Icons.spa_outlined,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Quick create section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quick Create',
                            style: AppTypography.subheading2,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text('Create New Meditation'),
                              onPressed: () {
                                context.go(AppConstants.createMeditationRoute);
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Quick templates
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              _buildQuickTemplateCard(
                                title: 'Sleep Better Tonight',
                                duration: 8,
                                icon: Icons.nightlight_outlined,
                                color: const Color(0xFF3F51B5),
                              ),
                              _buildQuickTemplateCard(
                                title: 'Morning Calm',
                                duration: 5,
                                icon: Icons.wb_sunny_outlined,
                                color: const Color(0xFFFF9800),
                              ),
                              _buildQuickTemplateCard(
                                title: 'Stress Relief',
                                duration: 10,
                                icon: Icons.healing_outlined,
                                color: const Color(0xFF4CAF50),
                              ),
                              _buildQuickTemplateCard(
                                title: 'Quick Reset',
                                duration: 3,
                                icon: Icons.refresh_outlined,
                                color: const Color(0xFF9C27B0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Recent activity section
                  recentMeditations.when(
                    data: (meditations) {
                      if (meditations.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Recent Activity',
                                  style: AppTypography.subheading2,
                                ),
                                const SizedBox(height: 8),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: Text(
                                        'No recent meditations yet.\nCreate your first meditation!',
                                        textAlign: TextAlign.center,
                                        style: AppTypography.bodyMedium,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == 0) {
                              return const Padding(
                                padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                child: Text(
                                  'Recent Activity',
                                  style: AppTypography.subheading2,
                                ),
                              );
                            }
                            
                            final meditation = meditations[index - 1];
                            return _buildRecentMeditationCard(meditation);
                          },
                          childCount: meditations.length + 1,
                        ),
                      );
                    },
                    loading: () => const SliverToBoxAdapter(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (error, stackTrace) => SliverToBoxAdapter(
                      child: Center(
                        child: Text('Error: $error'),
                      ),
                    ),
                  ),
                  
                  // Add padding at the bottom
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTemplateCard({
    required String title,
    required int duration,
    required IconData icon,
    required Color color,
  }) {
    final size = (MediaQuery.of(context).size.width - 44) / 2; // 2 columns with padding
    
    return InkWell(
      onTap: () {
        // Create from template (to be implemented)
        final meditationCreator = ref.read(meditationCreatorProvider.notifier);
        meditationCreator.initialize(purpose: title);
        context.go(AppConstants.createMeditationRoute);
      },
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: size,
        child: Card(
          color: color.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: AppTypography.subheading3.copyWith(
                    color: color.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$duration min',
                  style: AppTypography.bodySmall.copyWith(
                    color: color.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentMeditationCard(Meditation meditation) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final lastPlayedDate = meditation.lastPlayedAt != null
        ? dateFormat.format(meditation.lastPlayedAt!)
        : 'Never played';
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            // Navigate to player
            final currentMeditation = ref.read(currentMeditationProvider.notifier);
            currentMeditation.setMeditation(meditation);
            context.go('${AppConstants.meditationPlayerRoute}/${meditation.id}');
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Meditation icon or thumbnail
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryDeepIndigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.spa_outlined,
                    color: AppColors.primaryDeepIndigo,
                    size: 32,
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Meditation info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meditation.name,
                        style: AppTypography.subheading3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: AppColors.darkGray,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${meditation.durationMinutes} min',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.darkGray,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 16,
                            color: AppColors.darkGray,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              lastPlayedDate,
                              style: AppTypography.bodySmall.copyWith(
                                color: AppColors.darkGray,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Play button
                IconButton(
                  icon: const Icon(Icons.play_circle_filled),
                  color: AppColors.accentGentleTeal,
                  iconSize: 40,
                  onPressed: () {
                    // Navigate to player
                    final currentMeditation = ref.read(currentMeditationProvider.notifier);
                    currentMeditation.setMeditation(meditation);
                    context.go('${AppConstants.meditationPlayerRoute}/${meditation.id}');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDuration(int minutes) {
    if (minutes < 60) {
      return '$minutes min';
    }
    
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    
    if (remainingMinutes == 0) {
      return '$hours h';
    }
    
    return '$hours h $remainingMinutes m';
  }
}

/// Widget for displaying a single stat
class StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const StatItem({
    Key? key,
    required this.value,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColors.accentGentleTeal,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: AppTypography.subheading3.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: AppColors.darkGray.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
