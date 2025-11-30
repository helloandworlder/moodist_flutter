// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$todosStreamHash() => r'd936a5e195a8fc3dfed9ea99dcf9232856f5dc0a';

/// Watch all todos
///
/// Copied from [todosStream].
@ProviderFor(todosStream)
final todosStreamProvider = AutoDisposeStreamProvider<List<Todo>>.internal(
  todosStream,
  name: r'todosStreamProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todosStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodosStreamRef = AutoDisposeStreamProviderRef<List<Todo>>;
String _$todoActionsHash() => r'199b5e5753c2366183c414e798264149fa4e18b8';

/// Todo actions
///
/// Copied from [TodoActions].
@ProviderFor(TodoActions)
final todoActionsProvider =
    AutoDisposeNotifierProvider<TodoActions, void>.internal(
      TodoActions.new,
      name: r'todoActionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todoActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TodoActions = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
