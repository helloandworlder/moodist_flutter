import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tone_generator_service.g.dart';

class TonePreset {
  final String name;
  final double baseFrequency;
  final double beatFrequency;
  final String description;

  const TonePreset({
    required this.name,
    required this.baseFrequency,
    required this.beatFrequency,
    required this.description,
  });
}

class ToneGeneratorService {
  AudioPlayer? _player;

  static const List<TonePreset> binauralPresets = [
    TonePreset(
      name: 'Delta (Deep Sleep)',
      baseFrequency: 100,
      beatFrequency: 2,
      description: '0.5-4 Hz - Deep sleep, healing, regeneration',
    ),
    TonePreset(
      name: 'Theta (Meditation)',
      baseFrequency: 100,
      beatFrequency: 5,
      description: '4-8 Hz - Deep relaxation, meditation, creativity',
    ),
    TonePreset(
      name: 'Alpha (Relaxation)',
      baseFrequency: 100,
      beatFrequency: 10,
      description: '8-14 Hz - Relaxed alertness, stress relief',
    ),
    TonePreset(
      name: 'Beta (Focus)',
      baseFrequency: 100,
      beatFrequency: 20,
      description: '14-30 Hz - Active thinking, focus, concentration',
    ),
    TonePreset(
      name: 'Gamma (Cognition)',
      baseFrequency: 100,
      beatFrequency: 40,
      description: '30+ Hz - Higher mental activity, problem solving',
    ),
  ];

  static const List<TonePreset> isochronicPresets = [
    TonePreset(
      name: 'Delta (Deep Sleep)',
      baseFrequency: 100,
      beatFrequency: 2,
      description: '2 Hz - Deep sleep, healing',
    ),
    TonePreset(
      name: 'Theta (Meditation)',
      baseFrequency: 100,
      beatFrequency: 5,
      description: '5 Hz - Deep relaxation, meditation',
    ),
    TonePreset(
      name: 'Alpha (Relaxation)',
      baseFrequency: 200,
      beatFrequency: 10,
      description: '10 Hz - Relaxed alertness',
    ),
    TonePreset(
      name: 'Beta (Focus)',
      baseFrequency: 200,
      beatFrequency: 20,
      description: '20 Hz - Focus, concentration',
    ),
    TonePreset(
      name: 'Gamma (Cognition)',
      baseFrequency: 300,
      beatFrequency: 40,
      description: '40 Hz - Higher mental activity',
    ),
  ];

  Future<void> playBinauralBeat({
    required double baseFrequency,
    required double beatFrequency,
    required double volume,
  }) async {
    await stop();

    _player = AudioPlayer();

    final leftFreq = baseFrequency - beatFrequency / 2;
    final rightFreq = baseFrequency + beatFrequency / 2;

    final audioBytes = await compute(
      _generateBinauralAudioIsolate,
      _BinauralParams(leftFreq, rightFreq, 30),
    );

    final audioSource = _WavAudioSource(audioBytes);
    await _player!.setAudioSource(audioSource);
    await _player!.setLoopMode(LoopMode.all);
    await _player!.setVolume(volume);
    await _player!.play();
  }

  Future<void> playIsochronicTone({
    required double baseFrequency,
    required double beatFrequency,
    required double volume,
  }) async {
    await stop();

    _player = AudioPlayer();

    final audioBytes = await compute(
      _generateIsochronicAudioIsolate,
      _IsochronicParams(baseFrequency, beatFrequency, 30),
    );

    final audioSource = _WavAudioSource(audioBytes);
    await _player!.setAudioSource(audioSource);
    await _player!.setLoopMode(LoopMode.all);
    await _player!.setVolume(volume);
    await _player!.play();
  }

  Future<void> setVolume(double volume) async {
    await _player?.setVolume(volume.clamp(0.0, 1.0));
  }

  Future<void> stop() async {
    await _player?.stop();
    await _player?.dispose();
    _player = null;
  }

  bool get isPlaying => _player?.playing ?? false;

  void dispose() {
    stop();
  }
}

class _BinauralParams {
  final double leftFreq;
  final double rightFreq;
  final int durationSeconds;

  _BinauralParams(this.leftFreq, this.rightFreq, this.durationSeconds);
}

class _IsochronicParams {
  final double baseFrequency;
  final double beatFrequency;
  final int durationSeconds;

  _IsochronicParams(this.baseFrequency, this.beatFrequency, this.durationSeconds);
}

Uint8List _generateBinauralAudioIsolate(_BinauralParams params) {
  return _generateBinauralAudio(
    params.leftFreq,
    params.rightFreq,
    params.durationSeconds,
  );
}

Uint8List _generateIsochronicAudioIsolate(_IsochronicParams params) {
  return _generateIsochronicAudio(
    params.baseFrequency,
    params.beatFrequency,
    params.durationSeconds,
  );
}

