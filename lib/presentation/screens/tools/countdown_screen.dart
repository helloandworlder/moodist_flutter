import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/timer/countdown_provider.dart';

class CountdownScreen extends ConsumerWidget {
  const CountdownScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countdown = ref.watch(countdownProvider);
    final primaryColor = AppColors.primary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withValues(alpha: 0.15),
              Theme.of(context).scaffoldBackgroundColor,
            ],
            stops: const [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: countdown.hasTime
              ? _TimerView(countdown: countdown, ref: ref)
              : _SetupView(ref: ref),
        ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar();

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
            'countdown.title'.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _SetupView extends StatefulWidget {
  final WidgetRef ref;

  const _SetupView({required this.ref});

  @override
  State<_SetupView> createState() => _SetupViewState();
}

class _SetupViewState extends State<_SetupView> {
  int _hours = 0;
  int _minutes = 5;
  int _seconds = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _CustomAppBar(),
        const Spacer(),
        
        // Time picker
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TimeWheel(
                value: _hours,
                max: 23,
                label: 'hours',
                onChanged: (v) => setState(() => _hours = v),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Text(
                  ':',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
              _TimeWheel(
                value: _minutes,
                max: 59,
                label: 'min',
                onChanged: (v) => setState(() => _minutes = v),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Text(
                  ':',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
              _TimeWheel(
                value: _seconds,
                max: 59,
                label: 'sec',
                onChanged: (v) => setState(() => _seconds = v),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Quick presets
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 12),
                child: Text(
                  'countdown.quick_presets'.tr(),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _PresetChip(label: '1 min', onTap: () => _setTime(0, 1, 0)),
                  _PresetChip(label: '3 min', onTap: () => _setTime(0, 3, 0)),
                  _PresetChip(label: '5 min', onTap: () => _setTime(0, 5, 0)),
                  _PresetChip(label: '10 min', onTap: () => _setTime(0, 10, 0)),
                  _PresetChip(label: '15 min', onTap: () => _setTime(0, 15, 0)),
                  _PresetChip(label: '30 min', onTap: () => _setTime(0, 30, 0)),
                  _PresetChip(label: '1 hour', onTap: () => _setTime(1, 0, 0)),
                ],
              ),
            ],
          ),
        ),

        const Spacer(),

        // Start button
        Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: (_hours > 0 || _minutes > 0 || _seconds > 0)
                    ? AppColors.primaryGradient
                    : null,
                borderRadius: BorderRadius.circular(20),
                boxShadow: (_hours > 0 || _minutes > 0 || _seconds > 0)
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: (_hours > 0 || _minutes > 0 || _seconds > 0)
                    ? Colors.transparent
                    : Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: (_hours > 0 || _minutes > 0 || _seconds > 0)
                      ? () {
                          HapticFeedback.mediumImpact();
                          widget.ref.read(countdownProvider.notifier).setTime(
                                hours: _hours,
                                minutes: _minutes,
                                seconds: _seconds,
                              );
                          widget.ref.read(countdownProvider.notifier).start();
                        }
                      : null,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.play,
                          color: (_hours > 0 || _minutes > 0 || _seconds > 0)
                              ? Colors.white
                              : Colors.grey,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'countdown.start_timer'.tr(),
                          style: TextStyle(
                            color: (_hours > 0 || _minutes > 0 || _seconds > 0)
                                ? Colors.white
                                : Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _setTime(int h, int m, int s) {
    setState(() {
      _hours = h;
      _minutes = m;
      _seconds = s;
    });
  }
}

class _TimeWheel extends StatelessWidget {
  final int value;
  final int max;
  final String label;
  final ValueChanged<int> onChanged;

  const _TimeWheel({
    required this.value,
    required this.max,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 70,
          height: 100,
          child: ListWheelScrollView.useDelegate(
            controller: FixedExtentScrollController(initialItem: value),
            itemExtent: 44,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                if (index < 0 || index > max) return null;
                final isSelected = index == value;
                return Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: isSelected ? 32 : 24,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? AppColors.primary
                          : Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.3),
                    ),
                    child: Text(index.toString().padLeft(2, '0')),
                  ),
                );
              },
              childCount: max + 1,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
              ),
        ),
      ],
    );
  }
}

class _PresetChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PresetChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _TimerView extends StatelessWidget {
  final CountdownState countdown;
  final WidgetRef ref;

  const _TimerView({required this.countdown, required this.ref});

  @override
  Widget build(BuildContext context) {
    final color = countdown.isComplete 
        ? const Color(0xFF10B981)
        : AppColors.primary;

    return Column(
      children: [
        const _CustomAppBar(),
        const Spacer(),

        // Timer display
        SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow effect when running
              if (countdown.isRunning)
                Container(
                  width: 260,
                  height: 260,
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
              // Background card
              Container(
                width: 280,
                height: 280,
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
                width: 280,
                height: 280,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: countdown.progress),
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
              // Time display
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    countdown.formattedTime,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 52,
                          fontFeatures: const [FontFeature.tabularFigures()],
                          color: countdown.isComplete ? color : null,
                        ),
                  ),
                  if (countdown.isComplete) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [color, color.withValues(alpha: 0.8)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'countdown.complete'.tr(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),

        const Spacer(),

        // Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add time button
            _ControlButton(
              icon: LucideIcons.plusCircle,
              onTap: () {
                HapticFeedback.lightImpact();
                ref.read(countdownProvider.notifier).addTime(60);
              },
              tooltip: 'Add 1 minute',
            ),
            const SizedBox(width: 20),
            // Play/Pause button
            GestureDetector(
              onTap: () {
                HapticFeedback.mediumImpact();
                if (countdown.isRunning) {
                  ref.read(countdownProvider.notifier).pause();
                } else if (!countdown.isComplete) {
                  ref.read(countdownProvider.notifier).start();
                }
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Icon(
                  countdown.isComplete
                      ? LucideIcons.check
                      : countdown.isRunning
                          ? LucideIcons.pause
                          : LucideIcons.play,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(width: 20),
            // Reset/Clear button
            _ControlButton(
              icon: countdown.isComplete
                  ? LucideIcons.x
                  : LucideIcons.rotateCcw,
              onTap: () {
                HapticFeedback.lightImpact();
                if (countdown.isComplete) {
                  ref.read(countdownProvider.notifier).clear();
                } else {
                  ref.read(countdownProvider.notifier).reset();
                }
              },
            ),
          ],
        ),

        const SizedBox(height: 24),

        // New timer button
        if (countdown.isComplete || !countdown.isRunning)
          TextButton.icon(
            onPressed: () {
              HapticFeedback.lightImpact();
              ref.read(countdownProvider.notifier).clear();
            },
            icon: const Icon(LucideIcons.plus, size: 18),
            label: Text('countdown.new_timer'.tr()),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),

        const SizedBox(height: 32),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;

  const _ControlButton({
    required this.icon,
    required this.onTap,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: GestureDetector(
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
      ),
    );
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
