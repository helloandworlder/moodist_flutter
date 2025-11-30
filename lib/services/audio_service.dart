import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/database/app_database.dart';
import '../data/datasources/assets/sound_assets.dart';
import '../presentation/providers/audio/playback_provider.dart';
import '../presentation/providers/audio/sound_states_provider.dart';

part 'audio_service.g.dart';

@Riverpod(keepAlive: true)
AudioService audioService(Ref ref) => AudioService(ref);

class AudioService {
  final Ref _ref;
  final Map<String, AudioPlayer> _players = {};
  bool _initialized = false;
  StreamSubscription<List<SoundState>>? _soundStatesSubscription;

  AudioService(this._ref) {
    _initialize();
  }

  void _initialize() {
    if (_initialized) return;
    _initialized = true;

    // Listen to playback state changes
    _ref.listen(playbackStateProvider, (previous, isPlaying) {
      if (isPlaying) {
        _playAllSelected();
      } else {
        _pauseAll();
      }
    });

    // Listen to global volume changes
    _ref.listen(globalVolumeProvider, (previous, globalVolume) {
      _updateAllVolumes(globalVolume);
    });

    // Listen to selected sounds changes
    _ref.listen(selectedSoundsStreamProvider, (previous, asyncValue) {
      asyncValue.whenData((selectedSounds) {
        _syncPlayers(selectedSounds);
      });
    });
  }

  AudioPlayer _getOrCreatePlayer(String soundId) {
    if (!_players.containsKey(soundId)) {
      _players[soundId] = AudioPlayer();
    }
    return _players[soundId]!;
  }

  Future<void> _loadAndPlay(String soundId, double volume) async {
    final player = _getOrCreatePlayer(soundId);
    final assetPath = SoundAssets.getAssetPath(soundId);

    try {
      // Load if not loaded yet
      if (player.audioSource == null) {
        await player.setAsset(assetPath);
        await player.setLoopMode(LoopMode.one);
      }

      // Set volume
      final globalVolume = _ref.read(globalVolumeProvider);
      await player.setVolume(volume * globalVolume);

      // Play
      if (!player.playing) {
        await player.play();
      }
    } catch (e) {
      debugPrint('Failed to load sound: $soundId, error: $e');
    }
  }

  Future<void> _playAllSelected() async {
    final asyncValue = _ref.read(selectedSoundsStreamProvider);
    asyncValue.whenData((selectedSounds) async {
      for (final sound in selectedSounds) {
        // Check if sound exists before trying to play
        if (SoundAssets.getSoundById(sound.soundId) != null) {
          await _loadAndPlay(sound.soundId, sound.volume);
        }
      }
    });
  }

  Future<void> _pauseAll() async {
    // Create a copy to avoid concurrent modification
    final playersCopy = Map<String, AudioPlayer>.from(_players);
    for (final player in playersCopy.values) {
      if (player.playing) {
        await player.pause();
      }
    }
  }

  Future<void> _syncPlayers(List<SoundState> selectedSounds) async {
    final selectedIds = selectedSounds.map((s) => s.soundId).toSet();
    final isPlaying = _ref.read(playbackStateProvider);

    // Create a copy to avoid concurrent modification
    final playersCopy = Map<String, AudioPlayer>.from(_players);
    
    // Stop unselected sounds
    for (final entry in playersCopy.entries) {
      if (!selectedIds.contains(entry.key) && entry.value.playing) {
        await entry.value.pause();
      }
    }

    // Play selected sounds if playback is active
    if (isPlaying) {
      for (final sound in selectedSounds) {
        // Check if sound exists before trying to play
        if (SoundAssets.getSoundById(sound.soundId) != null) {
          await _loadAndPlay(sound.soundId, sound.volume);
        }
      }
    }

    // Update volumes for all selected sounds
    for (final sound in selectedSounds) {
      final player = _players[sound.soundId];
      if (player != null) {
        final globalVolume = _ref.read(globalVolumeProvider);
        await player.setVolume(sound.volume * globalVolume);
      }
    }
  }

  void _updateAllVolumes(double globalVolume) {
    final asyncValue = _ref.read(selectedSoundsStreamProvider);
    asyncValue.whenData((selectedSounds) async {
      for (final sound in selectedSounds) {
        final player = _players[sound.soundId];
        if (player != null) {
          await player.setVolume(sound.volume * globalVolume);
        }
      }
    });
  }

  /// Update single sound volume
  Future<void> updateVolume(String soundId, double volume) async {
    final player = _players[soundId];
    if (player != null) {
      final globalVolume = _ref.read(globalVolumeProvider);
      await player.setVolume(volume * globalVolume);
    }
  }

  /// Fade out and pause all sounds
  Future<void> fadeOutAndPause(Duration duration) async {
    _ref.read(isLockedProvider.notifier).lock();

    final asyncValue = _ref.read(selectedSoundsStreamProvider);
    final selectedSounds = asyncValue.valueOrNull;

    if (selectedSounds == null || selectedSounds.isEmpty) {
      _ref.read(isLockedProvider.notifier).unlock();
      return;
    }

    // Fade out
    const steps = 20;
    final stepDuration = duration ~/ steps;

    for (int i = steps; i >= 0; i--) {
      final factor = i / steps;
      for (final sound in selectedSounds) {
        final player = _players[sound.soundId];
        if (player != null && player.playing) {
          final globalVolume = _ref.read(globalVolumeProvider);
          await player.setVolume(sound.volume * globalVolume * factor);
        }
      }
      await Future.delayed(stepDuration);
    }

    // Pause
    _ref.read(playbackStateProvider.notifier).pause();
    _ref.read(isLockedProvider.notifier).unlock();

    // Restore original volume settings
    _updateAllVolumes(_ref.read(globalVolumeProvider));
  }

  /// Get player state for debugging
  Map<String, bool> get playerStates =>
      _players.map((key, player) => MapEntry(key, player.playing));

  /// Get number of active players
  int get activePlayerCount =>
      _players.values.where((p) => p.playing).length;

  void dispose() {
    _soundStatesSubscription?.cancel();
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
  }
}
