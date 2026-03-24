import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/network/interceptors/auth_interceptor.dart';
import 'package:service_provider_umi/core/network/interceptors/refresh_token_interceptor.dart';
import 'package:service_provider_umi/core/network/network_info.dart';
import 'package:service_provider_umi/core/services/permission_service.dart';
import 'package:service_provider_umi/core/storage/local_storage.dart';
import 'package:service_provider_umi/core/storage/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'core_providers.g.dart';

@riverpod
NetworkInfo networkInfo(Ref ref) {
  return NetworkInfoImpl(Connectivity());
}

@riverpod
AuthInterceptor authInterceptor(Ref ref) {
  return AuthInterceptor(ref.read(secureStorageProvider));
}

@riverpod
RefreshTokenInterceptor refreshTokenInterceptor(Ref ref, Dio dio) {
  return RefreshTokenInterceptor(
    dio: dio,
    secureStorage: ref.read(secureStorageProvider),
  );
}

@riverpod
SecureStorage secureStorage(Ref ref) {
  return SecureStorage(
    const FlutterSecureStorage(
      aOptions: AndroidOptions(enforceBiometrics: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );
}

@riverpod
Future<LocalStorage> localStorage(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  return LocalStorage(prefs);
}

@riverpod
PermissionService permissionService(Ref ref) {
  return PermissionService();
}
