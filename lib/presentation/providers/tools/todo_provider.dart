import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../data/database/app_database.dart';
import '../database_provider.dart';

part 'todo_provider.g.dart';

/// Watch all todos
@riverpod
Stream<List<Todo>> todosStream(Ref ref) {
  final dao = ref.watch(todoDaoProvider);
  return dao.watchAllTodos();
}

/// Todo actions
@riverpod
class TodoActions extends _$TodoActions {
  @override
  void build() {}

  /// Add new todo
  Future<void> addTodo(String content) async {
    if (content.trim().isEmpty) return;
    final dao = ref.read(todoDaoProvider);
    await dao.addTodo(TodosCompanion(
      id: Value(const Uuid().v4()),
      content: Value(content.trim()),
      isDone: const Value(false),
      createdAt: Value(DateTime.now()),
    ));
  }

  /// Toggle todo completion
  Future<void> toggleTodo(String id) async {
    final dao = ref.read(todoDaoProvider);
    await dao.toggleTodo(id);
  }

  /// Update todo content
  Future<void> updateContent(String id, String content) async {
    if (content.trim().isEmpty) return;
    final dao = ref.read(todoDaoProvider);
    await dao.updateContent(id, content.trim());
  }

  /// Delete todo
  Future<void> deleteTodo(String id) async {
    final dao = ref.read(todoDaoProvider);
    await dao.deleteTodo(id);
  }

  /// Clear all completed todos
  Future<void> clearCompleted() async {
    final dao = ref.read(todoDaoProvider);
    final todos = await dao.getAllTodos();
    for (final todo in todos.where((t) => t.isDone)) {
      await dao.deleteTodo(todo.id);
    }
  }
}
