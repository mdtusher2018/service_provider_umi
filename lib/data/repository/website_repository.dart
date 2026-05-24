import 'package:service_provider_umi/core/base/repository.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/data_source/remote/website_remote_data_source.dart';
import 'package:service_provider_umi/data/models/website_models.dart';

class WebsiteRepository with SafeCall {
  final WebsiteRemoteDataSource _remote;

  WebsiteRepository({required WebsiteRemoteDataSource remote})
    : _remote = remote;

  // ── GET /categories ──────────────────────────────────────────────────────────
  Future<Result<List<WebsiteServiceModel>, Failure>> getAllCategories() =>
      asyncGuard(() => _remote.getAllServices());
  Future<Result<List<AboutUsModel>, Failure>> getAllAboutUs() =>
      asyncGuard(() => _remote.getAllAboutUs());
}
