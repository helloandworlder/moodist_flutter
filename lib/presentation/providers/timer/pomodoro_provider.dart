import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../services/notification_service.dart';

part 'pomodoro_provider.g.dart';

enum PomodoroPhase { focus, shortBreak, longBreak }

class PomodoroState {
  final PomodoroPhase phase;
  final int remainingSeconds;
  final bool isRunning;
  final int focusCount;
  final int breakCount;
  final int focusDuration;
  final int shortBreakDuration;
  final int longBreakDuration;

  const PomodoroState({
    this.phase = PomodoroPhase.focus,
    this.remainingSeconds = 25 * 60,
    this.isRunning = false,
    this.focusCount = 0,
    this.breakCount = 0,
    this.focusDuration = 25 * 60,
    this.shortBreakDuration = 5 * 60,
    this.longBreakDuration = 15 * 60,
  });

  PomodoroState copyWith({
    PomodoroPhase? phase,
    int? remainingSeconds,
    bool? isRunning,
    int? focusCount,
    int? breakCount,
    int? focusDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
  }) {
    return PomodoroState(
      phase: phase ?? this.phase,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      focusCount: focusCount ?? this.focusCount,
      breakCount: breakCount ?? this.breakCount,
      focusDuration: focusDuration ?? this.focusDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
    );
  }

  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress {
    final total = _getDurationForPhase(phase);
    if (total == 0) return 0;
    return 1 - (remainingSeconds / total);
  }

  int _getDurationForPhase(PomodoroPhase p) {
    switch (p) {
      case PomodoroPhase.focus:
        return focusDuration;
      case PomodoroPhase.shortBreak:
        return shortBreakDuration;
      case PomodoroPhase.longBreak:
        return longBreakDuration;
    }
  }

  String get phaseLabel {
    switch (phase) {
      case PomodoroPhase.focus:
        return 'Focus';
      case PomodoroPhase.shortBreak:
        return 'Short Break';
      case PomodoroPhase.longBreak:
        return 'Long Break';
    }
  }
}

@Riverpod(keepAlive: true)
class Pomodoro extends _$Pomodoro {
  Timer? _timer;

  @override
  PomodoroState build() => const PomodoroState();

  void start() {
    if (state.isRunning) return;
    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void pause() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void reset() {
    _timer?.cancel();
    state = state.copyWith(
      isRunning: false,
      remainingSeconds: _getDuration(state.phase),
    );
  }

  void setPhase(PomodoroPhase phase) {
    _timer?.cancel();
    state = state.copyWith(
      phase: phase,
      isRunning: false,
      remainingSeconds: _getDuration(phase),
    );
  }

  void skipToNext() {
    _timer?.cancel();
    final nextPhase = _getNextPhase();
    state = state.copyWith(
      phase: nextPhase,
      isRunning: false,
      remainingSeconds: _getDuration(nextPhase),
    );
  }

  void updateSettings({int? focus, int? shortBreak, int? longBreak}) {
    final newFocus = focus ?? state.focusDuration;
    final newShort = shortBreak ?? state.shortBreakDuration;
    final newLong = longBreak ?? state.longBreakDuration;

    state = state.copyWith(
      focusDuration: newFocus,
      shortBreakDuration: newShort,
      longBreakDuration: newLong,
      remainingSeconds: state.phase == PomodoroPhase.focus
          ? newFocus
          : state.phase == PomodoroPhase.shortBreak
              ? newShort
              : newLong,
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

    final wasFocusPhase = state.phase == PomodoroPhase.focus;

    // Update counts
    if (wasFocusPhase) {
      state = state.copyWith(focusCount: state.focusCount + 1);
    } else {
      state = state.copyWith(breakCount: state.breakCount + 1);
    }

    // Send notification
    ref.read(notificationServiceProvider).showPomodoroComplete(
          isFocusPhase: wasFocusPhase,
        );

    // Move to next phase
    final nextPhase = _getNextPhase();
    state = state.copyWith(
      phase: nextPhase,
      isRunning: false,
      remainingSeconds: _getDuration(nextPhase),
    );
  }

  PomodoroPhase _getNextPhase() {
    if (state.phase == PomodoroPhase.focus) {
      // After every 4 focus sessions, take a long break
      if ((state.focusCount + 1) % 4 == 0) {
        return PomodoroPhase.longBreak;
      }
      return PomodoroPhase.shortBreak;
    }
    return PomodoroPhase.focus;
  }

  int _getDuration(PomodoroPhase phase) {
    switch (phase) {
      case PomodoroPhase.focus:
        return state.focusDuration;
      case PomodoroPhase.shortBreak:
        return state.shortBreakDuration;
      case PomodoroPhase.longBreak:
        return state.longBreakDuration;
    }
  }
}
