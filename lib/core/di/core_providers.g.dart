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

String _$authInterceptorHash() => r'41bbaeb2a452c0ae1791129b4a70b6c85b0f1a3a';

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
    r'0e5a146271f1110752611ecc3841197228f64f43';

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

@ProviderFor(localStorage)
final localStorageProvider = LocalStorageProvider._();

final class LocalStorageProvider
    extends
        $FunctionalProvider<
          LocalStorageService,
          LocalStorageService,
          LocalStorageService
        >
    with $Provider<LocalStorageService> {
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
  $ProviderElement<LocalStorageService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalStorageService create(Ref ref) {
    return localStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalStorageService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalStorageService>(value),
    );
  }
}

String _$localStorageHash() => r'17fa54b5b3bd06596b0bc92e3796d014abc9b681';

@ProviderFor(hiveStorage)
final hiveStorageProvider = HiveStorageProvider._();

final class HiveStorageProvider
    extends $FunctionalProvider<HiveService, HiveService, HiveService>
    with $Provider<HiveService> {
  HiveStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hiveStorageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hiveStorageHash();

  @$internal
  @override
  $ProviderElement<HiveService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HiveService create(Ref ref) {
    return hiveStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HiveService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HiveService>(value),
    );
  }
}

String _$hiveStorageHash() => r'b25ecbde04fa8a8695736c4820dff8aa9cf425fb';

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
