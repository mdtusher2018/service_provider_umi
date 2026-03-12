class StorageKeys {
  StorageKeys._();

  // ─── Secure Storage ──────────────────────────────────────
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';

  // ─── Hive / SharedPreferences ────────────────────────────
  static const String isFirstLaunch = 'is_first_launch';
  static const String isLoggedIn = 'is_logged_in';
  static const String activeRole = 'active_role';
  static const String selectedLocale = 'selected_locale';
  static const String isDarkMode = 'is_dark_mode';
  static const String fcmToken = 'fcm_token';
  static const String cachedProfile = 'cached_profile';
  static const String cachedServices = 'cached_services';
  static const String onboardingCompleted = 'onboarding_completed';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String locationPermissionGranted = 'location_permission_granted';
  static const String lastSyncedAt = 'last_synced_at';
}
