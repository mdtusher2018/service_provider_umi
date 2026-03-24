import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'local_storage_service.dart';
import 'storage_key.dart';

final class LocalStorageServiceImpl implements LocalStorageService {
  static final LocalStorageServiceImpl _instance =
      LocalStorageServiceImpl._internal();

  factory LocalStorageServiceImpl() => _instance;

  LocalStorageServiceImpl._internal();

  late SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Session mode flag
  bool _isSessionMode = false;

  /// Memory cache (used for sync reads)
  final Map<String, dynamic> _cache = {};

  /// Session-only cache (cleared when app is killed)
  final Map<String, dynamic> _sessionCache = {};

  // ================= INIT =================
  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();

    /// preload important keys
    _cache[StorageKey.selectedLocale.key] = _prefs.getString(
      StorageKey.selectedLocale.key,
    );

    _cache[StorageKey.rememberMe.key] = _prefs.getBool(
      StorageKey.rememberMe.key,
    );

    /// determine session mode
    _isSessionMode = !(_cache[StorageKey.rememberMe.key] ?? false);
  }

  // ================= SESSION MODE =================
  @override
  void disableSessionMode(bool value) {
    _isSessionMode = value;

    if (!_isSessionMode) {
      _sessionCache.clear();
    }
  }

  @override
  bool get isSessionMode => _isSessionMode;

  // ================= WRITE =================
  @override
  Future<void> write(StorageKey key, dynamic value) async {
    /// always update cache
    _cache[key.key] = value;

    /// session mode → memory only
    if (_isSessionMode) {
      _sessionCache[key.key] = value;
      return;
    }

    switch (key.type) {
      case StorageKeyType.string:
        await _prefs.setString(key.key, value as String);
        break;

      case StorageKeyType.secureString:
        await _secureStorage.write(key: key.key, value: value as String);
        break;

      case StorageKeyType.bool:
        await _prefs.setBool(key.key, value as bool);
        break;

      case StorageKeyType.int:
        await _prefs.setInt(key.key, value as int);
        break;
    }
  }

  // ================= ASYNC READ =================
  @override
  Future<T?> read<T>(StorageKey key) async {
    /// session mode
    if (_isSessionMode && _sessionCache.containsKey(key.key)) {
      return _sessionCache[key.key] as T?;
    }

    switch (key.type) {
      case StorageKeyType.string:
        return _prefs.getString(key.key) as T?;

      case StorageKeyType.secureString:
        final value = await _secureStorage.read(key: key.key);
        return value as T?;

      case StorageKeyType.bool:
        return _prefs.getBool(key.key) as T?;

      case StorageKeyType.int:
        return _prefs.getInt(key.key) as T?;
    }
  }

  // ================= SYNC READ (🔥 IMPORTANT) =================
  @override
  T? readSync<T>(StorageKey key) {
    /// session mode
    if (_isSessionMode && _sessionCache.containsKey(key.key)) {
      return _sessionCache[key.key] as T?;
    }

    return _cache[key.key] as T?;
  }

  // ================= DELETE =================
  @override
  Future<void> deleteKey(StorageKey key) async {
    _cache.remove(key.key);
    _sessionCache.remove(key.key);

    if (_isSessionMode) return;

    if (key.type == StorageKeyType.secureString) {
      await _secureStorage.delete(key: key.key);
    } else {
      await _prefs.remove(key.key);
    }
  }

  // ================= CLEAR =================
  @override
  Future<void> clearPrefs() async {
    _cache.clear();
    _sessionCache.clear();

    await _prefs.clear();
  }

  @override
  Future<void> clearSecure() async {
    _sessionCache.clear();

    await _secureStorage.deleteAll();
  }

  @override
  Future<void> clearAll() async {
    _cache.clear();
    _sessionCache.clear();
    _isSessionMode = true;

    await clearPrefs();
    await clearSecure();
  }
}
