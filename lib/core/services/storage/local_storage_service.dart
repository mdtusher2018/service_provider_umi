import 'package:service_provider_umi/core/services/storage/storage_key.dart';

abstract class LocalStorageService {
  Future<void> init();

  Future<void> write(StorageKey key, dynamic value);
  Future<T?> read<T>(StorageKey key);

  /// 🔥 Sync read (from memory cache)
  T? readSync<T>(StorageKey key);

  Future<void> deleteKey(StorageKey key);

  Future<void> clearPrefs();
  Future<void> clearSecure();
  Future<void> clearAll();

  void disableSessionMode(bool value);
  bool get isSessionMode;
}
