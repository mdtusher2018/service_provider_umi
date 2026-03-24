enum StorageKeyType { string, bool, int, secureString }

enum StorageKey {
  accessToken(StorageKeyType.secureString, 'access_token'),
  refreshToken(StorageKeyType.secureString, 'refresh_token'),
  rememberMe(StorageKeyType.bool, 'rememberMe'),
  savedLoginsKey(StorageKeyType.string, 'saved_logins_accounts'),
  selectedLocale(StorageKeyType.string, 'selected_local');

  final StorageKeyType type;
  final String key;

  const StorageKey(this.type, this.key);
}
