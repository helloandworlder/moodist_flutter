import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../services/tone_generator_service.dart';
import '../../providers/tools/isochronic_provider.dart';

class IsochronicScreen extends ConsumerWidget {
  const IsochronicScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isochronic = ref.watch(isochronicProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('isochronic.title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.info, size: 20),
            onPressed: () => _showInfoDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Info card
            _InfoCard(),
            const SizedBox(height: 24),

            // Visualization
            _Visualization(
              isPlaying: isochronic.isPlaying,
              beatFrequency: isochronic.effectiveBeatFrequency,
            ),
            const SizedBox(height: 32),

            // Preset selector
            _PresetSelector(
              presets: ToneGeneratorService.isochronicPresets,
              selectedIndex: isochronic.isCustom ? -1 : isochronic.presetIndex,
              onPresetSelected: (index) {
                HapticFeedback.lightImpact();
                ref.read(isochronicProvider.notifier).setPreset(index);
              },
              onCustomSelected: () {
                HapticFeedback.lightImpact();
                ref.read(isochronicProvider.notifier).setCustomMode(true);
              },
              isCustom: isochronic.isCustom,
            ),
            const SizedBox(height: 24),

            // Custom frequency controls
            if (isochronic.isCustom) ...[
              _FrequencyControl(
                label: 'Base Frequency',
                value: isochronic.baseFrequency,
                min: 20,
                max: 2000,
                unit: 'Hz',
                onChanged: (v) =>
                    ref.read(isochronicProvider.notifier).setBaseFrequency(v),
              ),
              const SizedBox(height: 16),
              _FrequencyControl(
                label: 'Tone Frequency',
                value: isochronic.beatFrequency,
                min: 0.5,
                max: 40,
                unit: 'Hz',
                onChanged: (v) =>
                    ref.read(isochronicProvider.notifier).setBeatFrequency(v),
              ),
              const SizedBox(height: 24),
            ],

            // Volume control
            _VolumeControl(
              volume: isochronic.volume,
              onChanged: (v) =>
                  ref.read(isochronicProvider.notifier).setVolume(v),
            ),
            const SizedBox(height: 32),

            // Play button
            _PlayButton(
              isPlaying: isochronic.isPlaying,
              onPressed: () {
                HapticFeedback.mediumImpact();
                ref.read(isochronicProvider.notifier).toggle();
              },
            ),
            const SizedBox(height: 16),

            // Speaker info
            if (!isochronic.isPlaying)
              const _SpeakerInfo(),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('isochronic.title'.tr()),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'isochronic.subtitle'.tr(),
                style: const TextStyle(height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                '• ${'isochronic.delta'.tr()}: ${'isochronic.delta_desc'.tr()}',
              ),
              Text(
                '• ${'isochronic.theta'.tr()}: ${'isochronic.theta_desc'.tr()}',
              ),
              Text(
                '• ${'isochronic.alpha'.tr()}: ${'isochronic.alpha_desc'.tr()}',
              ),
              Text(
                '• ${'isochronic.beta'.tr()}: ${'isochronic.beta_desc'.tr()}',
              ),
              Text(
                '• ${'isochronic.gamma'.tr()}: ${'isochronic.gamma_desc'.tr()}',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.ok'.tr()),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.speaker, color: Colors.green.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Headphones optional - works with speakers too!',
              style: TextStyle(
                color: Colors.green.shade700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Visualization extends StatefulWidget {
  final bool isPlaying;
  final double beatFrequency;

  const _Visualization({
    required this.isPlaying,
    required this.beatFrequency,
  });

  @override
  State<_Visualization> createState() => _VisualizationState();
}

class _VisualizationState extends State<_Visualization>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (1000 / widget.beatFrequency).round()),
    );
    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(_Visualization oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.beatFrequency != oldWidget.beatFrequency) {
      _controller.duration =
          Duration(milliseconds: (1000 / widget.beatFrequency).round());
    }
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _controller.repeat();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _controller.stop();
      _controller.reset();
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
        final isOn = widget.isPlaying && _controller.value < 0.5;

        return Container(
          height: 160,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulse indicator
              AnimatedContainer(
                duration: const Duration(milliseconds: 50),
                width: isOn ? 120 : 80,
                height: isOn ? 120 : 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOn
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).primaryColor.withValues(alpha: 0.2),
                  boxShadow: isOn
                      ? [
                          BoxShadow(
                            color: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.5),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ]
                      : null,
                ),
              ),
              // Center content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    LucideIcons.radio,
                    size: 32,
                    color: isOn ? Colors.white : Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  if (widget.isPlaying)
                    Text(
                      '${widget.beatFrequency.toStringAsFixed(1)} Hz',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isOn ? Colors.white : Colors.grey,
                      ),
                    )
                  else
                    Text(
                      'Ready',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PresetSelector extends StatelessWidget {
  final List<TonePreset> presets;
  final int selectedIndex;
  final ValueChanged<int> onPresetSelected;
  final VoidCallback onCustomSelected;
  final bool isCustom;

  const _PresetSelector({
    required this.presets,
    required this.selectedIndex,
    required this.onPresetSelected,
    required this.onCustomSelected,
    required this.isCustom,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Preset',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: Colors.grey,
              ),
        ),
        const SizedBox(height: 12),
        ...presets.asMap().entries.map((entry) {
          final index = entry.key;
          final preset = entry.value;
          final isSelected = !isCustom && selectedIndex == index;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _PresetCard(
              preset: preset,
              isSelected: isSelected,
              onTap: () => onPresetSelected(index),
            ),
          );
        }),
        _PresetCard(
          preset: const TonePreset(
            name: 'Custom',
            baseFrequency: 0,
            beatFrequency: 0,
            description: 'Set your own frequencies',
          ),
          isSelected: isCustom,
          onTap: onCustomSelected,
          isCustom: true,
        ),
      ],
    );
  }
}

