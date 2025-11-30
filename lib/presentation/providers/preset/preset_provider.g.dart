// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preset_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$presetsStreamHash() => r'0fa6d2bc4d6767f0b740f81b108218c22fc1951a';

/// Watch all presets
///
/// Copied from [presetsStream].
@ProviderFor(presetsStream)
final presetsStreamProvider = AutoDisposeStreamProvider<List<Preset>>.internal(
  presetsStream,
  name: r'presetsStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$presetsStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PresetsStreamRef = AutoDisposeStreamProviderRef<List<Preset>>;
String _$presetActionsHash() => r'f64289777cadfb3efbfa6c304658e14620bcf2cd';

/// Preset actions
///
/// Copied from [PresetActions].
@ProviderFor(PresetActions)
final presetActionsProvider =
    AutoDisposeNotifierProvider<PresetActions, void>.internal(
      PresetActions.new,
      name: r'presetActionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$presetActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PresetActions = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
