import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/models/meditation.dart';
import '../../../../core/providers/meditation_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/duration_formatter.dart';
import '../widgets/empty_library_view.dart';
import '../widgets/meditation_card.dart';

/// Library screen showing user's saved meditations
class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _showFavoritesOnly = false;
  String _sortBy = 'recent'; // 'recent', 'name', 'duration'

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
      _searchController.clear();
    });
  }

  void _toggleFavoritesFilter() {
    setState(() {
      _showFavoritesOnly = !_showFavoritesOnly;
    });
  }

  void _setSortOption(String option) {
    if (_sortBy != option) {
      setState(() {
        _sortBy = option;
      });
    }
  }

  List<Meditation> _filterAndSortMeditations(List<Meditation> meditations) {
    // Apply filters
    var filtered = meditations;
    
    if (_showFavoritesOnly) {
      filtered = filtered.where((m) => m.isFavorite).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered
          .where((m) => 
              m.name.toLowerCase().contains(query) ||
              m.purpose.toLowerCase().contains(query))
          .toList();
    }
    
    // Apply sorting
    switch (_sortBy) {
      case 'recent':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'name':
        filtered.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
      case 'duration':
        filtered.sort((a, b) => a.durationMinutes.compareTo(b.durationMinutes));
        break;
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final meditationsAsync = ref.watch(userMeditationsProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Your Library'),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        bottom: _buildSearchBar(),
      ),
      body: meditationsAsync.when(
        data: (meditations) {
          final filteredMeditations = _filterAndSortMeditations(meditations);
          
          if (meditations.isEmpty) {
            return const EmptyLibraryView();
          }
          
          if (filteredMeditations.isEmpty) {
            return _buildNoResultsView();
          }
          
          return Column(
            children: [
              // Filter & Sort bar
              _buildFilterBar(),
              
              // Meditation list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: filteredMeditations.length,
                  itemBuilder: (context, index) {
                    final meditation = filteredMeditations[index];
                    return MeditationCard(
                      meditation: meditation,
                      onTap: () {
                        context.push(
                          '${AppConstants.meditationPlayerRoute}/${meditation.id}',
                        );
                      },
                      onFavorite: () {
                        ref.read(meditationNotifierProvider.notifier)
                            .toggleFavorite(meditation.id);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: AppColors.errorRed,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading meditations',
                  style: AppTypography.subheading2,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.darkGray,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    ref.refresh(userMeditationsProvider);
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(AppConstants.meditationCreatorRoute);
        },
        backgroundColor: AppColors.primaryDeepIndigo,
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSize _buildSearchBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search your meditations',
            filled: true,
            fillColor: Colors.grey[100],
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          // Favorites filter
          InkWell(
            onTap: _toggleFavoritesFilter,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _showFavoritesOnly
                    ? AppColors.primaryDeepIndigo
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.favorite,
                    size: 18,
                    color: _showFavoritesOnly ? Colors.white : Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Favorites',
                    style: TextStyle(
                      color: _showFavoritesOnly ? Colors.white : Colors.grey[800],
                      fontWeight: _showFavoritesOnly ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const Spacer(),
          
          // Sort options
          PopupMenuButton<String>(
            offset: const Offset(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: _setSortOption,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'recent',
                child: Text('Most Recent'),
              ),
              const PopupMenuItem(
                value: 'name',
                child: Text('By Name'),
              ),
              const PopupMenuItem(
                value: 'duration',
                child: Text('By Duration'),
              ),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.sort,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getSortByText(),
                    style: TextStyle(
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getSortByText() {
    switch (_sortBy) {
      case 'recent':
        return 'Most Recent';
      case 'name':
        return 'By Name';
      case 'duration':
        return 'By Duration';
      default:
        return 'Sort';
    }
  }

  Widget _buildNoResultsView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: AppTypography.subheading2,
            ),
            const SizedBox(height: 8),
            Text(
              _showFavoritesOnly 
                  ? 'Try disabling the favorites filter or search for something else.'
                  : 'Try searching for something else.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.darkGray,
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _searchController.clear();
                  _showFavoritesOnly = false;
                });
              },
              child: const Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
