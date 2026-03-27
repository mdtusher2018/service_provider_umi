// data/data_source/local/service_local_data_source.dart

import 'dart:convert';
import 'package:service_provider_umi/core/services/storage/hive_service.dart';
import 'package:service_provider_umi/data/models/service_models.dart';

/// Hive cache keys
class _Keys {
  static const homeServices = 'home_services';
  static const allServices = 'all_services';
  static String subCategories(String type) => 'sub_categories_$type';
}

class ServiceLocalDataSource {
  final HiveService _hive;

  static const _box = 'services_cache';

  ServiceLocalDataSource({required HiveService hiveService})
      : _hive = hiveService;

  // ── Home Services ─────────────────────────────────────────────────────────

  Future<void> cacheHomeServices(HomeServicesResponse data) async {
    await _hive.put(_box, _Keys.homeServices, jsonEncode(data.toJson()));
  }

  Future<HomeServicesResponse?> getCachedHomeServices() async {
    final raw = await _hive.get<String>(_box, _Keys.homeServices);
    if (raw == null) return null;
    return HomeServicesResponse.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  // ── All Services ──────────────────────────────────────────────────────────

  Future<void> cacheAllServices(AllServicesResponse data) async {
    await _hive.put(_box, _Keys.allServices, jsonEncode(data.toJson()));
  }

  Future<AllServicesResponse?> getCachedAllServices() async {
    final raw = await _hive.get<String>(_box, _Keys.allServices);
    if (raw == null) return null;
    return AllServicesResponse.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  // ── Sub-Categories ────────────────────────────────────────────────────────

  Future<void> cacheSubCategories(
    String serviceType,
    AllServicesResponse data,
  ) async {
    await _hive.put(
      _box,
      _Keys.subCategories(serviceType),
      jsonEncode(data.toJson()),
    );
  }

  Future<AllServicesResponse?> getCachedSubCategories(
    String serviceType,
  ) async {
    final raw =
        await _hive.get<String>(_box, _Keys.subCategories(serviceType));
    if (raw == null) return null;
    return AllServicesResponse.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  // ── Clear ─────────────────────────────────────────────────────────────────

  Future<void> clearAll() => _hive.clearBox(_box);
}
