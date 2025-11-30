import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playback_provider.g.dart';

/// Playback state
@riverpod
class PlaybackState extends _$PlaybackState {
  @override
  bool build() => false;

  void play() => state = true;
  void pause() => state = false;
  void toggle() => state = !state;
}

/// Global volume
@riverpod
class GlobalVolume extends _$GlobalVolume {
  @override
  double build() => 1.0;

  void setVolume(double volume) => state = volume.clamp(0.0, 1.0);
}

/// Lock state (used during fade out animation)
@riverpod
class IsLocked extends _$IsLocked {
  @override
  bool build() => false;

  void lock() => state = true;
  void unlock() => state = false;
}