class _PresetCard extends StatelessWidget {
  final TonePreset preset;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isCustom;

  const _PresetCard({
    required this.preset,
    required this.isSelected,
    required this.onTap,
    this.isCustom = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withValues(alpha: 0.15)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.withValues(alpha: 0.2),
              ),
              child: Icon(
                isCustom ? LucideIcons.sliders : LucideIcons.radio,
                size: 20,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    preset.name,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  if (!isCustom) ...[
                    const SizedBox(height: 2),
                    Text(
                      '${preset.beatFrequency.toStringAsFixed(0)} Hz pulse',
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              Icon(
                LucideIcons.check,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class _FrequencyControl extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String unit;
  final ValueChanged<double> onChanged;

  const _FrequencyControl({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.unit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${value.toStringAsFixed(1)} $unit',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${min.toStringAsFixed(0)} $unit',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              '${max.toStringAsFixed(0)} $unit',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Volume',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              '${(volume * 100).toInt()}%',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              volume == 0 ? LucideIcons.volumeX : LucideIcons.volume1,
              size: 20,
              color: Colors.grey,
            ),
            Expanded(
              child: Slider(
                value: volume,
                min: 0,
                max: 1,
                onChanged: onChanged,
              ),
            ),
            const Icon(LucideIcons.volume2, size: 20, color: Colors.grey),
          ],
        ),
      ],
    );
  }
}

class _PlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  const _PlayButton({
    required this.isPlaying,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: isPlaying ? Colors.red : Theme.of(context).primaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isPlaying ? Colors.red : Theme.of(context).primaryColor)
                    .withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            isPlaying ? LucideIcons.square : LucideIcons.play,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
    );
  }
}

class _SpeakerInfo extends StatelessWidget {
  const _SpeakerInfo();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            LucideIcons.speaker,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Speakers or Headphones',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'Isochronic tones work with any audio output',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
