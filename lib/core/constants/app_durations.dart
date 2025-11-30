class AppDurations {
  AppDurations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);
  static const Duration fadeOut = Duration(seconds: 3);

  // Pomodoro defaults (in seconds)
  static const int defaultFocusDuration = 25 * 60;
  static const int defaultShortBreakDuration = 5 * 60;
  static const int defaultLongBreakDuration = 15 * 60;
}
