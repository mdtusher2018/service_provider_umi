import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/config/app_config.dart';
import 'package:service_provider_umi/core/services/network/interceptors/logging_interceptor.dart';
import 'package:service_provider_umi/core/services/socket/socket_service.dart';

import 'package:service_provider_umi/core/services/storage/local_storage_service.dart';
import 'package:service_provider_umi/core/services/storage/storage_key.dart';

import '../api_endpoints.dart';

class RefreshTokenInterceptor extends Interceptor {
  final Dio _dio;
  final LocalStorageService _secureStorage;
  bool _isRefreshing = false;

  RefreshTokenInterceptor({
    required Dio dio,
    required LocalStorageService secureStorage,
  }) : _dio = dio,
       _secureStorage = secureStorage;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      try {
        final refreshToken = await _secureStorage.read(StorageKey.refreshToken);

        if (refreshToken == null) {
          _isRefreshing = false;
          return handler.next(err);
        }
        final refreshDio = await Dio(
          BaseOptions(
            baseUrl: AppConfig.baseUrl,
            connectTimeout: Duration(milliseconds: AppConfig.connectTimeout),
            receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeout),
            sendTimeout: Duration(milliseconds: AppConfig.sendTimeout),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );
        refreshDio.interceptors.addAll([
          if (!const bool.fromEnvironment('dart.vm.product'))
            LoggingInterceptor(),
        ]);
        final response = await refreshDio.post(
          ApiEndpoints.refreshToken,
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = response.data['data']['accessToken'] as String?;

        if (newAccessToken != null) {
          await _secureStorage.write(StorageKey.accessToken, newAccessToken);
          SocketService.instance.updateToken(newAccessToken);
        }

        // Retry original request
        final retryOptions = err.requestOptions;
        retryOptions.headers['token'] = newAccessToken;

        final retryResponse = await _dio.fetch(retryOptions);
        _isRefreshing = false;

        return handler.resolve(retryResponse);
      } catch (e) {
        _isRefreshing = false;
        await _secureStorage.clearAll();
        // Trigger logout / navigate to login
        return handler.next(err);
      }
    }

    handler.next(err);
  }
}
