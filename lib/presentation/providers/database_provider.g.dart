// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'98a09c6cfd43966155dfbdb0787fa18c85438e13';

/// Database singleton
///
/// Copied from [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
String _$soundDaoHash() => r'9ab7dd830ced16f8a0c4c7c3b2e172a700d64b23';

/// DAOs
///
/// Copied from [soundDao].
@ProviderFor(soundDao)
final soundDaoProvider = AutoDisposeProvider<SoundDao>.internal(
  soundDao,
  name: r'soundDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$soundDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SoundDaoRef = AutoDisposeProviderRef<SoundDao>;
String _$presetDaoHash() => r'a09b30797d4c7a94947e457af42715b8720a183c';

/// See also [presetDao].
@ProviderFor(presetDao)
final presetDaoProvider = AutoDisposeProvider<PresetDao>.internal(
  presetDao,
  name: r'presetDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$presetDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PresetDaoRef = AutoDisposeProviderRef<PresetDao>;
String _$todoDaoHash() => r'873f8c5d7a19ebf7b4647d3e0025a953d2e78ef6';

/// See also [todoDao].
@ProviderFor(todoDao)
final todoDaoProvider = AutoDisposeProvider<TodoDao>.internal(
  todoDao,
  name: r'todoDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todoDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodoDaoRef = AutoDisposeProviderRef<TodoDao>;
String _$noteDaoHash() => r'17dede8aa018df6297b1266d7c9cd16703fe25de';

/// See also [noteDao].
@ProviderFor(noteDao)
final noteDaoProvider = AutoDisposeProvider<NoteDao>.internal(
  noteDao,
  name: r'noteDaoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$noteDaoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NoteDaoRef = AutoDisposeProviderRef<NoteDao>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
