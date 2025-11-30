import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/timer/pomodoro_provider.dart';

class PomodoroScreen extends ConsumerWidget {
  const PomodoroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pomodoro = ref.watch(pomodoroProvider);
    final phaseColor = _getPhaseColor(pomodoro.phase);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              phaseColor.withValues(alpha: 0.15),
              Theme.of(context).scaffoldBackgroundColor,
            ],
            stops: const [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              _CustomAppBar(
                onSettingsTap: () => _showSettingsSheet(context, ref),
              ),

              // Stats row
              _StatsRow(
                focusCount: pomodoro.focusCount,
                breakCount: pomodoro.breakCount,
              ),

              const Spacer(),

              // Timer display
              _TimerDisplay(
                phase: pomodoro.phase,
                formattedTime: pomodoro.formattedTime,
                progress: pomodoro.progress,
                isRunning: pomodoro.isRunning,
              ),

              const SizedBox(height: 40),

              // Phase selector
              _PhaseSelector(
                currentPhase: pomodoro.phase,
                onPhaseSelected: (phase) {
                  HapticFeedback.lightImpact();
                  ref.read(pomodoroProvider.notifier).setPhase(phase);
                },
              ),

              const Spacer(),

              // Controls
              _Controls(
                isRunning: pomodoro.isRunning,
                phaseColor: phaseColor,
                onStart: () {
                  HapticFeedback.mediumImpact();
                  ref.read(pomodoroProvider.notifier).start();
                },
                onPause: () {
                  HapticFeedback.lightImpact();
                  ref.read(pomodoroProvider.notifier).pause();
                },
                onReset: () {
                  HapticFeedback.lightImpact();
                  ref.read(pomodoroProvider.notifier).reset();
                },
                onSkip: () {
                  HapticFeedback.lightImpact();
                  ref.read(pomodoroProvider.notifier).skipToNext();
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPhaseColor(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.focus:
        return AppColors.error;
      case PomodoroPhase.shortBreak:
        return AppColors.success;
      case PomodoroPhase.longBreak:
        return AppColors.info;
    }
  }

  void _showSettingsSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => _SettingsSheet(ref: ref),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final VoidCallback onSettingsTap;

  const _CustomAppBar({required this.onSettingsTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(LucideIcons.arrowLeft),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).cardColor,
            ),
          ),
          const Spacer(),
          Text(
            'pomodoro.title'.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onSettingsTap,
            icon: const Icon(LucideIcons.settings, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).cardColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final int focusCount;
  final int breakCount;

  const _StatsRow({required this.focusCount, required this.breakCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: LucideIcons.brain,
              label: 'pomodoro.focus_sessions'.tr(),
              count: focusCount,
              color: AppColors.error,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StatCard(
              icon: LucideIcons.coffee,
              label: 'pomodoro.breaks_taken'.tr(),
              count: breakCount,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            '$count',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TimerDisplay extends StatelessWidget {
  final PomodoroPhase phase;
  final String formattedTime;
  final double progress;
  final bool isRunning;

  const _TimerDisplay({
    required this.phase,
    required this.formattedTime,
    required this.progress,
    required this.isRunning,
  });

  Color _getPhaseColor() {
    switch (phase) {
      case PomodoroPhase.focus:
        return AppColors.error;
      case PomodoroPhase.shortBreak:
        return AppColors.success;
      case PomodoroPhase.longBreak:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getPhaseColor();

    return Column(
      children: [
        SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow effect
              if (isRunning)
                Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                ),
              // Background circle
              Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
              ),
              // Progress circle
              SizedBox(
                width: 260,
                height: 260,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) {
                    return CustomPaint(
                      painter: _CircleProgressPainter(
                        progress: value,
                        color: color,
                        backgroundColor: color.withValues(alpha: 0.15),
                        strokeWidth: 10,
                      ),
                    );
                  },
                ),
              ),
              // Time text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formattedTime,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 56,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withValues(alpha: 0.8)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _getPhaseLabel(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getPhaseLabel() {
    switch (phase) {
      case PomodoroPhase.focus:
        return 'pomodoro.focus_time'.tr();
      case PomodoroPhase.shortBreak:
        return 'pomodoro.short_break'.tr();
      case PomodoroPhase.longBreak:
        return 'pomodoro.long_break'.tr();
    }
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _CircleProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background arc
    final bgPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class _PhaseSelector extends StatelessWidget {
  final PomodoroPhase currentPhase;
  final ValueChanged<PomodoroPhase> onPhaseSelected;

  const _PhaseSelector({
    required this.currentPhase,
    required this.onPhaseSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _PhaseButton(
              label: 'pomodoro.focus'.tr(),
              isSelected: currentPhase == PomodoroPhase.focus,
              color: AppColors.error,
              onTap: () => onPhaseSelected(PomodoroPhase.focus),
            ),
          ),
          Expanded(
            child: _PhaseButton(
              label: 'pomodoro.short'.tr(),
              isSelected: currentPhase == PomodoroPhase.shortBreak,
              color: AppColors.success,
              onTap: () => onPhaseSelected(PomodoroPhase.shortBreak),
            ),
          ),
          Expanded(
            child: _PhaseButton(
              label: 'pomodoro.long'.tr(),
              isSelected: currentPhase == PomodoroPhase.longBreak,
              color: AppColors.info,
              onTap: () => onPhaseSelected(PomodoroPhase.longBreak),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhaseButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _PhaseButton({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [color, color.withValues(alpha: 0.8)])
              : null,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _Controls extends StatelessWidget {
  final bool isRunning;
  final Color phaseColor;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;
  final VoidCallback onSkip;

  const _Controls({
    required this.isRunning,
    required this.phaseColor,
    required this.onStart,
    required this.onPause,
    required this.onReset,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset button
        _ControlButton(
          icon: LucideIcons.rotateCcw,
          onTap: onReset,
        ),
        const SizedBox(width: 20),
        // Play/Pause button
        GestureDetector(
          onTap: isRunning ? onPause : onStart,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [phaseColor, phaseColor.withValues(alpha: 0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: phaseColor.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              isRunning ? LucideIcons.pause : LucideIcons.play,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        const SizedBox(width: 20),
        // Skip button
        _ControlButton(
          icon: LucideIcons.skipForward,
          onTap: onSkip,
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, size: 24),
      ),
    );
  }
}

class _SettingsSheet extends ConsumerStatefulWidget {
  final WidgetRef ref;

  const _SettingsSheet({required this.ref});

  @override
  ConsumerState<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends ConsumerState<_SettingsSheet> {
  late int _focusMinutes;
  late int _shortBreakMinutes;
  late int _longBreakMinutes;

  @override
  void initState() {
    super.initState();
    final state = widget.ref.read(pomodoroProvider);
    _focusMinutes = state.focusDuration ~/ 60;
    _shortBreakMinutes = state.shortBreakDuration ~/ 60;
    _longBreakMinutes = state.longBreakDuration ~/ 60;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'pomodoro.settings'.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),
          _DurationSetting(
            label: 'pomodoro.focus_duration'.tr(),
            value: _focusMinutes,
            color: AppColors.error,
            onChanged: (v) => setState(() => _focusMinutes = v),
          ),
          const SizedBox(height: 16),
          _DurationSetting(
            label: 'pomodoro.short_break'.tr(),
            value: _shortBreakMinutes,
            color: AppColors.success,
            onChanged: (v) => setState(() => _shortBreakMinutes = v),
          ),
          const SizedBox(height: 16),
          _DurationSetting(
            label: 'pomodoro.long_break'.tr(),
            value: _longBreakMinutes,
            color: AppColors.info,
            onChanged: (v) => setState(() => _longBreakMinutes = v),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text('common.cancel'.tr()),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    widget.ref.read(pomodoroProvider.notifier).updateSettings(
                          focus: _focusMinutes * 60,
                          shortBreak: _shortBreakMinutes * 60,
                          longBreak: _longBreakMinutes * 60,
                        );
                    Navigator.pop(context);
                  },
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text('common.save'.tr()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DurationSetting extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final ValueChanged<int> onChanged;

  const _DurationSetting({
    required this.label,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              label.contains('Focus') ? LucideIcons.brain : LucideIcons.coffee,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
          Row(
            children: [
              _StepperButton(
                icon: LucideIcons.minus,
                onTap: value > 1 ? () => onChanged(value - 1) : null,
              ),
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$value min',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _StepperButton(
                icon: LucideIcons.plus,
                onTap: value < 120 ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepperButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onTap != null
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 16,
          color: onTap != null ? AppColors.primary : Colors.grey,
        ),
      ),
    );
  }
}
