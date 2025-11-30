import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'breathing_provider.g.dart';

enum BreathingExercise {
  boxBreathing,
  resonantBreathing,
  breathing478,
}

enum BreathingPhase {
  inhale,
  holdInhale,
  exhale,
  holdExhale,
}

extension BreathingExerciseExtension on BreathingExercise {
  String get displayName {
    switch (this) {
      case BreathingExercise.boxBreathing:
        return 'Box Breathing';
      case BreathingExercise.resonantBreathing:
        return 'Resonant Breathing';
      case BreathingExercise.breathing478:
        return '4-7-8 Breathing';
    }
  }

  String get description {
    switch (this) {
      case BreathingExercise.boxBreathing:
        return 'Equal parts inhale, hold, exhale, hold. Great for stress relief.';
      case BreathingExercise.resonantBreathing:
        return 'Simple inhale-exhale at 5 seconds each. Promotes relaxation.';
      case BreathingExercise.breathing478:
        return 'Inhale 4s, hold 7s, exhale 8s. Helps with sleep and anxiety.';
    }
  }

  List<BreathingPhase> get phases {
    switch (this) {
      case BreathingExercise.boxBreathing:
        return [
          BreathingPhase.inhale,
          BreathingPhase.holdInhale,
          BreathingPhase.exhale,
          BreathingPhase.holdExhale,
        ];
      case BreathingExercise.resonantBreathing:
        return [BreathingPhase.inhale, BreathingPhase.exhale];
      case BreathingExercise.breathing478:
        return [
          BreathingPhase.inhale,
          BreathingPhase.holdInhale,
          BreathingPhase.exhale,
        ];
    }
  }

  Map<BreathingPhase, int> get durations {
    switch (this) {
      case BreathingExercise.boxBreathing:
        return {
          BreathingPhase.inhale: 4,
          BreathingPhase.holdInhale: 4,
          BreathingPhase.exhale: 4,
          BreathingPhase.holdExhale: 4,
        };
      case BreathingExercise.resonantBreathing:
        return {
          BreathingPhase.inhale: 5,
          BreathingPhase.exhale: 5,
        };
      case BreathingExercise.breathing478:
        return {
          BreathingPhase.inhale: 4,
          BreathingPhase.holdInhale: 7,
          BreathingPhase.exhale: 8,
        };
    }
  }
}

extension BreathingPhaseExtension on BreathingPhase {
  String get displayName {
    switch (this) {
      case BreathingPhase.inhale:
        return 'Inhale';
      case BreathingPhase.holdInhale:
        return 'Hold';
      case BreathingPhase.exhale:
        return 'Exhale';
      case BreathingPhase.holdExhale:
        return 'Hold';
    }
  }
}

class BreathingState {
  final BreathingExercise exercise;
  final int phaseIndex;
  final int elapsedSeconds;
  final int phaseElapsed;
  final bool isRunning;

  const BreathingState({
    this.exercise = BreathingExercise.breathing478,
    this.phaseIndex = 0,
    this.elapsedSeconds = 0,
    this.phaseElapsed = 0,
    this.isRunning = false,
  });

  BreathingPhase get currentPhase => exercise.phases[phaseIndex];
  int get phaseDuration => exercise.durations[currentPhase] ?? 4;
  double get phaseProgress => phaseElapsed / phaseDuration;

  double get circleScale {
    switch (currentPhase) {
      case BreathingPhase.inhale:
        return 1.0 + (0.5 * phaseProgress);
      case BreathingPhase.holdInhale:
        return 1.5;
      case BreathingPhase.exhale:
        return 1.5 - (0.5 * phaseProgress);
      case BreathingPhase.holdExhale:
        return 1.0;
    }
  }

  String get formattedTime {
    final minutes = elapsedSeconds ~/ 60;
    final seconds = elapsedSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  BreathingState copyWith({
    BreathingExercise? exercise,
    int? phaseIndex,
    int? elapsedSeconds,
    int? phaseElapsed,
    bool? isRunning,
  }) {
    return BreathingState(
      exercise: exercise ?? this.exercise,
      phaseIndex: phaseIndex ?? this.phaseIndex,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      phaseElapsed: phaseElapsed ?? this.phaseElapsed,
      isRunning: isRunning ?? this.isRunning,
    );
  }
}

@riverpod
class Breathing extends _$Breathing {
  Timer? _timer;

  @override
  BreathingState build() => const BreathingState();

  void setExercise(BreathingExercise exercise) {
    _timer?.cancel();
    state = BreathingState(exercise: exercise);
  }

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
    state = BreathingState(exercise: state.exercise);
  }

  void toggle() {
    if (state.isRunning) {
      pause();
    } else {
      start();
    }
  }

  void _tick() {
    final newPhaseElapsed = state.phaseElapsed + 1;
    
    if (newPhaseElapsed >= state.phaseDuration) {
      final newPhaseIndex = (state.phaseIndex + 1) % state.exercise.phases.length;
      state = state.copyWith(
        phaseIndex: newPhaseIndex,
        phaseElapsed: 0,
        elapsedSeconds: state.elapsedSeconds + 1,
      );
    } else {
      state = state.copyWith(
        phaseElapsed: newPhaseElapsed,
        elapsedSeconds: state.elapsedSeconds + 1,
      );
    }
  }
}
