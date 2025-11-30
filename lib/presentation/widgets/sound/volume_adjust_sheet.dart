import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../providers/audio/sound_actions_provider.dart';

class VolumeAdjustSheet extends ConsumerStatefulWidget {
  final String soundId;
  final String soundLabel;
  final double initialVolume;

  const VolumeAdjustSheet({
    super.key,
    required this.soundId,
    required this.soundLabel,
    required this.initialVolume,
  });

  @override
  ConsumerState<VolumeAdjustSheet> createState() => _VolumeAdjustSheetState();
}

class _VolumeAdjustSheetState extends ConsumerState<VolumeAdjustSheet> {
  late double _volume;

  @override
  void initState() {
    super.initState();
    _volume = widget.initialVolume;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag indicator
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            'sound_names.${widget.soundId}'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'sounds.volume_percent'.tr(args: ['${(_volume * 100).toInt()}']),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),

          // Slider
          Slider(
            value: _volume,
            min: 0,
            max: 1,
            divisions: 20,
            onChanged: (value) {
              setState(() => _volume = value);
            },
            onChangeEnd: (value) {
              ref
                  .read(soundActionsProvider.notifier)
                  .setVolume(widget.soundId, value);
            },
          ),
          const SizedBox(height: 16),

          // Quick setting buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _QuickVolumeButton(
                label: '25%',
                onTap: () => _setVolume(0.25),
              ),
              _QuickVolumeButton(
                label: '50%',
                onTap: () => _setVolume(0.5),
              ),
              _QuickVolumeButton(
                label: '75%',
                onTap: () => _setVolume(0.75),
              ),
              _QuickVolumeButton(
                label: '100%',
                onTap: () => _setVolume(1.0),
              ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  void _setVolume(double volume) {
    setState(() => _volume = volume);
    ref.read(soundActionsProvider.notifier).setVolume(widget.soundId, volume);
  }
}

class _QuickVolumeButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickVolumeButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade600),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label),
      ),
    );
  }
}
