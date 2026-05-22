import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/services/network/interceptors/auth_interceptor.dart';
import 'package:service_provider_umi/core/services/network/interceptors/refresh_token_interceptor.dart';
import 'package:service_provider_umi/core/services/network/network_info.dart';
import 'package:service_provider_umi/core/services/permission_service.dart';
import 'package:service_provider_umi/core/services/storage/local_storage_service.dart';
import 'package:service_provider_umi/core/services/storage/local_storage_service_impl.dart';

part 'core_providers.g.dart';

@riverpod
NetworkInfo networkInfo(Ref ref) {
  return NetworkInfoImpl(Connectivity());
}

@riverpod
AuthInterceptor authInterceptor(Ref ref) {
  return AuthInterceptor(ref.read(localStorageProvider));
}

@riverpod
RefreshTokenInterceptor refreshTokenInterceptor(Ref ref, Dio dio) {
  return RefreshTokenInterceptor(
    dio: dio,
    secureStorage: ref.read(localStorageProvider),
  );
}

@riverpod
LocalStorageService localStorage(Ref ref) {
  final local = LocalStorageServiceImpl();
  return local;
}

@riverpod
PermissionService permissionService(Ref ref) {
  return PermissionService();
}

final overlayProvider = StateNotifierProvider<OverlayNotifier, Widget?>((ref) {
  return OverlayNotifier();
});

class OverlayNotifier extends StateNotifier<Widget?> {
  OverlayNotifier() : super(null);

  void show(Widget content) => state = content;
  void dismiss() => state = null;
}
