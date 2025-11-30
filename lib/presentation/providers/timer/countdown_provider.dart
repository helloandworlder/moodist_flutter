import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../services/notification_service.dart';

part 'countdown_provider.g.dart';

class CountdownState {
  final int totalSeconds;
  final int remainingSeconds;
  final bool isRunning;
  final bool isComplete;

  const CountdownState({
    this.totalSeconds = 0,
    this.remainingSeconds = 0,
    this.isRunning = false,
    this.isComplete = false,
  });

  CountdownState copyWith({
    int? totalSeconds,
    int? remainingSeconds,
    bool? isRunning,
    bool? isComplete,
  }) {
    return CountdownState(
      totalSeconds: totalSeconds ?? this.totalSeconds,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  String get formattedTime {
    final hours = remainingSeconds ~/ 3600;
    final minutes = (remainingSeconds % 3600) ~/ 60;
    final seconds = remainingSeconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress {
    if (totalSeconds == 0) return 0;
    return 1 - (remainingSeconds / totalSeconds);
  }

  bool get hasTime => totalSeconds > 0;
}

@Riverpod(keepAlive: true)
class Countdown extends _$Countdown {
  Timer? _timer;

  @override
  CountdownState build() => const CountdownState();

  void setTime({int hours = 0, int minutes = 0, int seconds = 0}) {
    final total = hours * 3600 + minutes * 60 + seconds;
    state = CountdownState(
      totalSeconds: total,
      remainingSeconds: total,
      isRunning: false,
      isComplete: false,
    );
  }

  void start() {
    if (state.isRunning || state.remainingSeconds <= 0) return;
    state = state.copyWith(isRunning: true, isComplete: false);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    state = state.copyWith(
      remainingSeconds: state.totalSeconds,
      isRunning: false,
      isComplete: false,
    );
  }

  void clear() {
    _timer?.cancel();
    state = const CountdownState();
  }

  void addTime(int seconds) {
    final newTotal = state.totalSeconds + seconds;
    final newRemaining = state.remainingSeconds + seconds;
    state = state.copyWith(
      totalSeconds: newTotal > 0 ? newTotal : 0,
      remainingSeconds: newRemaining > 0 ? newRemaining : 0,
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
    state = state.copyWith(
      remainingSeconds: 0,
      isRunning: false,
      isComplete: true,
    );

    // Send notification
    ref.read(notificationServiceProvider).showCountdownComplete();
  }
}
