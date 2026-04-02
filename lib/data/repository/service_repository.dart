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
      
}

