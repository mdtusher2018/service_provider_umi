import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  HiveService._();
  static final HiveService instance = HiveService._();

  final Map<String, Box> _boxes = {};

  // ── Init ──────────────────────────────────────────────────────────────────

  static Future<void> init() => Hive.initFlutter();

  Future<Box> _box(String name) async =>
      _boxes[name] ??= await Hive.openBox(name);

  // ── Write ─────────────────────────────────────────────────────────────────

  Future<void> put(String box, String key, dynamic value) async =>
      (await _box(box)).put(key, value);

  Future<void> putAll(String box, Map<String, dynamic> entries) async =>
      (await _box(box)).putAll(entries);

  // ── Read ──────────────────────────────────────────────────────────────────

  Future<T?> get<T>(String box, String key) async =>
      (await _box(box)).get(key) as T?;

  Future<List<T>> getAll<T>(String box) async =>
      (await _box(box)).values.cast<T>().toList();

  // ── Watch (live updates) ──────────────────────────────────────────────────

  Future<Stream<BoxEvent>> watch(String box, {String? key}) async =>
      (await _box(box)).watch(key: key);

  // ── Delete ────────────────────────────────────────────────────────────────

  Future<void> delete(String box, String key) async =>
      (await _box(box)).delete(key);

  Future<void> clearBox(String box) async => (await _box(box)).clear();

  // ── Sync queue (offline mutations) ───────────────────────────────────────

  static const _syncBox = 'sync_queue';

  Future<void> enqueue(Map<String, dynamic> operation) async {
    final box = await _box(_syncBox);
    await box.add(operation); // auto-incremented int key
  }

  Future<List<({int key, Map operation})>> getPending() async {
    final box = await _box(_syncBox);
    return box
        .toMap()
        .entries
        .map((e) => (key: e.key as int, operation: e.value as Map))
        .toList();
  }

  Future<void> markSynced(int key) async => (await _box(_syncBox)).delete(key);
}