Uint8List _generateBinauralAudio(
    double leftFreq, double rightFreq, int durationSeconds) {
  const sampleRate = 44100;
  final numSamples = sampleRate * durationSeconds;
  const byteRate = sampleRate * 2 * 2;
  final dataSize = numSamples * 2 * 2;
  final fileSize = 36 + dataSize;

  final buffer = ByteData(44 + dataSize);
  var offset = 0;

  // RIFF header
  buffer.setUint8(offset++, 0x52); // R
  buffer.setUint8(offset++, 0x49); // I
  buffer.setUint8(offset++, 0x46); // F
  buffer.setUint8(offset++, 0x46); // F
  buffer.setUint32(offset, fileSize, Endian.little);
  offset += 4;
  buffer.setUint8(offset++, 0x57); // W
  buffer.setUint8(offset++, 0x41); // A
  buffer.setUint8(offset++, 0x56); // V
  buffer.setUint8(offset++, 0x45); // E

  // fmt chunk
  buffer.setUint8(offset++, 0x66); // f
  buffer.setUint8(offset++, 0x6D); // m
  buffer.setUint8(offset++, 0x74); // t
  buffer.setUint8(offset++, 0x20); // (space)
  buffer.setUint32(offset, 16, Endian.little);
  offset += 4;
  buffer.setUint16(offset, 1, Endian.little);
  offset += 2;
  buffer.setUint16(offset, 2, Endian.little);
  offset += 2;
  buffer.setUint32(offset, sampleRate, Endian.little);
  offset += 4;
  buffer.setUint32(offset, byteRate, Endian.little);
  offset += 4;
  buffer.setUint16(offset, 4, Endian.little);
  offset += 2;
  buffer.setUint16(offset, 16, Endian.little);
  offset += 2;

  // data chunk
  buffer.setUint8(offset++, 0x64); // d
  buffer.setUint8(offset++, 0x61); // a
  buffer.setUint8(offset++, 0x74); // t
  buffer.setUint8(offset++, 0x61); // a
  buffer.setUint32(offset, dataSize, Endian.little);
  offset += 4;

  // Audio data
  for (int i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    final leftSample = (math.sin(2 * math.pi * leftFreq * t) * 16383).toInt();
    final rightSample = (math.sin(2 * math.pi * rightFreq * t) * 16383).toInt();

    buffer.setInt16(offset, leftSample, Endian.little);
    offset += 2;
    buffer.setInt16(offset, rightSample, Endian.little);
    offset += 2;
  }

  return buffer.buffer.asUint8List();
}

Uint8List _generateIsochronicAudio(
    double baseFrequency, double beatFrequency, int durationSeconds) {
  const sampleRate = 44100;
  final numSamples = sampleRate * durationSeconds;
  const byteRate = sampleRate * 2 * 2;
  final dataSize = numSamples * 2 * 2;
  final fileSize = 36 + dataSize;

  final buffer = ByteData(44 + dataSize);
  var offset = 0;

  // RIFF header
  buffer.setUint8(offset++, 0x52); // R
  buffer.setUint8(offset++, 0x49); // I
  buffer.setUint8(offset++, 0x46); // F
  buffer.setUint8(offset++, 0x46); // F
  buffer.setUint32(offset, fileSize, Endian.little);
  offset += 4;
  buffer.setUint8(offset++, 0x57); // W
  buffer.setUint8(offset++, 0x41); // A
  buffer.setUint8(offset++, 0x56); // V
  buffer.setUint8(offset++, 0x45); // E

  // fmt chunk
  buffer.setUint8(offset++, 0x66); // f
  buffer.setUint8(offset++, 0x6D); // m
  buffer.setUint8(offset++, 0x74); // t
  buffer.setUint8(offset++, 0x20); // (space)
  buffer.setUint32(offset, 16, Endian.little);
  offset += 4;
  buffer.setUint16(offset, 1, Endian.little);
  offset += 2;
  buffer.setUint16(offset, 2, Endian.little);
  offset += 2;
  buffer.setUint32(offset, sampleRate, Endian.little);
  offset += 4;
  buffer.setUint32(offset, byteRate, Endian.little);
  offset += 4;
  buffer.setUint16(offset, 4, Endian.little);
  offset += 2;
  buffer.setUint16(offset, 16, Endian.little);
  offset += 2;

  // data chunk
  buffer.setUint8(offset++, 0x64); // d
  buffer.setUint8(offset++, 0x61); // a
  buffer.setUint8(offset++, 0x74); // t
  buffer.setUint8(offset++, 0x61); // a
  buffer.setUint32(offset, dataSize, Endian.little);
  offset += 4;

  // Audio data - isochronic tones use amplitude modulation with square wave
  final beatPeriod = sampleRate / beatFrequency;

  for (int i = 0; i < numSamples; i++) {
    final t = i / sampleRate;
    final baseSample = math.sin(2 * math.pi * baseFrequency * t);

    // Square wave modulation for isochronic effect
    final modulationPhase = (i % beatPeriod) / beatPeriod;
    final modulation = modulationPhase < 0.5 ? 1.0 : 0.0;

    final sample = (baseSample * modulation * 16383).toInt();

    // Same sample for both channels (mono effect through stereo)
    buffer.setInt16(offset, sample, Endian.little);
    offset += 2;
    buffer.setInt16(offset, sample, Endian.little);
    offset += 2;
  }

  return buffer.buffer.asUint8List();
}

class _WavAudioSource extends StreamAudioSource {
  final Uint8List _audioBytes;

  _WavAudioSource(this._audioBytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= _audioBytes.length;
    return StreamAudioResponse(
      sourceLength: _audioBytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(_audioBytes.sublist(start, end)),
      contentType: 'audio/wav',
    );
  }
}

@Riverpod(keepAlive: true)
ToneGeneratorService toneGeneratorService(Ref ref) {
  final service = ToneGeneratorService();
  ref.onDispose(() => service.dispose());
  return service;
}
