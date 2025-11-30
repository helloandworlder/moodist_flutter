import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/datasources/assets/sound_assets.dart';
import '../../providers/audio/sound_states_provider.dart';
import '../../providers/audio/sound_actions_provider.dart';
import '../../widgets/sound/sound_card.dart';
import '../../widgets/sound/smart_mix_card.dart';

class SoundsScreen extends ConsumerStatefulWidget {
  const SoundsScreen({super.key});

  @override
  ConsumerState<SoundsScreen> createState() => _SoundsScreenState();
}

class _SoundsScreenState extends ConsumerState<SoundsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _collapsedCategories = {};
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CategoryDefinition> get _filteredCategories {
    if (_searchQuery.isEmpty) {
      return SoundAssets.categories;
    }

    final query = _searchQuery.toLowerCase();
    return SoundAssets.categories
        .map((category) {
          final filteredSounds = category.sounds
              .where((sound) => sound.label.toLowerCase().contains(query))
              .toList();
          if (filteredSounds.isEmpty) return null;
          return CategoryDefinition(
            id: category.id,
            title: category.title,
            icon: category.icon,
            sounds: filteredSounds,
          );
        })
        .whereType<CategoryDefinition>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _filteredCategories;
    final selectedSoundsAsync = ref.watch(selectedSoundsStreamProvider);
    final selectedCount = selectedSoundsAsync.maybeWhen(
      data: (sounds) => sounds.length,
      orElse: () => 0,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with gradient
          SliverToBoxAdapter(
            child: _GradientHeader(
              selectedCount: selectedCount,
              onSmartMix: () {
                HapticFeedback.mediumImpact();
                ref.read(soundActionsProvider.notifier).shuffle();
              },
            ),
          ),

          // Search bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _SearchBar(
                controller: _searchController,
                onChanged: (value) => setState(() => _searchQuery = value),
              ),
            ),
          ),

          // Smart Mix recommendations (when no search)
          if (_searchQuery.isEmpty)
            const SliverToBoxAdapter(
              child: SmartMixCard(),
            ),

          // Categories
          if (filteredCategories.isEmpty)
            SliverFillRemaining(
              child: _EmptySearchResult(),
            )
          else
            ...filteredCategories.map((category) => _buildCategorySliver(category)),

          // Bottom padding for mini player and nav
          const SliverToBoxAdapter(
            child: SizedBox(height: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySliver(CategoryDefinition category) {
    final isCollapsed = _collapsedCategories.contains(category.id);
    final categoryColor = AppColors.getCategoryColor(category.id);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category header
            _CategoryHeader(
              categoryId: category.id,
              icon: category.icon,
              soundCount: category.sounds.length,
              isCollapsed: isCollapsed,
              color: categoryColor,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() {
                  if (isCollapsed) {
                    _collapsedCategories.remove(category.id);
                  } else {
                    _collapsedCategories.add(category.id);
                  }
                });
              },
            ),
            const SizedBox(height: 12),

            // Sounds grid
            AnimatedCrossFade(
              firstChild: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.82,
                ),
                itemCount: category.sounds.length,
                itemBuilder: (context, soundIndex) {
                  final sound = category.sounds[soundIndex];
                  return SoundCard(
                    sound: sound,
                    categoryColor: categoryColor,
                  );
                },
              ),
              secondChild: const SizedBox.shrink(),
              crossFadeState: isCollapsed
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _GradientHeader extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onSmartMix;

  const _GradientHeader({
    required this.selectedCount,
    required this.onSmartMix,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.fromLTRB(20, topPadding + 16, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryStart,
            AppColors.primaryEnd,
          ],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'app.title'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selectedCount > 0
                        ? (selectedCount == 1 
                            ? 'sounds.selected_one'.tr(args: ['$selectedCount'])
                            : 'sounds.selected_many'.tr(args: ['$selectedCount']))
                        : 'sounds.subtitle'.tr(),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              // Quick action button
              _QuickActionButton(
                icon: LucideIcons.sparkles,
                label: 'sounds.mix_button'.tr(),
                onTap: onSmartMix,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchBar({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'sounds.search'.tr(),
          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
          prefixIcon: const Icon(LucideIcons.search, size: 20),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(LucideIcons.x, size: 18),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  final String categoryId;
  final String icon;
  final int soundCount;
  final bool isCollapsed;
  final Color color;
  final VoidCallback onTap;

  const _CategoryHeader({
    required this.categoryId,
    required this.icon,
    required this.soundCount,
    required this.isCollapsed,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _getIcon(icon),
                size: 18,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'categories.$categoryId'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$soundCount',
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Spacer(),
            AnimatedRotation(
              turns: isCollapsed ? -0.25 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                LucideIcons.chevronDown,
                size: 20,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    const iconMap = {
      'tree-pine': LucideIcons.treePine,
      'cloud-rain': LucideIcons.cloudRain,
      'dog': LucideIcons.dog,
      'building': LucideIcons.building,
      'map-pin': LucideIcons.mapPin,
      'car': LucideIcons.car,
      'box': LucideIcons.box,
      'radio': LucideIcons.radio,
    };
    return iconMap[iconName] ?? LucideIcons.music;
  }
}

class _EmptySearchResult extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.searchX,
              size: 36,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No sounds found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
        ],
      ),
    );
  }
}
