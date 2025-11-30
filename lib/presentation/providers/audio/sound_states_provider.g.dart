// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_states_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$soundStatesStreamHash() => r'7c528c0e4b20e66374b235c1409b955054e1e16c';

/// All sound states (reactive Stream)
///
/// Copied from [soundStatesStream].
@ProviderFor(soundStatesStream)
final soundStatesStreamProvider =
    AutoDisposeStreamProvider<List<SoundState>>.internal(
      soundStatesStream,
      name: r'soundStatesStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$soundStatesStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SoundStatesStreamRef = AutoDisposeStreamProviderRef<List<SoundState>>;
String _$selectedSoundsStreamHash() =>
    r'403c451a63da72e686f9f53dd67a82f0fa528dc6';

/// Selected sounds
///
/// Copied from [selectedSoundsStream].
@ProviderFor(selectedSoundsStream)
final selectedSoundsStreamProvider =
    AutoDisposeStreamProvider<List<SoundState>>.internal(
      selectedSoundsStream,
      name: r'selectedSoundsStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedSoundsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedSoundsStreamRef =
    AutoDisposeStreamProviderRef<List<SoundState>>;
String _$favoriteSoundsStreamHash() =>
    r'72c4f7073decb1ea5a6d9ba3ae4e158d8c97d301';

/// Favorite sounds
///
/// Copied from [favoriteSoundsStream].
@ProviderFor(favoriteSoundsStream)
final favoriteSoundsStreamProvider =
    AutoDisposeStreamProvider<List<SoundState>>.internal(
      favoriteSoundsStream,
      name: r'favoriteSoundsStreamProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$favoriteSoundsStreamHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FavoriteSoundsStreamRef =
    AutoDisposeStreamProviderRef<List<SoundState>>;
String _$hasSelectionHash() => r'b09fa29e8a4f6f44baf989f878879c617250725f';

/// Whether there are selected sounds
///
/// Copied from [hasSelection].
@ProviderFor(hasSelection)
final hasSelectionProvider = AutoDisposeProvider<bool>.internal(
  hasSelection,
  name: r'hasSelectionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasSelectionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasSelectionRef = AutoDisposeProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
