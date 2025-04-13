import 'package:flutter/material.dart';
import '../../../../core/models/user.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

/// Card displaying user meditation statistics
class ProfileStatsCard extends StatelessWidget {
  final User user;

  const ProfileStatsCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Your Journey',
              style: AppTypography.subheading2,
            ),
            
            const SizedBox(height: 16),
            
            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total Meditations',
                  user.stats.totalMeditations.toString(),
                  Icons.self_improvement,
                ),
                _buildStatItem(
                  'Favorites',
                  user.stats.favoriteMeditations.toString(),
                  Icons.favorite,
                ),
                _buildStatItem(
                  'Hours',
                  _formatTotalHours(user.stats.totalMinutes),
                  Icons.access_time,
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Streak info
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDeepIndigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Streak: ${user.stats.currentStreak} days',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Best Streak: ${user.stats.bestStreak} days',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.darkGray.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.softLavender.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: AppColors.primaryDeepIndigo,
            size: 24,
          ),
        ),
        
        const SizedBox(height: 8),
        
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDeepIndigo,
          ),
        ),
        
        const SizedBox(height: 4),
        
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.darkGray.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  String _formatTotalHours(int totalMinutes) {
    final hours = (totalMinutes / 60).floor();
    final minutes = totalMinutes % 60;
    
    if (hours > 0 && minutes > 0) {
      return '$hours.${(minutes * 10 / 60).round()}';
    } else if (hours > 0) {
      return hours.toString();
    } else {
      return '0.${(minutes * 10 / 60).round()}';
    }
  }
}
