import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/audio/playback_provider.dart';
import '../../providers/audio/sound_states_provider.dart';
import '../../providers/audio/sound_actions_provider.dart';
import 'full_player_sheet.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = ref.watch(playbackStateProvider);
    final isLocked = ref.watch(isLockedProvider);
    final globalVolume = ref.watch(globalVolumeProvider);
    final selectedSoundsAsync = ref.watch(selectedSoundsStreamProvider);

    final selectedCount = selectedSoundsAsync.maybeWhen(
      data: (sounds) => sounds.length,
      orElse: () => 0,
    );

    return GestureDetector(
      onTap: () => _showFullPlayer(context),
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity != null && details.primaryVelocity! < -500) {
          _showFullPlayer(context);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                child: Row(
                  children: [
                    // Sound wave animation
                    _SoundWaveAnimation(isPlaying: isPlaying),
                    const SizedBox(width: 12),
                    
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedCount == 1
                                ? 'sounds.playing_one'.tr(args: ['$selectedCount'])
                                : 'sounds.playing_many'.tr(args: ['$selectedCount']),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'sounds.volume_percent'.tr(args: ['${(globalVolume * 100).toInt()}']),
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Controls
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Shuffle button
                        _MiniButton(
                          icon: LucideIcons.shuffle,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ref.read(soundActionsProvider.notifier).shuffle();
                          },
                        ),
                        
                        // Play/Pause button
                        _PlayPauseButton(
                          isPlaying: isPlaying,
                          isLocked: isLocked,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            ref.read(playbackStateProvider.notifier).toggle();
                          },
                        ),
                        
                        // Expand button
                        _MiniButton(
                          icon: LucideIcons.chevronUp,
                          onTap: () => _showFullPlayer(context),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Progress bar
              LinearProgressIndicator(
                value: globalVolume,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullPlayer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FullPlayerSheet(),
    );
  }
}

class _SoundWaveAnimation extends StatefulWidget {
  final bool isPlaying;

  const _SoundWaveAnimation({required this.isPlaying});

  @override
  State<_SoundWaveAnimation> createState() => _SoundWaveAnimationState();
}

class _SoundWaveAnimationState extends State<_SoundWaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    if (widget.isPlaying) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(_SoundWaveAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _controller.repeat(reverse: true);
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(3, (index) {
              final delay = index * 0.15;
              final height = widget.isPlaying
                  ? 8 + 12 * ((_controller.value + delay) % 1.0)
                  : 8.0;
              return Container(
                width: 4,
                height: height,
                margin: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

class _MiniButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _MiniButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final bool isLocked;
  final VoidCallback onTap;

  const _PlayPauseButton({
    required this.isPlaying,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            isPlaying ? LucideIcons.pause : LucideIcons.play,
            color: AppColors.primary,
            size: 22,
          ),
        ),
      ),
    );
  }
}
