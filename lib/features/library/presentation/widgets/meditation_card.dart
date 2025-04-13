import 'package:flutter/material.dart';
import '../../../../core/models/meditation.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/duration_formatter.dart';

/// Card widget to display meditation information in the library
class MeditationCard extends StatelessWidget {
  final Meditation meditation;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const MeditationCard({
    Key? key,
    required this.meditation,
    required this.onTap,
    required this.onFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row - name and favorite
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      meditation.name,
                      style: AppTypography.subheading2,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: onFavorite,
                    icon: Icon(
                      meditation.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: meditation.isFavorite
                          ? AppColors.accentGentleTeal
                          : Colors.grey,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Info section (purpose, duration, played count)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Purpose tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getPurposeColor(meditation.purpose).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      meditation.purpose,
                      style: TextStyle(
                        color: _getPurposeColor(meditation.purpose),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Duration
                  Row(
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        size: 16,
                        color: AppColors.darkGray,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${meditation.durationMinutes} min',
                        style: const TextStyle(
                          color: AppColors.darkGray,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Play count
                  Row(
                    children: [
                      const Icon(
                        Icons.play_circle_outline,
                        size: 16,
                        color: AppColors.darkGray,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        meditation.playCount == 1
                            ? '1 play'
                            : '${meditation.playCount} plays',
                        style: const TextStyle(
                          color: AppColors.darkGray,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Last played label
              if (meditation.lastPlayedAt != null) ...[
                Text(
                  'Last played: ${_formatLastPlayed(meditation.lastPlayedAt!)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getPurposeColor(String purpose) {
    switch (purpose.toLowerCase()) {
      case 'sleep':
        return Colors.indigo;
      case 'relax':
      case 'relaxation':
        return AppColors.accentGentleTeal;
      case 'focus':
        return Colors.orange[700]!;
      case 'stress relief':
        return Colors.green[700]!;
      case 'anxiety':
        return Colors.purple;
      case 'happiness':
        return Colors.amber[700]!;
      default:
        return AppColors.primaryDeepIndigo;
    }
  }

  String _formatLastPlayed(DateTime lastPlayed) {
    final now = DateTime.now();
    final difference = now.difference(lastPlayed);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${lastPlayed.day}/${lastPlayed.month}/${lastPlayed.year}';
    }
  }
}
