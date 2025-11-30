// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playback_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$playbackStateHash() => r'8fb898930919e37daf4967a9947c741cb0e90a7f';

/// Playback state
///
/// Copied from [PlaybackState].
@ProviderFor(PlaybackState)
final playbackStateProvider =
    AutoDisposeNotifierProvider<PlaybackState, bool>.internal(
      PlaybackState.new,
      name: r'playbackStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$playbackStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PlaybackState = AutoDisposeNotifier<bool>;
String _$globalVolumeHash() => r'c66ce29a8c2e757159ccd433b2e1572b2a416ce1';

/// Global volume
///
/// Copied from [GlobalVolume].
@ProviderFor(GlobalVolume)
final globalVolumeProvider =
    AutoDisposeNotifierProvider<GlobalVolume, double>.internal(
      GlobalVolume.new,
      name: r'globalVolumeProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$globalVolumeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GlobalVolume = AutoDisposeNotifier<double>;
String _$isLockedHash() => r'bad058304e20aed5a8551244e4a11cd414d43a69';

/// Lock state (used during fade out animation)
///
/// Copied from [IsLocked].
@ProviderFor(IsLocked)
final isLockedProvider = AutoDisposeNotifierProvider<IsLocked, bool>.internal(
  IsLocked.new,
  name: r'isLockedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isLockedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsLocked = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
