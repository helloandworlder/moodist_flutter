import 'package:drift/drift.dart';
import '../app_database.dart';

part 'preset_dao.g.dart';

@DriftAccessor(tables: [Presets])
class PresetDao extends DatabaseAccessor<AppDatabase> with _$PresetDaoMixin {
  PresetDao(super.db);

  /// Get all presets (ordered by creation time desc)
  Future<List<Preset>> getAllPresets() =>
      (select(presets)..orderBy([(t) => OrderingTerm.desc(t.createdAt)])).get();

  /// Watch all presets
  Stream<List<Preset>> watchAllPresets() =>
      (select(presets)..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .watch();

  /// Insert new preset
  Future<void> insertPreset(PresetsCompanion preset) =>
      into(presets).insert(preset);

  /// Update preset name
  Future<void> updatePresetName(String id, String newName) =>
      (update(presets)..where((t) => t.id.equals(id)))
          .write(PresetsCompanion(name: Value(newName)));

  /// Delete preset
  Future<void> deletePreset(String id) =>
      (delete(presets)..where((t) => t.id.equals(id))).go();

  /// Get preset count
  Future<int> getPresetCount() async {
    final count = countAll();
    final query = selectOnly(presets)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}
