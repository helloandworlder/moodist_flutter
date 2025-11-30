import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../data/database/app_database.dart';
import '../database_provider.dart';

part 'sound_states_provider.g.dart';

/// All sound states (reactive Stream)
@riverpod
Stream<List<SoundState>> soundStatesStream(Ref ref) {
  final dao = ref.watch(soundDaoProvider);
  return dao.watchAllSoundStates();
}

/// Selected sounds
@riverpod
Stream<List<SoundState>> selectedSoundsStream(Ref ref) {
  final dao = ref.watch(soundDaoProvider);
  return dao.watchSelectedSounds();
}

/// Favorite sounds
@riverpod
Stream<List<SoundState>> favoriteSoundsStream(Ref ref) {
  final dao = ref.watch(soundDaoProvider);
  return dao.watchFavorites();
}

/// Whether there are selected sounds
@riverpod
bool hasSelection(Ref ref) {
  final asyncValue = ref.watch(selectedSoundsStreamProvider);
  return asyncValue.maybeWhen(
    data: (sounds) => sounds.isNotEmpty,
    orElse: () => false,
  );
}
