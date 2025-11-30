import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:easy_localization/easy_localization.dart';
import 'app.dart';
import 'data/datasources/assets/sound_assets.dart';
import 'presentation/providers/database_provider.dart';
import 'data/database/daos/sound_dao.dart';
import 'services/audio_service.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  // Initialize background audio service
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.moodist.app.audio',
    androidNotificationChannelName: 'Moodist Audio',
    androidNotificationOngoing: true,
    androidShowNotificationBadge: false,
  );

  // Create provider container for initialization
  final container = ProviderContainer();

  // Initialize database and sound states
  final db = container.read(appDatabaseProvider);
  final soundDao = SoundDao(db);
  await soundDao.initializeSoundStates(SoundAssets.allSoundIds);

  // Initialize audio service
  container.read(audioServiceProvider);

  // Initialize notification service
  await container.read(notificationServiceProvider).initialize();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('zh'),
        Locale('ja'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: UncontrolledProviderScope(
        container: container,
        child: const MoodistApp(),
      ),
    ),
  );
}
