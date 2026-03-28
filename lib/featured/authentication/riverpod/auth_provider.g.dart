// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginNotifier)
final loginProvider = LoginNotifierProvider._();

final class LoginNotifierProvider
    extends $NotifierProvider<LoginNotifier, AuthState> {
  LoginNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginNotifierHash();

  @$internal
  @override
  LoginNotifier create() => LoginNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$loginNotifierHash() => r'f844607169e791649e07825dece1ce9179a4b9e7';

abstract class _$LoginNotifier extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SignupNotifier)
final signupProvider = SignupNotifierProvider._();

final class SignupNotifierProvider
    extends $NotifierProvider<SignupNotifier, AuthState> {
  SignupNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signupNotifierHash();

  @$internal
  @override
  SignupNotifier create() => SignupNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$signupNotifierHash() => r'3de465519c3fb3a1c30b5870f72f34cfb22e736d';

abstract class _$SignupNotifier extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(OtpVerifyNotifier)
final otpVerifyProvider = OtpVerifyNotifierProvider._();

final class OtpVerifyNotifierProvider
    extends $NotifierProvider<OtpVerifyNotifier, AuthState> {
  OtpVerifyNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'otpVerifyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$otpVerifyNotifierHash();

  @$internal
  @override
  OtpVerifyNotifier create() => OtpVerifyNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$otpVerifyNotifierHash() => r'b9eb654b1cddfa8ad5d037a6b27045e716f297ab';

abstract class _$OtpVerifyNotifier extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ResendOtpNotifier)
final resendOtpProvider = ResendOtpNotifierProvider._();

final class ResendOtpNotifierProvider
    extends $NotifierProvider<ResendOtpNotifier, AuthState> {
  ResendOtpNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resendOtpProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resendOtpNotifierHash();

  @$internal
  @override
  ResendOtpNotifier create() => ResendOtpNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$resendOtpNotifierHash() => r'0b224f837476a25dfbf1eb1316089e4e5fe0eb88';

abstract class _$ResendOtpNotifier extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ForgotPasswordNotifier)
final forgotPasswordProvider = ForgotPasswordNotifierProvider._();

final class ForgotPasswordNotifierProvider
    extends $NotifierProvider<ForgotPasswordNotifier, AuthState> {
  ForgotPasswordNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'forgotPasswordProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$forgotPasswordNotifierHash();

  @$internal
  @override
  ForgotPasswordNotifier create() => ForgotPasswordNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$forgotPasswordNotifierHash() =>
    r'd8b466c75a6295faac3c012834972a369d9c8616';

abstract class _$ForgotPasswordNotifier extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ResetPasswordNotifier)
final resetPasswordProvider = ResetPasswordNotifierProvider._();

final class ResetPasswordNotifierProvider
    extends $NotifierProvider<ResetPasswordNotifier, AuthState> {
  ResetPasswordNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resetPasswordProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resetPasswordNotifierHash();

  @$internal
  @override
  ResetPasswordNotifier create() => ResetPasswordNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$resetPasswordNotifierHash() =>
    r'c436c4adfd6679d50efaf0e61da7f03cec0939be';

abstract class _$ResetPasswordNotifier extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ChangePasswordNotifier)
final changePasswordProvider = ChangePasswordNotifierProvider._();

final class ChangePasswordNotifierProvider
    extends $NotifierProvider<ChangePasswordNotifier, AuthState> {
  ChangePasswordNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'changePasswordProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$changePasswordNotifierHash();

  @$internal
  @override
  ChangePasswordNotifier create() => ChangePasswordNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$changePasswordNotifierHash() =>
    r'7b6a5e1c637402b064fbfde957780d9b31eb6be1';

abstract class _$ChangePasswordNotifier extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(LogoutNotifier)
final logoutProvider = LogoutNotifierProvider._();

final class LogoutNotifierProvider
    extends $NotifierProvider<LogoutNotifier, AuthState> {
  LogoutNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoutProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoutNotifierHash();

  @$internal
  @override
  LogoutNotifier create() => LogoutNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthState>(value),
    );
  }
}

String _$logoutNotifierHash() => r'18193b9640b974363a3bbd710a1414d2d933840f';

abstract class _$LogoutNotifier extends $Notifier<AuthState> {
  AuthState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthState, AuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthState, AuthState>,
              AuthState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
