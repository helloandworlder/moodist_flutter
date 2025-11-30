import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/datasources/assets/sound_assets.dart';
import '../../providers/audio/sound_states_provider.dart';
import '../../providers/audio/sound_actions_provider.dart';
import '../../widgets/sound/sound_card.dart';

enum FavoriteSortOrder { name, recent }

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  FavoriteSortOrder _sortOrder = FavoriteSortOrder.name;

  @override
  Widget build(BuildContext context) {
    final favoritesAsync = ref.watch(favoriteSoundsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('favorites.title'.tr()),
        actions: [
          // Sort button
          favoritesAsync.maybeWhen(
            data: (favorites) => favorites.isNotEmpty
                ? PopupMenuButton<FavoriteSortOrder>(
                    icon: const Icon(LucideIcons.arrowUpDown, size: 20),
                    tooltip: 'Sort',
                    onSelected: (order) => setState(() => _sortOrder = order),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: FavoriteSortOrder.name,
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.arrowDownAZ,
                              size: 18,
                              color: _sortOrder == FavoriteSortOrder.name
                                  ? Theme.of(context).primaryColor
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'favorites.sort_name'.tr(),
                              style: TextStyle(
                                color: _sortOrder == FavoriteSortOrder.name
                                    ? Theme.of(context).primaryColor
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: FavoriteSortOrder.recent,
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.clock,
                              size: 18,
                              color: _sortOrder == FavoriteSortOrder.recent
                                  ? Theme.of(context).primaryColor
                                  : null,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'favorites.sort_recent'.tr(),
                              style: TextStyle(
                                color: _sortOrder == FavoriteSortOrder.recent
                                    ? Theme.of(context).primaryColor
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: favoritesAsync.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return _buildEmptyState(context);
          }

          // Sort favorites
          final sortedFavorites = _sortFavorites(favorites);

          return Column(
            children: [
              // Header with count and clear all button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '${favorites.length} favorites',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => _showClearAllDialog(context),
                      icon: const Icon(LucideIcons.trash2, size: 16),
                      label: Text('favorites.clear_all'.tr()),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),

              // Favorites grid
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 160),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: sortedFavorites.length,
                  itemBuilder: (context, index) {
                    final soundState = sortedFavorites[index];
                    final sound = SoundAssets.getSoundById(soundState.soundId);
                    if (sound == null) return const SizedBox.shrink();
                    return _FavoriteCard(
                      sound: sound,
                      onRemove: () => _removeFavorite(soundState.soundId),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.heart,
            size: 64,
            color: Colors.grey.shade600,
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                duration: 1000.ms,
                curve: Curves.easeInOut,
              ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 8),
          Text(
            'Double-tap a sound to add it to favorites',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              // Navigate to sounds tab
              if (context.mounted) {
                // Find the parent HomeScreen and switch tabs
                // This is a workaround - in a real app you'd use proper navigation
              }
            },
            icon: const Icon(LucideIcons.music, size: 18),
            label: const Text('Browse Sounds'),
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),
        ],
      ),
    );
  }

  List<dynamic> _sortFavorites(List<dynamic> favorites) {
    final sorted = List.from(favorites);
    switch (_sortOrder) {
      case FavoriteSortOrder.name:
        sorted.sort((a, b) {
          final soundA = SoundAssets.getSoundById(a.soundId);
          final soundB = SoundAssets.getSoundById(b.soundId);
          return (soundA?.label ?? '').compareTo(soundB?.label ?? '');
        });
        break;
      case FavoriteSortOrder.recent:
        // Keep original order (most recently added last in database)
        break;
    }
    return sorted;
  }

  void _removeFavorite(String soundId) {
    HapticFeedback.lightImpact();
    ref.read(soundActionsProvider.notifier).toggleFavorite(soundId);
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Favorites?'),
        content: const Text(
            'This will remove all sounds from your favorites. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAllFavorites();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('favorites.clear_all'.tr()),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllFavorites() async {
    final favoritesAsync = ref.read(favoriteSoundsStreamProvider);
    favoritesAsync.whenData((favorites) async {
      for (final fav in favorites) {
        await ref.read(soundActionsProvider.notifier).toggleFavorite(fav.soundId);
      }
    });
    HapticFeedback.mediumImpact();
  }
}

class _FavoriteCard extends StatelessWidget {
  final SoundDefinition sound;
  final VoidCallback onRemove;

  const _FavoriteCard({
    required this.sound,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(sound.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(LucideIcons.trash2, color: Colors.red, size: 20),
      ),
      child: SoundCard(
        sound: sound,
        categoryColor: AppColors.favorite,
      ),
    );
  }
}
