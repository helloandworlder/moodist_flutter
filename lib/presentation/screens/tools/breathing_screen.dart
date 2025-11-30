import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../providers/tools/breathing_provider.dart';

class BreathingScreen extends ConsumerWidget {
  const BreathingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final breathing = ref.watch(breathingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('breathing.title'.tr()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Timer display
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                breathing.formattedTime,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
              ),
            ),

            const Spacer(),

            // Breathing circle animation
            _BreathingCircle(
              scale: breathing.circleScale,
              phase: breathing.currentPhase,
              progress: breathing.phaseProgress,
              isRunning: breathing.isRunning,
            ),

            const SizedBox(height: 32),

            // Phase label
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                breathing.currentPhase.displayName,
                key: ValueKey(breathing.currentPhase),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
            ),

            const Spacer(),

            // Exercise selector
            _ExerciseSelector(
              currentExercise: breathing.exercise,
              onExerciseChanged: (exercise) {
                HapticFeedback.lightImpact();
                ref.read(breathingProvider.notifier).setExercise(exercise);
              },
            ),

            const SizedBox(height: 24),

            // Controls
            _Controls(
              isRunning: breathing.isRunning,
              onToggle: () {
                HapticFeedback.mediumImpact();
                ref.read(breathingProvider.notifier).toggle();
              },
              onReset: () {
                HapticFeedback.lightImpact();
                ref.read(breathingProvider.notifier).reset();
              },
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _BreathingCircle extends StatelessWidget {
  final double scale;
  final BreathingPhase phase;
  final double progress;
  final bool isRunning;

  const _BreathingCircle({
    required this.scale,
    required this.phase,
    required this.progress,
    required this.isRunning,
  });

  Color _getPhaseColor(BuildContext context) {
    switch (phase) {
      case BreathingPhase.inhale:
        return Colors.blue;
      case BreathingPhase.holdInhale:
        return Colors.purple;
      case BreathingPhase.exhale:
        return Colors.teal;
      case BreathingPhase.holdExhale:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getPhaseColor(context);
    const baseSize = 180.0;

    return SizedBox(
      width: 280,
      height: 280,
      child: Center(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          width: baseSize * scale,
          height: baseSize * scale,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: 0.6),
                color.withValues(alpha: 0.3),
                color.withValues(alpha: 0.1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              width: baseSize * scale * 0.6,
              height: baseSize * scale * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.4),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                  width: baseSize * scale * 0.3,
                  height: baseSize * scale * 0.3,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
        )
            .animate(
              onPlay: (controller) {
                if (isRunning) {
                  controller.repeat();
                }
              },
              autoPlay: false,
            )
            .shimmer(
              duration: 2.seconds,
              color: Colors.white.withValues(alpha: 0.2),
            ),
      ),
    );
  }
}

class _ExerciseSelector extends StatelessWidget {
  final BreathingExercise currentExercise;
  final ValueChanged<BreathingExercise> onExerciseChanged;

  const _ExerciseSelector({
    required this.currentExercise,
    required this.onExerciseChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'breathing.cycles'.tr(),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: BreathingExercise.values.map((exercise) {
                final isSelected = exercise == currentExercise;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onExerciseChanged(exercise),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getShortName(exercise),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            currentExercise.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }

  String _getShortName(BreathingExercise exercise) {
    switch (exercise) {
      case BreathingExercise.boxBreathing:
        return 'Box';
      case BreathingExercise.resonantBreathing:
        return 'Resonant';
      case BreathingExercise.breathing478:
        return '4-7-8';
    }
  }
}

class _Controls extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onToggle;
  final VoidCallback onReset;

  const _Controls({
    required this.isRunning,
    required this.onToggle,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset button
        IconButton(
          onPressed: onReset,
          icon: const Icon(LucideIcons.rotateCcw),
          iconSize: 28,
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).cardColor,
            padding: const EdgeInsets.all(16),
          ),
        ),
        const SizedBox(width: 32),
        // Play/Pause button
        GestureDetector(
          onTap: onToggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              isRunning ? LucideIcons.pause : LucideIcons.play,
              color: Colors.white,
              size: 36,
            ),
          ),
        ),
        const SizedBox(width: 32),
        // Info button
        IconButton(
          onPressed: () => _showInfoDialog(context),
          icon: const Icon(LucideIcons.info),
          iconSize: 28,
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).cardColor,
            padding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('breathing.title'.tr()),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _ExerciseInfo(
                title: 'breathing.box'.tr(),
                pattern: '4-4-4-4',
                description: 'breathing.box_desc'.tr(),
              ),
              const SizedBox(height: 16),
              _ExerciseInfo(
                title: 'breathing.resonant'.tr(),
                pattern: '5-5',
                description: 'breathing.resonant_desc'.tr(),
              ),
              const SizedBox(height: 16),
              _ExerciseInfo(
                title: 'breathing.relaxing'.tr(),
                pattern: '4-7-8',
                description: 'breathing.relaxing_desc'.tr(),
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

class _ExerciseInfo extends StatelessWidget {
  final String title;
  final String pattern;
  final String description;

  const _ExerciseInfo({
    required this.title,
    required this.pattern,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                pattern,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
