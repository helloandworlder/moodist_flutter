// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$noteStreamHash() => r'1a3b4e3ba11cb9a7f7fd9c5564fb1768de694b2d';

/// Watch note content
///
/// Copied from [noteStream].
@ProviderFor(noteStream)
final noteStreamProvider = AutoDisposeStreamProvider<Note?>.internal(
  noteStream,
  name: r'noteStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$noteStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef NoteStreamRef = AutoDisposeStreamProviderRef<Note?>;
String _$noteActionsHash() => r'47b09a3697600dd001b0acc408870fe27f58048d';

/// Note actions
///
/// Copied from [NoteActions].
@ProviderFor(NoteActions)
final noteActionsProvider =
    AutoDisposeNotifierProvider<NoteActions, void>.internal(
      NoteActions.new,
      name: r'noteActionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$noteActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$NoteActions = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
