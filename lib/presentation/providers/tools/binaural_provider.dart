import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../services/tone_generator_service.dart';

part 'binaural_provider.g.dart';

class BinauralState {
  final bool isPlaying;
  final int presetIndex;
  final bool isCustom;
  final double baseFrequency;
  final double beatFrequency;
  final double volume;

  const BinauralState({
    this.isPlaying = false,
    this.presetIndex = 2, // Alpha (Relaxation) by default
    this.isCustom = false,
    this.baseFrequency = 100,
    this.beatFrequency = 10,
    this.volume = 0.5,
  });

  TonePreset? get currentPreset {
    if (isCustom) return null;
    return ToneGeneratorService.binauralPresets[presetIndex];
  }

  double get effectiveBaseFrequency =>
      isCustom ? baseFrequency : currentPreset!.baseFrequency;

  double get effectiveBeatFrequency =>
      isCustom ? beatFrequency : currentPreset!.beatFrequency;

  BinauralState copyWith({
    bool? isPlaying,
    int? presetIndex,
    bool? isCustom,
    double? baseFrequency,
    double? beatFrequency,
    double? volume,
  }) {
    return BinauralState(
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
class Binaural extends _$Binaural {
  @override
  BinauralState build() => const BinauralState();

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
      baseFrequency: frequency.clamp(20, 1500),
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
    await _service.playBinauralBeat(
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
      await _service.playBinauralBeat(
        baseFrequency: state.effectiveBaseFrequency,
        beatFrequency: state.effectiveBeatFrequency,
        volume: state.volume,
      );
    }
  }
}
