// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_interceptor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

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
