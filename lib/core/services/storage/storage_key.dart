enum StorageKeyType { string, bool, int, secureString }

enum StorageKey {
  accessToken(StorageKeyType.secureString, 'access_token'),
  refreshToken(StorageKeyType.secureString, 'refresh_token'),
  selectedLocale(StorageKeyType.string, 'selected_local'),
  userRole(StorageKeyType.string, 'user_role'),
  hasActiveSubscription(StorageKeyType.bool, 'has_active_subscription');

  final StorageKeyType type;
  final String key;

  const StorageKey(this.type, this.key);
}
