import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/database/app_database.dart';
import '../database_provider.dart';

part 'note_provider.g.dart';

/// Watch note content
@riverpod
Stream<Note?> noteStream(Ref ref) {
  final dao = ref.watch(noteDaoProvider);
  return dao.watchNote();
}

/// Note actions
@riverpod
class NoteActions extends _$NoteActions {
  @override
  void build() {}

  /// Save note content
  Future<void> saveNote(String content) async {
    final dao = ref.read(noteDaoProvider);
    await dao.saveNote(content);
  }

  /// Clear note
  Future<void> clearNote() async {
    final dao = ref.read(noteDaoProvider);
    await dao.clearNote();
  }
}
