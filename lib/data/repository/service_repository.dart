import 'package:service_provider_umi/core/base/repository.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/failure.dart';

import 'package:service_provider_umi/data/data_source/remote/service_remote_data_source.dart';
import 'package:service_provider_umi/data/models/service_models.dart';

class ServiceRepository with SafeCall {
  final ServiceRemoteDataSource _remote;

  ServiceRepository({required ServiceRemoteDataSource remote})
    : _remote = remote;

  // ── GET /categories ──────────────────────────────────────────────────────────
  Future<Result<List<ServiceModel>, Failure>> getAllCategories() =>
      asyncGuard(() => _remote.getAllCategories());

  // ── GET /categories/:id ──────────────────────────────────────────────────────
  Future<Result<ServiceModel, Failure>> getServiceById(String id) =>
      asyncGuard(() => _remote.getServiceById(id));

  // ── POST /categories (admin) ─────────────────────────────────────────────────
  Future<Result<ServiceModel, Failure>> createService(
    CreateServiceRequest data, {
    String? imagePath,
  }) => asyncGuard(() => _remote.createService(data, imagePath));

  // ── PATCH /categories/:id (admin) ────────────────────────────────────────────
  Future<Result<ServiceModel, Failure>> updateService(
    String id,
    UpdateServiceRequest data, {
    String? imagePath,
  }) => asyncGuard(() => _remote.updateService(id, data, imagePath));

  // ── DELETE /categories/:id (admin) ───────────────────────────────────────────
  Future<Result<void, Failure>> deleteService(String id) =>
      asyncGuard(() => _remote.deleteService(id));
}

class ContentRepository with SafeCall {
  final ContentRemoteDataSource _remote;

  ContentRepository({required ContentRemoteDataSource remote})
    : _remote = remote;

  // ── GET /contents ─────────────────────────────────────────────────────────────
  Future<Result<List<ContentItem>, Failure>> getContents() =>
      asyncGuard(() => _remote.getContents());
}
