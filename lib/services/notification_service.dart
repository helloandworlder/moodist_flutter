import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_service.g.dart';

@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) => NotificationService();

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _initialized = true;
  }

  void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap - can be extended later
  }

  /// Request notification permissions (iOS)
  Future<bool> requestPermissions() async {
    final ios = _notifications.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }

    final android = _notifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }

    return true;
  }

  /// Show a simple notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await initialize();

    const androidDetails = AndroidNotificationDetails(
      'moodist_timers',
      'Timers',
      channelDescription: 'Timer notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(id, title, body, details, payload: payload);
  }

  /// Show Pomodoro completion notification
  Future<void> showPomodoroComplete({required bool isFocusPhase}) async {
    await showNotification(
      id: 1,
      title: isFocusPhase ? 'Focus Complete!' : 'Break Complete!',
      body: isFocusPhase
          ? 'Great work! Time for a break.'
          : 'Break is over. Ready to focus?',
      payload: 'pomodoro',
    );
  }

  /// Show Countdown complete notification
  Future<void> showCountdownComplete() async {
    await showNotification(
      id: 2,
      title: 'Countdown Complete!',
      body: 'Your timer has finished.',
      payload: 'countdown',
    );
  }

  /// Show Sleep Timer notification
  Future<void> showSleepTimerComplete() async {
    await showNotification(
      id: 3,
      title: 'Sleep Timer',
      body: 'Music has been stopped. Goodnight!',
      payload: 'sleep_timer',
    );
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
