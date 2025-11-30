import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../services/tone_generator_service.dart';
import '../../providers/tools/binaural_provider.dart';

class BinauralScreen extends ConsumerWidget {
  const BinauralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final binaural = ref.watch(binauralProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('binaural.title'.tr()),
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
            // Warning card
            _WarningCard(),
            const SizedBox(height: 24),

            // Visualization
            _Visualization(
              isPlaying: binaural.isPlaying,
              beatFrequency: binaural.effectiveBeatFrequency,
            ),
            const SizedBox(height: 32),

            // Preset selector
            _PresetSelector(
              presets: ToneGeneratorService.binauralPresets,
              selectedIndex: binaural.isCustom ? -1 : binaural.presetIndex,
              onPresetSelected: (index) {
                HapticFeedback.lightImpact();
                ref.read(binauralProvider.notifier).setPreset(index);
              },
              onCustomSelected: () {
                HapticFeedback.lightImpact();
                ref.read(binauralProvider.notifier).setCustomMode(true);
              },
              isCustom: binaural.isCustom,
            ),
            const SizedBox(height: 24),

            // Custom frequency controls
            if (binaural.isCustom) ...[
              _FrequencyControl(
                label: 'Base Frequency',
                value: binaural.baseFrequency,
                min: 20,
                max: 1500,
                unit: 'Hz',
                onChanged: (v) =>
                    ref.read(binauralProvider.notifier).setBaseFrequency(v),
              ),
              const SizedBox(height: 16),
              _FrequencyControl(
                label: 'Beat Frequency',
                value: binaural.beatFrequency,
                min: 0.5,
                max: 40,
                unit: 'Hz',
                onChanged: (v) =>
                    ref.read(binauralProvider.notifier).setBeatFrequency(v),
              ),
              const SizedBox(height: 24),
            ],

            // Volume control
            _VolumeControl(
              volume: binaural.volume,
              onChanged: (v) =>
                  ref.read(binauralProvider.notifier).setVolume(v),
            ),
            const SizedBox(height: 32),

            // Play button
            _PlayButton(
              isPlaying: binaural.isPlaying,
              onPressed: () {
                HapticFeedback.mediumImpact();
                ref.read(binauralProvider.notifier).toggle();
              },
            ),
            const SizedBox(height: 16),

            // Headphones reminder
            if (!binaural.isPlaying)
              const _HeadphonesReminder(),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('binaural.title'.tr()),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'binaural.subtitle'.tr(),
                style: const TextStyle(height: 1.5),
              ),
              const SizedBox(height: 16),
              Text(
                '• ${'binaural.delta'.tr()}: ${'binaural.delta_desc'.tr()}',
              ),
              Text(
                '• ${'binaural.theta'.tr()}: ${'binaural.theta_desc'.tr()}',
              ),
              Text(
                '• ${'binaural.alpha'.tr()}: ${'binaural.alpha_desc'.tr()}',
              ),
              Text(
                '• ${'binaural.beta'.tr()}: ${'binaural.beta_desc'.tr()}',
              ),
              Text(
                '• ${'binaural.gamma'.tr()}: ${'binaural.gamma_desc'.tr()}',
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

class _WarningCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(LucideIcons.alertTriangle, color: Colors.amber.shade700, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Use headphones for binaural beats to work effectively',
              style: TextStyle(
                color: Colors.amber.shade700,
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
      duration: const Duration(seconds: 2),
    );
    if (widget.isPlaying) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(_Visualization oldWidget) {
    super.didUpdateWidget(oldWidget);
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
        return Container(
          height: 160,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Left channel indicator
              Positioned(
                left: 40,
                child: _ChannelIndicator(
                  label: 'L',
                  isActive: widget.isPlaying,
                  phase: _controller.value,
                  color: Colors.blue,
                ),
              ),
              // Beat frequency indicator
              if (widget.isPlaying)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.brainCircuit,
                      size: 48,
                      color: Theme.of(context)
                          .primaryColor
                          .withValues(alpha: 0.5 + 0.5 * _controller.value),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.beatFrequency.toStringAsFixed(1)} Hz',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                    const Text(
                      'Beat Frequency',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                )
              else
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      LucideIcons.headphones,
                      size: 48,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ready',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              // Right channel indicator
              Positioned(
                right: 40,
                child: _ChannelIndicator(
                  label: 'R',
                  isActive: widget.isPlaying,
                  phase: (_controller.value + 0.3) % 1.0,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChannelIndicator extends StatelessWidget {
  final String label;
  final bool isActive;
  final double phase;
  final Color color;

  const _ChannelIndicator({
    required this.label,
    required this.isActive,
    required this.phase,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final size = isActive ? 40 + 10 * phase : 40.0;
    final opacity = isActive ? 0.5 + 0.5 * phase : 0.3;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: opacity),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5 * phase,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
        // Custom option
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
                isCustom ? LucideIcons.sliders : LucideIcons.waves,
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
                      '${preset.beatFrequency.toStringAsFixed(0)} Hz',
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

class _HeadphonesReminder extends StatelessWidget {
  const _HeadphonesReminder();

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
            LucideIcons.headphones,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Headphones Required',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  'Binaural beats work by playing different frequencies in each ear',
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
