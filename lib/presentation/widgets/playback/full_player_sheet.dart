import 'dart:math' as math;
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
import '../preset/save_preset_sheet.dart';
import '../share/share_sheet.dart';
import '../timer/sleep_timer_sheet.dart';

class FullPlayerSheet extends ConsumerWidget {
  const FullPlayerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = ref.watch(playbackStateProvider);
    final isLocked = ref.watch(isLockedProvider);
    final globalVolume = ref.watch(globalVolumeProvider);
    final selectedSoundsAsync = ref.watch(selectedSoundsStreamProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryStart,
                AppColors.primaryEnd,
                Theme.of(context).brightness == Brightness.dark
                    ? AppColors.darkBackground
                    : AppColors.lightBackground,
              ],
              stops: const [0, 0.3, 0.6],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Header
                    Text(
                      'player.now_playing'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    
                    // Visualization
                    _PlayerVisualization(isPlaying: isPlaying),
                    const SizedBox(height: 32),
                    
                    // Active sounds list
                    selectedSoundsAsync.when(
                      data: (sounds) => _ActiveSoundsList(
                        sounds: sounds,
                        onVolumeChanged: (soundId, volume) {
                          ref.read(soundActionsProvider.notifier).setVolume(soundId, volume);
                        },
                        onRemove: (soundId) {
                          HapticFeedback.lightImpact();
                          ref.read(soundActionsProvider.notifier).unselectSound(soundId);
                        },
                      ),
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (error, stack) => const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 32),
                    
                    // Global volume
                    _VolumeControl(
                      volume: globalVolume,
                      onChanged: (value) {
                        ref.read(globalVolumeProvider.notifier).setVolume(value);
                      },
                    ),
                    const SizedBox(height: 32),
                    
                    // Main controls
                    _MainControls(
                      isPlaying: isPlaying,
                      isLocked: isLocked,
                      onPlayPause: () {
                        HapticFeedback.mediumImpact();
                        ref.read(playbackStateProvider.notifier).toggle();
                      },
                      onShuffle: () {
                        HapticFeedback.lightImpact();
                        ref.read(soundActionsProvider.notifier).shuffle();
                      },
                      onClear: () {
                        HapticFeedback.lightImpact();
                        ref.read(soundActionsProvider.notifier).unselectAll();
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 24),
                    
                    // Action buttons
                    _ActionButtons(
                      onSave: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          builder: (context) => const SavePresetSheet(),
                        );
                      },
                      onShare: () => showShareSheet(context),
                      onTimer: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                          builder: (context) => const SleepTimerSheet(),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PlayerVisualization extends StatefulWidget {
  final bool isPlaying;

  const _PlayerVisualization({required this.isPlaying});

  @override
  State<_PlayerVisualization> createState() => _PlayerVisualizationState();
}

class _PlayerVisualizationState extends State<_PlayerVisualization>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(_PlayerVisualization oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _controller.repeat();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: const Size(double.infinity, 180),
            painter: _WavePainter(
              animation: _controller.value,
              isPlaying: widget.isPlaying,
            ),
          );
        },
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final double animation;
  final bool isPlaying;

  _WavePainter({required this.animation, required this.isPlaying});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final amplitude = isPlaying ? 40.0 : 10.0;

    for (int wave = 0; wave < 3; wave++) {
      final path = Path();
      final opacity = 0.3 + (wave * 0.2);
      paint.color = Colors.white.withValues(alpha: opacity);

      for (double x = 0; x <= size.width; x++) {
        final normalizedX = x / size.width;
        final waveOffset = wave * 0.3;
        final y = centerY +
            amplitude *
                math.sin((normalizedX * 4 * math.pi) +
                    (animation * 2 * math.pi) +
                    waveOffset);

        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) {
    return oldDelegate.animation != animation || oldDelegate.isPlaying != isPlaying;
  }
}

class _ActiveSoundsList extends StatelessWidget {
  final List<dynamic> sounds;
  final Function(String, double) onVolumeChanged;
  final Function(String) onRemove;

  const _ActiveSoundsList({
    required this.sounds,
    required this.onVolumeChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    if (sounds.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'player.active_sounds'.tr(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          ...sounds.map((sound) {
            final soundDef = SoundAssets.getSoundById(sound.soundId);
            return _SoundItem(
              soundId: sound.soundId,
              label: soundDef?.label ?? sound.soundId,
              volume: sound.volume,
              onVolumeChanged: (v) => onVolumeChanged(sound.soundId, v),
              onRemove: () => onRemove(sound.soundId),
            );
          }),
        ],
      ),
    );
  }
}

class _SoundItem extends StatelessWidget {
  final String soundId;
  final String label;
  final double volume;
  final ValueChanged<double> onVolumeChanged;
  final VoidCallback onRemove;

  const _SoundItem({
    required this.soundId,
    required this.label,
    required this.volume,
    required this.onVolumeChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                value: volume,
                onChanged: onVolumeChanged,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '${(volume * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.end,
            ),
          ),
          IconButton(
            icon: const Icon(LucideIcons.x, size: 18),
            onPressed: onRemove,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}

class _VolumeControl extends StatelessWidget {
  final double volume;
  final ValueChanged<double> onChanged;

  const _VolumeControl({
    required this.volume,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Master Volume',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                '${(volume * 100).toInt()}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                volume == 0 ? LucideIcons.volumeX : LucideIcons.volume1,
                size: 20,
              ),
              Expanded(
                child: Slider(
                  value: volume,
                  onChanged: onChanged,
                ),
              ),
              const Icon(LucideIcons.volume2, size: 20),
            ],
          ),
        ],
      ),
    );
  }
}

class _MainControls extends StatelessWidget {
  final bool isPlaying;
  final bool isLocked;
  final VoidCallback onPlayPause;
  final VoidCallback onShuffle;
  final VoidCallback onClear;

  const _MainControls({
    required this.isPlaying,
    required this.isLocked,
    required this.onPlayPause,
    required this.onShuffle,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Shuffle button
        _CircleButton(
          icon: LucideIcons.shuffle,
          onTap: onShuffle,
          size: 56,
        ),
        const SizedBox(width: 24),
        
        // Play/Pause button
        _PlayButton(
          isPlaying: isPlaying,
          isLocked: isLocked,
          onTap: onPlayPause,
        ),
        const SizedBox(width: 24),
        
        // Clear button
        _CircleButton(
          icon: LucideIcons.trash2,
          onTap: onClear,
          size: 56,
          isDestructive: true,
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final bool isDestructive;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.size,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : Theme.of(context).cardColor;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.white : Theme.of(context).iconTheme.color,
          size: size * 0.4,
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final bool isPlaying;
  final bool isLocked;
  final VoidCallback onTap;

  const _PlayButton({
    required this.isPlaying,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.5),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Icon(
          isPlaying ? LucideIcons.pause : LucideIcons.play,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onShare;
  final VoidCallback onTimer;

  const _ActionButtons({
    required this.onSave,
    required this.onShare,
    required this.onTimer,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ActionButton(
          icon: LucideIcons.save,
          label: 'player.save'.tr(),
          onTap: onSave,
        ),
        _ActionButton(
          icon: LucideIcons.share2,
          label: 'player.share'.tr(),
          onTap: onShare,
        ),
        _ActionButton(
          icon: LucideIcons.moon,
          label: 'player.sleep'.tr(),
          onTap: onTimer,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
