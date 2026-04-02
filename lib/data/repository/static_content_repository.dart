import 'package:service_provider_umi/core/base/repository.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/data_source/remote/static_content_remote_data_source.dart';
import 'package:service_provider_umi/data/models/static_content_model.dart';

class StaticContentRepository with SafeCall {
  final StaticContentRemoteDataSource _remote;

  StaticContentRepository({required StaticContentRemoteDataSource remote})
    : _remote = remote;

  Future<Result<StaticContentItem, Failure>> getStaticContents() =>
      asyncGuard(() => _remote.getStaticContents());
}
