// data/repository/service_repository.dart

import 'package:service_provider_umi/core/base/repository.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/data_source/local/service_local_data_source.dart';
import 'package:service_provider_umi/data/data_source/remote/service_remote_data_source.dart';
import 'package:service_provider_umi/data/models/service_models.dart';

class ServiceRepository with SafeCall {
  final ServiceRemoteDataSource _remote;
  final ServiceLocalDataSource _local;

  ServiceRepository({
    required ServiceRemoteDataSource remote,
    required ServiceLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  // ── Home Services ─────────────────────────────────────────────────────────
  // Strategy: return cache immediately if available, then refresh from API.
  // On no network, cache is the fallback.

  Future<Result<HomeServicesResponse, Failure>> getHomeServices() async {
    // 1. Try API first
    final result = await asyncGuard(() => _remote.getHomeServices());

    return result.when(
      success: (data) async {
        // Cache the fresh data
        await _local.cacheHomeServices(data);
        return Success(data);
      },
      failure: (failure) async {
        // 2. API failed → try cache
        final cached = await _local.getCachedHomeServices();
        if (cached != null) return Success(cached);
        // 3. No cache → surface the failure
        return Error(failure);
      },
    );
  }

  // ── All Services ──────────────────────────────────────────────────────────

  Future<Result<AllServicesResponse, Failure>> getAllServices() async {
    final result = await asyncGuard(() => _remote.getAllServices());

    return result.when(
      success: (data) async {
        await _local.cacheAllServices(data);
        return Success(data);
      },
      failure: (failure) async {
        final cached = await _local.getCachedAllServices();
        if (cached != null) return Success(cached);
        return Error(failure);
      },
    );
  }

  // ── Sub-Categories ────────────────────────────────────────────────────────

  Future<Result<AllServicesResponse, Failure>> getSubCategories(
    String serviceType,
  ) async {
    final result =
        await asyncGuard(() => _remote.getSubCategories(serviceType));

    return result.when(
      success: (data) async {
        await _local.cacheSubCategories(serviceType, data);
        return Success(data);
      },
      failure: (failure) async {
        final cached = await _local.getCachedSubCategories(serviceType);
        if (cached != null) return Success(cached);
        return Error(failure);
      },
    );
  }
}
