// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(networkInfo)
final networkInfoProvider = NetworkInfoProvider._();

final class NetworkInfoProvider
    extends $FunctionalProvider<NetworkInfo, NetworkInfo, NetworkInfo>
    with $Provider<NetworkInfo> {
  NetworkInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'networkInfoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$networkInfoHash();

  @$internal
  @override
  $ProviderElement<NetworkInfo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NetworkInfo create(Ref ref) {
    return networkInfo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NetworkInfo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NetworkInfo>(value),
    );
  }
}

String _$networkInfoHash() => r'741b8afc2fb3fbb07ee0292562c2af9b068994f9';

@ProviderFor(authInterceptor)
final authInterceptorProvider = AuthInterceptorProvider._();

final class AuthInterceptorProvider
    extends
        $FunctionalProvider<AuthInterceptor, AuthInterceptor, AuthInterceptor>
    with $Provider<AuthInterceptor> {
  AuthInterceptorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authInterceptorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authInterceptorHash();

  @$internal
  @override
  $ProviderElement<AuthInterceptor> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthInterceptor create(Ref ref) {
    return authInterceptor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthInterceptor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthInterceptor>(value),
    );
  }
}

String _$authInterceptorHash() => r'f6262e7877834b7130fd7260b2fc733aef480f47';

@ProviderFor(refreshTokenInterceptor)
final refreshTokenInterceptorProvider = RefreshTokenInterceptorFamily._();

final class RefreshTokenInterceptorProvider
    extends
        $FunctionalProvider<
          RefreshTokenInterceptor,
          RefreshTokenInterceptor,
          RefreshTokenInterceptor
        >
    with $Provider<RefreshTokenInterceptor> {
  RefreshTokenInterceptorProvider._({
    required RefreshTokenInterceptorFamily super.from,
    required Dio super.argument,
  }) : super(
         retry: null,
         name: r'refreshTokenInterceptorProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$refreshTokenInterceptorHash();

  @override
  String toString() {
    return r'refreshTokenInterceptorProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<RefreshTokenInterceptor> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RefreshTokenInterceptor create(Ref ref) {
    final argument = this.argument as Dio;
    return refreshTokenInterceptor(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RefreshTokenInterceptor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RefreshTokenInterceptor>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is RefreshTokenInterceptorProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$refreshTokenInterceptorHash() =>
    r'634beca1f3001b6c34f19682374d221606c71be3';

final class RefreshTokenInterceptorFamily extends $Family
    with $FunctionalFamilyOverride<RefreshTokenInterceptor, Dio> {
  RefreshTokenInterceptorFamily._()
    : super(
        retry: null,
        name: r'refreshTokenInterceptorProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RefreshTokenInterceptorProvider call(Dio dio) =>
      RefreshTokenInterceptorProvider._(argument: dio, from: this);

  @override
  String toString() => r'refreshTokenInterceptorProvider';
}

@ProviderFor(secureStorage)
final secureStorageProvider = SecureStorageProvider._();

final class SecureStorageProvider
    extends $FunctionalProvider<SecureStorage, SecureStorage, SecureStorage>
    with $Provider<SecureStorage> {
  SecureStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'secureStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$secureStorageHash();

  @$internal
  @override
  $ProviderElement<SecureStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SecureStorage create(Ref ref) {
    return secureStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SecureStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SecureStorage>(value),
    );
  }
}

String _$secureStorageHash() => r'0e8cd2593a23b6507098cbe1b8a070254a1602c3';

@ProviderFor(localStorage)
final localStorageProvider = LocalStorageProvider._();

final class LocalStorageProvider
    extends
        $FunctionalProvider<
          AsyncValue<LocalStorage>,
          LocalStorage,
          FutureOr<LocalStorage>
        >
    with $FutureModifier<LocalStorage>, $FutureProvider<LocalStorage> {
  LocalStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localStorageHash();

  @$internal
  @override
  $FutureProviderElement<LocalStorage> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LocalStorage> create(Ref ref) {
    return localStorage(ref);
  }
}

String _$localStorageHash() => r'5ca7ed888ffd89f6da9aee2a9b119dd6c7c1df6f';

@ProviderFor(permissionService)
final permissionServiceProvider = PermissionServiceProvider._();

final class PermissionServiceProvider
    extends
        $FunctionalProvider<
          PermissionService,
          PermissionService,
          PermissionService
        >
    with $Provider<PermissionService> {
  PermissionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'permissionServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$permissionServiceHash();

  @$internal
  @override
  $ProviderElement<PermissionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PermissionService create(Ref ref) {
    return permissionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PermissionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PermissionService>(value),
    );
  }
}

String _$permissionServiceHash() => r'8944118369fdc2dd355a221dd4f8a487b7f3372c';
