import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../storage/secure_storage.dart';
import '../../storage/storage_keys.dart';
import '../api_endpoints.dart';

part 'refresh_token_interceptor.g.dart';

@riverpod
RefreshTokenInterceptor refreshTokenInterceptor(Ref ref, Dio dio) {
  return RefreshTokenInterceptor(
    dio: dio,
    secureStorage: ref.read(secureStorageProvider),
  );
}

class RefreshTokenInterceptor extends Interceptor {
  final Dio _dio;
  final SecureStorage _secureStorage;
  bool _isRefreshing = false;

  RefreshTokenInterceptor({
    required Dio dio,
    required SecureStorage secureStorage,
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
        final refreshToken = await _secureStorage.read(
          StorageKeys.refreshToken,
        );

        if (refreshToken == null) {
          _isRefreshing = false;
          return handler.next(err);
        }

        final response = await _dio.post(
          ApiEndpoints.refreshToken,
          data: {'refresh_token': refreshToken},
          options: Options(headers: {'Authorization': null}),
        );

        final newAccessToken = response.data['access_token'] as String?;
        final newRefreshToken = response.data['refresh_token'] as String?;

        if (newAccessToken != null) {
          await _secureStorage.write(StorageKeys.accessToken, newAccessToken);
        }

        if (newRefreshToken != null) {
          await _secureStorage.write(StorageKeys.refreshToken, newRefreshToken);
        }

        // Retry original request
        final retryOptions = err.requestOptions;
        retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        final retryResponse = await _dio.fetch(retryOptions);
        _isRefreshing = false;

        return handler.resolve(retryResponse);
      } catch (e) {
        _isRefreshing = false;
        await _secureStorage.deleteAll();
        // Trigger logout / navigate to login
        return handler.next(err);
      }
    }

    handler.next(err);
  }
}
