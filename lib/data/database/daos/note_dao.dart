import 'package:drift/drift.dart';
import '../app_database.dart';

part 'note_dao.g.dart';

@DriftAccessor(tables: [Notes])
class NoteDao extends DatabaseAccessor<AppDatabase> with _$NoteDaoMixin {
  NoteDao(super.db);

  /// Get note (only one)
  Future<Note?> getNote() => (select(notes)..limit(1)).getSingleOrNull();

  /// Watch note
  Stream<Note?> watchNote() => (select(notes)..limit(1)).watchSingleOrNull();

  /// Save note
  Future<void> saveNote(String content) async {
    final existing = await getNote();
    if (existing != null) {
      await (update(notes)..where((t) => t.id.equals(existing.id))).write(
        NotesCompanion(
          content: Value(content),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      await into(notes).insert(NotesCompanion.insert(content: Value(content)));
    }
  }

  /// Clear note
  Future<void> clearNote() async {
    final existing = await getNote();
    if (existing != null) {
      await (update(notes)..where((t) => t.id.equals(existing.id)))
          .write(const NotesCompanion(content: Value('')));
    }
  }
}
