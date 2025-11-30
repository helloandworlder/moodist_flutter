import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/database/app_database.dart';
import '../../data/database/daos/sound_dao.dart';
import '../../data/database/daos/preset_dao.dart';
import '../../data/database/daos/todo_dao.dart';
import '../../data/database/daos/note_dao.dart';

part 'database_provider.g.dart';

/// Database singleton
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) => AppDatabase();

/// DAOs
@riverpod
SoundDao soundDao(Ref ref) => SoundDao(ref.watch(appDatabaseProvider));

@riverpod
PresetDao presetDao(Ref ref) => PresetDao(ref.watch(appDatabaseProvider));

@riverpod
TodoDao todoDao(Ref ref) => TodoDao(ref.watch(appDatabaseProvider));

@riverpod
NoteDao noteDao(Ref ref) => NoteDao(ref.watch(appDatabaseProvider));
