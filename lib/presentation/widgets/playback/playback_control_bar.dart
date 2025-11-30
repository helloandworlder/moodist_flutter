import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/audio/playback_provider.dart';
import '../../providers/audio/sound_states_provider.dart';
import '../../providers/audio/sound_actions_provider.dart';
import '../preset/save_preset_sheet.dart';
import '../share/share_sheet.dart';

class PlaybackControlBar extends ConsumerStatefulWidget {
  const PlaybackControlBar({super.key});

  @override
  ConsumerState<PlaybackControlBar> createState() => _PlaybackControlBarState();
}

class _PlaybackControlBarState extends ConsumerState<PlaybackControlBar> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasSelection = ref.watch(hasSelectionProvider);
    final selectedSoundsAsync = ref.watch(selectedSoundsStreamProvider);
    final isPlaying = ref.watch(playbackStateProvider);
    final isLocked = ref.watch(isLockedProvider);
    final globalVolume = ref.watch(globalVolumeProvider);

    final selectedCount = selectedSoundsAsync.maybeWhen(
      data: (sounds) => sounds.length,
      orElse: () => 0,
    );

    if (!hasSelection) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            GestureDetector(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),

            // Main controls row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Play/Pause button
                  _PlayPauseButton(
                    isPlaying: isPlaying,
                    isLocked: isLocked,
                    selectedCount: selectedCount,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      ref.read(playbackStateProvider.notifier).toggle();
                    },
                  ),
                  const SizedBox(width: 16),

                  // Volume slider
                  Expanded(
                    child: _VolumeSlider(
                      volume: globalVolume,
                      onChanged: (value) {
                        ref.read(globalVolumeProvider.notifier).setVolume(value);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Expand button
                  IconButton(
                    icon: Icon(
                      _isExpanded
                          ? LucideIcons.chevronDown
                          : LucideIcons.chevronUp,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _isExpanded = !_isExpanded),
                  ),
                ],
              ),
            ),

            // Expanded controls
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _ExpandedControls(
                onShuffle: () {
                  HapticFeedback.lightImpact();
                  ref.read(soundActionsProvider.notifier).shuffle();
                },
                onUnselectAll: () {
                  HapticFeedback.lightImpact();
                  ref.read(soundActionsProvider.notifier).unselectAll();
                },
                onSavePreset: () {
                  HapticFeedback.lightImpact();
                  _showSavePresetSheet(context);
                },
                onShare: () {
                  HapticFeedback.lightImpact();
                  showShareSheet(context);
                },
                selectedCount: selectedCount,
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    ).animate().slideY(
          begin: 1,
          end: 0,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }

  void _showSavePresetSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const SavePresetSheet(),
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final bool isPlaying;
  final bool isLocked;
  final int selectedCount;
  final VoidCallback onTap;

  const _PlayPauseButton({
    required this.isPlaying,
    required this.isLocked,
    required this.selectedCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLocked ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: isLocked
              ? Colors.grey
              : isPlaying
                  ? AppColors.primary
                  : Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          boxShadow: isPlaying
              ? [
                  BoxShadow(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              isPlaying ? LucideIcons.pause : LucideIcons.play,
              color: Colors.white,
              size: 24,
            ),
            // Selected count badge
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$selectedCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VolumeSlider extends StatelessWidget {
  final double volume;
  final ValueChanged<double> onChanged;

  const _VolumeSlider({
    required this.volume,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          volume == 0
              ? LucideIcons.volumeX
              : volume < 0.5
                  ? LucideIcons.volume1
                  : LucideIcons.volume2,
          size: 18,
          color: Theme.of(context).iconTheme.color,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: volume,
              min: 0,
              max: 1,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            '${(volume * 100).toInt()}%',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _ExpandedControls extends StatelessWidget {
  final VoidCallback onShuffle;
  final VoidCallback onUnselectAll;
  final VoidCallback onSavePreset;
  final VoidCallback onShare;
  final int selectedCount;

  const _ExpandedControls({
    required this.onShuffle,
    required this.onUnselectAll,
    required this.onSavePreset,
    required this.onShare,
    required this.selectedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  icon: LucideIcons.shuffle,
                  label: 'Shuffle',
                  onTap: onShuffle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  icon: LucideIcons.save,
                  label: 'Save',
                  onTap: onSavePreset,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  icon: LucideIcons.share2,
                  label: 'Share',
                  onTap: onShare,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ActionButton(
                  icon: LucideIcons.x,
                  label: 'Clear',
                  onTap: onUnselectAll,
                  isDestructive: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : Theme.of(context).primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: color.withValues(alpha: 0.5)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
