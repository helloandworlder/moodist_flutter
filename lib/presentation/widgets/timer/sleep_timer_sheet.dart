import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../providers/timer/sleep_timer_provider.dart';

class SleepTimerSheet extends ConsumerWidget {
  const SleepTimerSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sleepTimer = ref.watch(sleepTimerProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Header
          Row(
            children: [
              Icon(
                LucideIcons.moon,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Sleep Timer',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Music will gradually fade out and stop after the timer ends.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 24),

          if (sleepTimer.isActive) ...[
            // Active timer display
            _ActiveTimerDisplay(sleepTimer: sleepTimer, ref: ref),
          ] else ...[
            // Timer selection
            _TimerSelection(ref: ref),
          ],

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}

class _ActiveTimerDisplay extends StatelessWidget {
  final SleepTimerState sleepTimer;
  final WidgetRef ref;

  const _ActiveTimerDisplay({required this.sleepTimer, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Timer display
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Text(
                sleepTimer.formattedTime,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'remaining',
                style: TextStyle(color: Colors.grey.shade500),
              ),
              const SizedBox(height: 16),
              // Progress bar
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: sleepTimer.progress,
                  minHeight: 8,
                  backgroundColor:
                      Theme.of(context).primaryColor.withValues(alpha: 0.2),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Quick add buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _QuickAddButton(
              label: '+5m',
              onTap: () {
                HapticFeedback.lightImpact();
                ref.read(sleepTimerProvider.notifier).addTime(5);
              },
            ),
            const SizedBox(width: 12),
            _QuickAddButton(
              label: '+10m',
              onTap: () {
                HapticFeedback.lightImpact();
                ref.read(sleepTimerProvider.notifier).addTime(10);
              },
            ),
            const SizedBox(width: 12),
            _QuickAddButton(
              label: '+15m',
              onTap: () {
                HapticFeedback.lightImpact();
                ref.read(sleepTimerProvider.notifier).addTime(15);
              },
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Cancel button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              HapticFeedback.mediumImpact();
              ref.read(sleepTimerProvider.notifier).stop();
              Navigator.pop(context);
            },
            icon: const Icon(LucideIcons.x, size: 18),
            label: const Text('Cancel Timer'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickAddButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickAddButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _TimerSelection extends StatelessWidget {
  final WidgetRef ref;

  const _TimerSelection({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Preset buttons
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: SleepTimerPresets.presets.map((minutes) {
            return _PresetButton(
              minutes: minutes,
              onTap: () {
                HapticFeedback.mediumImpact();
                final hours = minutes ~/ 60;
                final mins = minutes % 60;
                ref.read(sleepTimerProvider.notifier).start(
                      hours: hours,
                      minutes: mins,
                    );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        const Icon(LucideIcons.moon,
                            color: Colors.white, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          'Sleep timer set for ${SleepTimerPresets.formatPreset(minutes)}',
                        ),
                      ],
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Custom time button
        OutlinedButton.icon(
          onPressed: () => _showCustomTimePicker(context, ref),
          icon: const Icon(LucideIcons.clock, size: 18),
          label: const Text('Custom Time'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  void _showCustomTimePicker(BuildContext context, WidgetRef ref) {
    int hours = 0;
    int minutes = 30;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Set Custom Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hours
                  Column(
                    children: [
                      IconButton(
                        onPressed: hours < 12
                            ? () => setState(() => hours++)
                            : null,
                        icon: const Icon(LucideIcons.chevronUp),
                      ),
                      Text(
                        '$hours',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed:
                            hours > 0 ? () => setState(() => hours--) : null,
                        icon: const Icon(LucideIcons.chevronDown),
                      ),
                      const Text('hours'),
                    ],
                  ),
                  const SizedBox(width: 24),
                  const Text(':',
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 24),
                  // Minutes
                  Column(
                    children: [
                      IconButton(
                        onPressed: () =>
                            setState(() => minutes = (minutes + 5) % 60),
                        icon: const Icon(LucideIcons.chevronUp),
                      ),
                      Text(
                        minutes.toString().padLeft(2, '0'),
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () => setState(
                            () => minutes = minutes > 0 ? minutes - 5 : 55),
                        icon: const Icon(LucideIcons.chevronDown),
                      ),
                      const Text('min'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('common.cancel'.tr()),
            ),
            FilledButton(
              onPressed: (hours > 0 || minutes > 0)
                  ? () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Close sheet
                      ref.read(sleepTimerProvider.notifier).start(
                            hours: hours,
                            minutes: minutes,
                          );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(LucideIcons.moon,
                                  color: Colors.white, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                'Sleep timer set for ${hours > 0 ? "${hours}h " : ""}${minutes}m',
                              ),
                            ],
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  : null,
              child: const Text('Set'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PresetButton extends StatelessWidget {
  final int minutes;
  final VoidCallback onTap;

  const _PresetButton({required this.minutes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              SleepTimerPresets.formatPreset(minutes),
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
