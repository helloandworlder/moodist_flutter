import 'package:drift/drift.dart';
import '../app_database.dart';

part 'todo_dao.g.dart';

@DriftAccessor(tables: [Todos])
class TodoDao extends DatabaseAccessor<AppDatabase> with _$TodoDaoMixin {
  TodoDao(super.db);

  /// Get all todos
  Future<List<Todo>> getAllTodos() =>
      (select(todos)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();

  /// Watch all todos
  Stream<List<Todo>> watchAllTodos() =>
      (select(todos)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).watch();

  /// Add todo
  Future<void> addTodo(TodosCompanion todo) => into(todos).insert(todo);

  /// Toggle completion status
  Future<void> toggleTodo(String id) async {
    final todo =
        await (select(todos)..where((t) => t.id.equals(id))).getSingle();
    await (update(todos)..where((t) => t.id.equals(id)))
        .write(TodosCompanion(isDone: Value(!todo.isDone)));
  }

  /// Update content
  Future<void> updateContent(String id, String content) =>
      (update(todos)..where((t) => t.id.equals(id)))
          .write(TodosCompanion(content: Value(content)));

  /// Delete todo
  Future<void> deleteTodo(String id) =>
      (delete(todos)..where((t) => t.id.equals(id))).go();

  /// Get done count
  Future<int> getDoneCount() async {
    final count = countAll();
    final query = selectOnly(todos)
      ..where(todos.isDone.equals(true))
      ..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Watch done count
  Stream<int> watchDoneCount() {
    final count = countAll();
    final query = selectOnly(todos)
      ..where(todos.isDone.equals(true))
      ..addColumns([count]);
    return query.watchSingle().map((row) => row.read(count) ?? 0);
  }
}
