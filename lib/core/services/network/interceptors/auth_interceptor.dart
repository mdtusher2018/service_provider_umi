import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/storage/local_storage_service.dart';
import 'package:service_provider_umi/core/services/storage/storage_key.dart';

class AuthInterceptor extends Interceptor {
  final LocalStorageService _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(StorageKey.accessToken);

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
