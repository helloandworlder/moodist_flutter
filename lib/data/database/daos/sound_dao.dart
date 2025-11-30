import 'package:drift/drift.dart';
import '../app_database.dart';

part 'sound_dao.g.dart';

@DriftAccessor(tables: [SoundStates])
class SoundDao extends DatabaseAccessor<AppDatabase> with _$SoundDaoMixin {
  SoundDao(super.db);

  /// Get all sound states
  Future<List<SoundState>> getAllSoundStates() => select(soundStates).get();

  /// Watch all sound states (reactive Stream)
  Stream<List<SoundState>> watchAllSoundStates() => select(soundStates).watch();

  /// Get single sound state
  Future<SoundState?> getSoundState(String soundId) =>
      (select(soundStates)..where((t) => t.soundId.equals(soundId)))
          .getSingleOrNull();

  /// Watch single sound state
  Stream<SoundState?> watchSoundState(String soundId) =>
      (select(soundStates)..where((t) => t.soundId.equals(soundId)))
          .watchSingleOrNull();

  /// Update or insert sound state (Upsert)
  Future<void> upsertSoundState(SoundStatesCompanion state) =>
      into(soundStates).insertOnConflictUpdate(state);

  /// Batch update all selected sounds
  Future<void> updateAllSelected(bool isSelected) =>
      (update(soundStates)..where((t) => t.isSelected.equals(true)))
          .write(SoundStatesCompanion(isSelected: Value(isSelected)));

  /// Reset all selections
  Future<void> resetAllSelections() => update(soundStates).write(
        const SoundStatesCompanion(
          isSelected: Value(false),
          volume: Value(0.5),
        ),
      );

  /// Get favorites list
  Future<List<SoundState>> getFavorites() =>
      (select(soundStates)..where((t) => t.isFavorite.equals(true))).get();

  /// Watch favorites list
  Stream<List<SoundState>> watchFavorites() =>
      (select(soundStates)..where((t) => t.isFavorite.equals(true))).watch();

  /// Get selected sounds
  Future<List<SoundState>> getSelectedSounds() =>
      (select(soundStates)..where((t) => t.isSelected.equals(true))).get();

  /// Watch selected sounds
  Stream<List<SoundState>> watchSelectedSounds() =>
      (select(soundStates)..where((t) => t.isSelected.equals(true))).watch();

  /// Initialize sound states (first launch)
  Future<void> initializeSoundStates(List<String> soundIds) async {
    await batch((batch) {
      for (final soundId in soundIds) {
        batch.insert(
          soundStates,
          SoundStatesCompanion.insert(soundId: soundId),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }
}
