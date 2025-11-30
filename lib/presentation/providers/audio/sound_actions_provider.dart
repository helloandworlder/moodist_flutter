import 'dart:math';
import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/database/app_database.dart';
import '../../../data/datasources/assets/sound_assets.dart';
import '../database_provider.dart';
import 'playback_provider.dart';

part 'sound_actions_provider.g.dart';

@riverpod
class SoundActions extends _$SoundActions {
  @override
  void build() {}

  /// Select sound
  Future<void> selectSound(String soundId) async {
    final dao = ref.read(soundDaoProvider);
    await dao.upsertSoundState(SoundStatesCompanion(
      soundId: Value(soundId),
      isSelected: const Value(true),
    ));
    ref.read(playbackStateProvider.notifier).play();
  }

  /// Unselect sound
  Future<void> unselectSound(String soundId) async {
    final dao = ref.read(soundDaoProvider);
    await dao.upsertSoundState(SoundStatesCompanion(
      soundId: Value(soundId),
      isSelected: const Value(false),
      volume: const Value(0.5),
    ));
  }

  /// Toggle selection
  Future<void> toggleSound(String soundId) async {
    final dao = ref.read(soundDaoProvider);
    final current = await dao.getSoundState(soundId);
    if (current?.isSelected ?? false) {
      await unselectSound(soundId);
    } else {
      await selectSound(soundId);
    }
  }

  /// Set volume
  Future<void> setVolume(String soundId, double volume) async {
    final dao = ref.read(soundDaoProvider);
    await dao.upsertSoundState(SoundStatesCompanion(
      soundId: Value(soundId),
      volume: Value(volume.clamp(0.0, 1.0)),
    ));
  }

  /// Toggle favorite
  Future<void> toggleFavorite(String soundId) async {
    final dao = ref.read(soundDaoProvider);
    final current = await dao.getSoundState(soundId);
    await dao.upsertSoundState(SoundStatesCompanion(
      soundId: Value(soundId),
      isFavorite: Value(!(current?.isFavorite ?? false)),
    ));
  }

  /// Unselect all
  Future<void> unselectAll() async {
    final dao = ref.read(soundDaoProvider);
    await dao.resetAllSelections();
  }

  /// Shuffle mix
  Future<void> shuffle() async {
    final dao = ref.read(soundDaoProvider);
    await dao.resetAllSelections();

    final allSoundIds = SoundAssets.allSoundIds;
    final shuffled = List<String>.from(allSoundIds)..shuffle();
    final selected = shuffled.take(4);

    for (final soundId in selected) {
      await dao.upsertSoundState(SoundStatesCompanion(
        soundId: Value(soundId),
        isSelected: const Value(true),
        volume: Value(Random().nextDouble() * 0.8 + 0.2),
      ));
    }

    ref.read(playbackStateProvider.notifier).play();
  }

  /// Load preset
  Future<void> loadPreset(Map<String, double> sounds) async {
    final dao = ref.read(soundDaoProvider);
    await dao.resetAllSelections();

    for (final entry in sounds.entries) {
      await dao.upsertSoundState(SoundStatesCompanion(
        soundId: Value(entry.key),
        isSelected: const Value(true),
        volume: Value(entry.value),
      ));
    }

    ref.read(playbackStateProvider.notifier).play();
  }

  /// Smart mix presets - curated sound combinations
  Future<void> loadSmartMix(String mixType) async {
    final Map<String, double> sounds;
    
    switch (mixType) {
      case 'focus':
        // Focus mix: rain, cafe ambiance, keyboard typing
        sounds = {
          'light-rain': 0.6,
          'cafe': 0.4,
          'keyboard': 0.3,
          'fireplace': 0.2,
        };
        break;
      case 'relax':
        // Relax mix: nature sounds, gentle rain
        sounds = {
          'rain-on-window': 0.7,
          'fireplace': 0.5,
          'wind': 0.3,
          'birds': 0.25,
        };
        break;
      case 'sleep':
        // Sleep mix: ocean waves, rain, fan
        sounds = {
          'waves': 0.6,
          'heavy-rain': 0.4,
          'fan': 0.3,
          'crickets': 0.2,
        };
        break;
      case 'nature':
        // Nature mix: forest ambiance
        sounds = {
          'birds': 0.6,
          'wind-in-trees': 0.5,
          'river': 0.45,
          'campfire': 0.35,
        };
        break;
      case 'cafe':
        // Cafe mix: coffee shop sounds
        sounds = {
          'cafe': 0.7,
          'coffee-shop': 0.5,
          'crowd': 0.3,
          'rain-on-window': 0.25,
        };
        break;
      default:
        // Random mix as fallback
        await shuffle();
        return;
    }
    
    await loadPreset(sounds);
  }
}
