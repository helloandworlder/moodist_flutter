import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ========== Tables ==========

/// Sound states table - stores selection, volume, favorite status for each sound
class SoundStates extends Table {
  TextColumn get soundId => text()();
  BoolColumn get isSelected => boolean().withDefault(const Constant(false))();
  RealColumn get volume => real().withDefault(const Constant(0.5))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {soundId};
}

/// Presets table - stores user-saved sound combinations
class Presets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get soundsJson => text()(); // JSON format: {"soundId": volume}
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Todos table - todo items
class Todos extends Table {
  TextColumn get id => text()();
  TextColumn get content => text().withLength(min: 1, max: 500)();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Notes table - single note content
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get content => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Pomodoro settings table
class PomodoroSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get focusDuration =>
      integer().withDefault(const Constant(25 * 60))();
  IntColumn get shortBreakDuration =>
      integer().withDefault(const Constant(5 * 60))();
  IntColumn get longBreakDuration =>
      integer().withDefault(const Constant(15 * 60))();
}

/// App settings table
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get globalVolume => real().withDefault(const Constant(1.0))();
  BoolColumn get darkMode => boolean().nullable()(); // null = follow system
}

// ========== Database ==========

@DriftDatabase(tables: [
  SoundStates,
  Presets,
  Todos,
  Notes,
  PomodoroSettings,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // For testing
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          // Initialize default settings
          await into(appSettings).insert(AppSettingsCompanion.insert());
          await into(pomodoroSettings)
              .insert(PomodoroSettingsCompanion.insert());
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Future version migration logic
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'moodist.db'));
    return NativeDatabase.createInBackground(file);
  });
}
