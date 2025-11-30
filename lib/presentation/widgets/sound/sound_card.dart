import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/datasources/assets/sound_assets.dart';
import '../../providers/audio/playback_provider.dart';
import '../../providers/audio/sound_states_provider.dart';
import '../../providers/audio/sound_actions_provider.dart';
import 'volume_adjust_sheet.dart';

class SoundCard extends ConsumerStatefulWidget {
  final SoundDefinition sound;
  final Color categoryColor;

  const SoundCard({
    super.key,
    required this.sound,
    required this.categoryColor,
  });

  @override
  ConsumerState<SoundCard> createState() => _SoundCardState();
}

class _SoundCardState extends ConsumerState<SoundCard>
    with SingleTickerProviderStateMixin {
  bool _showFavoriteAnimation = false;

  void _triggerFavoriteAnimation() {
    setState(() => _showFavoriteAnimation = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) setState(() => _showFavoriteAnimation = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final soundStatesAsync = ref.watch(soundStatesStreamProvider);

    return soundStatesAsync.when(
      data: (states) {
        final soundState =
            states.where((s) => s.soundId == widget.sound.id).firstOrNull;
        return _buildCard(context, soundState);
      },
      loading: () => _buildPlaceholder(context),
      error: (error, stack) => _buildErrorCard(context),
    );
  }

  Widget _buildCard(BuildContext context, dynamic soundState) {
    final isSelected = soundState?.isSelected ?? false;
    final volume = soundState?.volume ?? 0.5;
    final isFavorite = soundState?.isFavorite ?? false;
    final isLocked = ref.watch(isLockedProvider);
    final isPlaying = ref.watch(playbackStateProvider);
    final color = widget.categoryColor;

    return GestureDetector(
      onTap: isLocked
          ? null
          : () {
              HapticFeedback.lightImpact();
              ref.read(soundActionsProvider.notifier).toggleSound(widget.sound.id);
            },
      onDoubleTap: () {
        HapticFeedback.mediumImpact();
        _triggerFavoriteAnimation();
        ref.read(soundActionsProvider.notifier).toggleFavorite(widget.sound.id);
      },
      onLongPress: isSelected
          ? () {
              HapticFeedback.heavyImpact();
              _showVolumeSheet(context, widget.sound.id, volume);
            }
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withValues(alpha: 0.3),
                    color.withValues(alpha: 0.15),
                  ],
                )
              : null,
          color: isSelected ? null : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected && isPlaying
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 0,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Stack(
          children: [
            // Favorite indicator
            if (isFavorite)
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.favorite,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.heart,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ),

            // Favorite animation overlay
            if (_showFavoriteAnimation)
              Positioned.fill(
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 400),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.5 + (value * 0.7),
                        child: Opacity(
                          opacity: 1 - (value * 0.5),
                          child: Icon(
                            isFavorite ? LucideIcons.heart : LucideIcons.heartOff,
                            size: 32,
                            color: isFavorite ? AppColors.favorite : Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Main content
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon container
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? color.withValues(alpha: 0.2)
                          : color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _getIcon(widget.sound.icon),
                      size: 18,
                      color: isSelected ? color : color.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Label
                  Text(
                    'sound_names.${widget.sound.id}'.tr(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? color
                          : Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Volume indicator
                  if (isSelected) ...[
                    const SizedBox(height: 4),
                    _VolumeBar(volume: volume, color: color),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Icon(
          LucideIcons.alertCircle,
          color: AppColors.error,
          size: 20,
        ),
      ),
    );
  }

  void _showVolumeSheet(
      BuildContext context, String soundId, double currentVolume) {
    showModalBottomSheet(
      context: context,
      builder: (context) => VolumeAdjustSheet(
        soundId: soundId,
        soundLabel: widget.sound.label,
        initialVolume: currentVolume,
      ),
    );
  }

  IconData _getIcon(String iconName) {
    final iconMap = <String, IconData>{
      'waves': LucideIcons.waves,
      'flame': LucideIcons.flame,
      'wind': LucideIcons.wind,
      'cloud-rain': LucideIcons.cloudRain,
      'cloud-rain-wind': LucideIcons.cloudRainWind,
      'cloud-lightning': LucideIcons.cloudLightning,
      'tree-pine': LucideIcons.treePine,
      'tree-palm': LucideIcons.palmtree,
      'leaf': LucideIcons.leaf,
      'droplet': LucideIcons.droplet,
      'snowflake': LucideIcons.snowflake,
      'footprints': LucideIcons.footprints,
      'bird': LucideIcons.bird,
      'dog': LucideIcons.dog,
      'cat': LucideIcons.cat,
      'bug': LucideIcons.bug,
      'fish': LucideIcons.fish,
      'egg': LucideIcons.egg,
      'hexagon': LucideIcons.hexagon,
      'beef': LucideIcons.beef,
      'cloud': LucideIcons.cloud,
      'car': LucideIcons.car,
      'train': LucideIcons.train,
      'plane': LucideIcons.plane,
      'ship': LucideIcons.ship,
      'sailboat': LucideIcons.sailboat,
      'coffee': LucideIcons.coffee,
      'building': LucideIcons.building,
      'home': LucideIcons.home,
      'church': LucideIcons.church,
      'landmark': LucideIcons.landmark,
      'tent': LucideIcons.tent,
      'umbrella': LucideIcons.umbrella,
      'square': LucideIcons.square,
      'siren': LucideIcons.siren,
      'users': LucideIcons.users,
      'sparkles': LucideIcons.sparkles,
      'map-pin': LucideIcons.mapPin,
      'beer': LucideIcons.beer,
      'shopping-cart': LucideIcons.shoppingCart,
      'ferris-wheel': LucideIcons.ferrisWheel,
      'utensils': LucideIcons.utensils,
      'book-open': LucideIcons.bookOpen,
      'construction': LucideIcons.construction,
      'keyboard': LucideIcons.keyboard,
      'type': LucideIcons.type,
      'file': LucideIcons.file,
      'clock': LucideIcons.clock,
      'circle': LucideIcons.circle,
      'fan': LucideIcons.fan,
      'projector': LucideIcons.projector,
      'radio': LucideIcons.radio,
      'loader': LucideIcons.loader,
      'disc': LucideIcons.disc,
      'box': LucideIcons.box,
      'road': LucideIcons.navigation,
      'traffic-cone': LucideIcons.alertTriangle,
      'flask': LucideIcons.beaker,
      'washing-machine': LucideIcons.loader2,
      'frog': LucideIcons.circleDot,
      'horse': LucideIcons.circleDot,
    };
    return iconMap[iconName] ?? LucideIcons.music;
  }
}

class _VolumeBar extends StatelessWidget {
  final double volume;
  final Color color;

  const _VolumeBar({required this.volume, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: volume,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
