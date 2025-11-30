import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../services/audio_service.dart';
import '../../../services/notification_service.dart';

part 'sleep_timer_provider.g.dart';

class SleepTimerState {
  final int totalSeconds;
  final int remainingSeconds;
  final bool isActive;

  const SleepTimerState({
    this.totalSeconds = 0,
    this.remainingSeconds = 0,
    this.isActive = false,
  });

  SleepTimerState copyWith({
    int? totalSeconds,
    int? remainingSeconds,
    bool? isActive,
  }) {
    return SleepTimerState(
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isActive: isActive ?? this.isActive,
    );
  }

  String get formattedTime {
    final hours = remainingSeconds ~/ 3600;
    final minutes = (remainingSeconds % 3600) ~/ 60;
    final seconds = remainingSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }

  double get progress {
    if (totalSeconds == 0) return 0;
    return 1 - (remainingSeconds / totalSeconds);
  }
}

@Riverpod(keepAlive: true)
class SleepTimer extends _$SleepTimer {
  Timer? _timer;

  @override
  SleepTimerState build() => const SleepTimerState();

  void start({int hours = 0, int minutes = 0}) {
    final totalSeconds = hours * 3600 + minutes * 60;
    if (totalSeconds <= 0) return;

    _timer?.cancel();
    state = SleepTimerState(
      totalSeconds: totalSeconds,
      remainingSeconds: totalSeconds,
      isActive: true,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void stop() {
    _timer?.cancel();
    state = const SleepTimerState();
  }

  void addTime(int minutes) {
    if (!state.isActive) return;
    final additionalSeconds = minutes * 60;
    state = state.copyWith(
      totalSeconds: state.totalSeconds + additionalSeconds,
      remainingSeconds: state.remainingSeconds + additionalSeconds,
    );
  }

  void _tick() {
    if (state.remainingSeconds <= 1) {
      _onComplete();
      return;
    }
    state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
  }

  void _onComplete() {
    _timer?.cancel();

    // Fade out and pause audio
    ref.read(audioServiceProvider).fadeOutAndPause(const Duration(seconds: 5));

    // Send notification
    ref.read(notificationServiceProvider).showSleepTimerComplete();

    state = const SleepTimerState();
  }
}

/// Preset sleep timer durations in minutes
class SleepTimerPresets {
  static const List<int> presets = [5, 10, 15, 30, 45, 60, 90, 120];

  static String formatPreset(int minutes) {
    if (minutes >= 60) {
      final hours = minutes ~/ 60;
      final mins = minutes % 60;
      if (mins == 0) {
        return '${hours}h';
      }
      return '${hours}h ${mins}m';
    }
    return '${minutes}m';
  }
}
