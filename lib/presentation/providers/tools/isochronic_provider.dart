import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../services/tone_generator_service.dart';

part 'isochronic_provider.g.dart';

class IsochronicState {
  final bool isPlaying;
  final int presetIndex;
  final bool isCustom;
  final double baseFrequency;
  final double beatFrequency;
  final double volume;

  const IsochronicState({
    this.isPlaying = false,
    this.presetIndex = 2, // Alpha (Relaxation) by default
    this.isCustom = false,
    this.baseFrequency = 200,
    this.beatFrequency = 10,
    this.volume = 0.5,
  });

  TonePreset? get currentPreset {
    if (isCustom) return null;
    return ToneGeneratorService.isochronicPresets[presetIndex];
  }

  double get effectiveBaseFrequency =>
      isCustom ? baseFrequency : currentPreset!.baseFrequency;

  double get effectiveBeatFrequency =>
      isCustom ? beatFrequency : currentPreset!.beatFrequency;

  IsochronicState copyWith({
    bool? isPlaying,
    int? presetIndex,
    bool? isCustom,
    double? baseFrequency,
    double? beatFrequency,
    double? volume,
  }) {
    return IsochronicState(
      isPlaying: isPlaying ?? this.isPlaying,
      presetIndex: presetIndex ?? this.presetIndex,
      isCustom: isCustom ?? this.isCustom,
      baseFrequency: baseFrequency ?? this.baseFrequency,
      beatFrequency: beatFrequency ?? this.beatFrequency,
      volume: volume ?? this.volume,
    );
  }
}

@riverpod
class Isochronic extends _$Isochronic {
  @override
  IsochronicState build() => const IsochronicState();

  ToneGeneratorService get _service =>
      ref.read(toneGeneratorServiceProvider);

  void setPreset(int index) {
    state = state.copyWith(
      presetIndex: index,
      isCustom: false,
    );
    if (state.isPlaying) {
      _restart();
    }
  }

  void setCustomMode(bool isCustom) {
    state = state.copyWith(isCustom: isCustom);
    if (state.isPlaying) {
      _restart();
    }
  }

  void setBaseFrequency(double frequency) {
    state = state.copyWith(
      baseFrequency: frequency.clamp(20, 2000),
      isCustom: true,
    );
  }

  void setBeatFrequency(double frequency) {
    state = state.copyWith(
      beatFrequency: frequency.clamp(0.5, 40),
      isCustom: true,
    );
  }

  void setVolume(double volume) {
    state = state.copyWith(volume: volume.clamp(0.0, 1.0));
    _service.setVolume(state.volume);
  }

  Future<void> start() async {
    if (state.isPlaying) return;

    state = state.copyWith(isPlaying: true);
    await _service.playIsochronicTone(
      baseFrequency: state.effectiveBaseFrequency,
      beatFrequency: state.effectiveBeatFrequency,
      volume: state.volume,
    );
  }

  Future<void> stop() async {
    if (!state.isPlaying) return;

    await _service.stop();
    state = state.copyWith(isPlaying: false);
  }

  Future<void> toggle() async {
    if (state.isPlaying) {
      await stop();
    } else {
      await start();
    }
  }

  Future<void> _restart() async {
    if (state.isPlaying) {
      await _service.playIsochronicTone(
        baseFrequency: state.effectiveBaseFrequency,
        beatFrequency: state.effectiveBeatFrequency,
        volume: state.volume,
      );
    }
  }
}
