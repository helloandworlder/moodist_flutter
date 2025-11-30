import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../../data/database/app_database.dart';
import '../database_provider.dart';
import '../audio/sound_actions_provider.dart';

part 'preset_provider.g.dart';

/// Watch all presets
@riverpod
Stream<List<Preset>> presetsStream(Ref ref) {
  final dao = ref.watch(presetDaoProvider);
  return dao.watchAllPresets();
}

/// Preset actions
@riverpod
class PresetActions extends _$PresetActions {
  @override
  void build() {}

  /// Save current selection as a new preset
  Future<bool> saveCurrentAsPreset(String name) async {
    final soundDao = ref.read(soundDaoProvider);
    final presetDao = ref.read(presetDaoProvider);

    // Get current selected sounds
    final selectedSounds = await soundDao.getSelectedSounds();
    if (selectedSounds.isEmpty) {
      return false;
    }

    // Create sounds JSON map
    final soundsMap = <String, double>{};
    for (final sound in selectedSounds) {
      soundsMap[sound.soundId] = sound.volume;
    }

    // Insert new preset
    await presetDao.insertPreset(PresetsCompanion(
      id: Value(const Uuid().v4()),
      name: Value(name.trim()),
      soundsJson: Value(jsonEncode(soundsMap)),
      createdAt: Value(DateTime.now()),
    ));

    return true;
  }

  /// Load a preset
  Future<void> loadPreset(Preset preset) async {
    final soundsMap = _parseSoundsJson(preset.soundsJson);
    await ref.read(soundActionsProvider.notifier).loadPreset(soundsMap);
  }

  /// Rename a preset
  Future<void> renamePreset(String presetId, String newName) async {
    final dao = ref.read(presetDaoProvider);
    await dao.updatePresetName(presetId, newName.trim());
  }

  /// Delete a preset
  Future<void> deletePreset(String presetId) async {
    final dao = ref.read(presetDaoProvider);
    await dao.deletePreset(presetId);
  }

  /// Update an existing preset with current selection
  Future<bool> updatePresetWithCurrent(String presetId) async {
    final soundDao = ref.read(soundDaoProvider);

    // Get current selected sounds
    final selectedSounds = await soundDao.getSelectedSounds();
    if (selectedSounds.isEmpty) {
      return false;
    }

    // Create sounds JSON map
    final soundsMap = <String, double>{};
    for (final sound in selectedSounds) {
      soundsMap[sound.soundId] = sound.volume;
    }

    // Update via delete and insert (Drift doesn't have direct soundsJson update)
    final db = ref.read(appDatabaseProvider);
    await db.transaction(() async {
      final existing = await (db.select(db.presets)
            ..where((t) => t.id.equals(presetId)))
          .getSingleOrNull();
      if (existing != null) {
        await (db.delete(db.presets)..where((t) => t.id.equals(presetId))).go();
        await db.into(db.presets).insert(PresetsCompanion(
              id: Value(presetId),
              name: Value(existing.name),
              soundsJson: Value(jsonEncode(soundsMap)),
              createdAt: Value(existing.createdAt),
            ));
      }
    });

    return true;
  }

  /// Parse sounds JSON to Map
  Map<String, double> _parseSoundsJson(String json) {
    try {
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, (value as num).toDouble()));
    } catch (e) {
      return {};
    }
  }
}

/// Helper extension to get sound list from preset
extension PresetExtension on Preset {
  /// Get sounds map from JSON
  Map<String, double> get soundsMap {
    try {
      final decoded = jsonDecode(soundsJson) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, (value as num).toDouble()));
    } catch (e) {
      return {};
    }
  }

  /// Get sound count
  int get soundCount => soundsMap.length;
}
