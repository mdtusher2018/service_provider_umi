import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/core/services/storage/local_storage_service.dart';
import 'package:service_provider_umi/core/services/storage/storage_key.dart';

// Only truly token-free public endpoints. OTP + reset-password endpoints still
// need the short-lived OTP token that is stored after signup / forgot-password.
const _publicPaths = {
  ApiEndpoints.login,
  ApiEndpoints.register,
  ApiEndpoints.googleLogin,
  ApiEndpoints.forgotPassword,
};

class AuthInterceptor extends Interceptor {
  final LocalStorageService _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isPublic = _publicPaths.any((p) => options.path.endsWith(p));
    if (!isPublic) {
      final token = await _secureStorage.read(StorageKey.accessToken);
      if (token != null && token.isNotEmpty) {
        options.headers['token'] = '$token';
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
