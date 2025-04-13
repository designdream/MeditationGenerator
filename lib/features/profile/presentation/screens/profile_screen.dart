import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/profile_info_card.dart';
import '../widgets/profile_stats_card.dart';
import '../widgets/settings_tile.dart';

/// Profile screen showing user information and settings
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text('User not found'),
            );
          }
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile info card (avatar, name, subscription)
                ProfileInfoCard(user: user),
                
                const SizedBox(height: 16),
                
                // Stats card (meditations, favorites, hours)
                ProfileStatsCard(user: user),
                
                const SizedBox(height: 24),
                
                // Settings section
                const Text(
                  'Account Settings',
                  style: AppTypography.subheading2,
                ),
                
                const SizedBox(height: 8),
                
                // Settings tiles
                SettingsTile(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  subtitle: 'Change your personal information',
                  onTap: () {
                    // TODO: Navigate to edit profile screen
                  },
                ),
                
                SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  subtitle: 'Manage your notification preferences',
                  onTap: () {
                    // TODO: Navigate to notifications screen
                  },
                ),
                
                SettingsTile(
                  icon: Icons.workspaces_outlined,
                  title: 'Subscription',
                  subtitle: user.subscription.isPremium
                      ? 'Manage your Premium subscription'
                      : 'Upgrade to Premium',
                  showBadge: !user.subscription.isPremium,
                  onTap: () {
                    // TODO: Navigate to subscription screen
                  },
                ),
                
                const SizedBox(height: 24),
                
                // App settings section
                const Text(
                  'App Settings',
                  style: AppTypography.subheading2,
                ),
                
                const SizedBox(height: 8),
                
                SettingsTile(
                  icon: Icons.palette_outlined,
                  title: 'Appearance',
                  subtitle: 'Dark mode and theme settings',
                  onTap: () {
                    // TODO: Navigate to appearance settings screen
                  },
                ),
                
                SettingsTile(
                  icon: Icons.music_note_outlined,
                  title: 'Audio Settings',
                  subtitle: 'Configure playback preferences',
                  onTap: () {
                    // TODO: Navigate to audio settings screen
                  },
                ),
                
                SettingsTile(
                  icon: Icons.download_outlined,
                  title: 'Downloads',
                  subtitle: 'Manage offline meditations',
                  onTap: () {
                    // TODO: Navigate to downloads screen
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Help & About section
                const Text(
                  'Help & About',
                  style: AppTypography.subheading2,
                ),
                
                const SizedBox(height: 8),
                
                SettingsTile(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  subtitle: 'Get help with the app',
                  onTap: () {
                    // TODO: Navigate to help center screen
                  },
                ),
                
                SettingsTile(
                  icon: Icons.info_outline,
                  title: 'About',
                  subtitle: 'App version and information',
                  onTap: () {
                    // TODO: Navigate to about screen
                  },
                ),
                
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  onTap: () {
                    // TODO: Navigate to privacy policy screen
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Sign out button
                Center(
                  child: TextButton(
                    onPressed: () {
                      _showSignOutDialog(context, ref);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red[700],
                    ),
                    child: const Text('Sign Out'),
                  ),
                ),
                
                // Bottom spacing for safe area
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading profile: $error',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ref.refresh(currentUserProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authProvider.notifier).signOut().then((_) {
                context.go(AppConstants.loginRoute);
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red[700],
            ),
            child: const Text('SIGN OUT'),
          ),
        ],
      ),
    );
  }
}
