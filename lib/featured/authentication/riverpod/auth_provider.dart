import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/models/auth_models.dart';
import 'package:service_provider_umi/data/repository/auth_repository.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';

part 'auth_provider.freezed.dart';
part 'auth_provider.g.dart';

// ── Shared State ──────────────────────────────────────────────────────────────

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.success() = AuthSuccess;
  const factory AuthState.failure(Failure failure) = AuthFailure;
}

// ── Login ─────────────────────────────────────────────────────────────────────

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  AuthState build() => const AuthState.initial();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  /// Email + password login  →  POST /auth/login
  Future<void> withEmail(String email, String password) async {
    state = const AuthState.loading();
    final result = await _repo.loginWithEmail(
      LoginEmailRequest(email: email, password: password),
    );
    state = result.when(
      success: (_) => const AuthState.success(),
      failure: AuthState.failure,
    );
  }

  /// Google login  →  POST /auth/google-login
  Future<void> withGoogle(String token) async {
    state = const AuthState.loading();
    final result = await _repo.loginWithGoogle(
      GoogleLoginRequest(token: token),
    );
    state = result.when(
      success: (_) => const AuthState.success(),
      failure: AuthState.failure,
    );
  }

  void reset() => state = const AuthState.initial();
}

// ── Signup ────────────────────────────────────────────────────────────────────

@riverpod
class SignupNotifier extends _$SignupNotifier {
  @override
  AuthState build() => const AuthState.initial();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  /// Register a new user  →  POST /users
  Future<void> signup({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
    Map<String, dynamic>? location,
    AppRole? role,
  }) async {
    state = const AuthState.loading();
    final result = await _repo.signup(
      SignupRequest(
        name: name,
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        location: location,
        role: AppRole.provider == role ? "service_provider" : null,
      ),
    );
    state = result.when(
      success: (_) => const AuthState.success(),
      failure: AuthState.failure,
    );
  }

  void reset() => state = const AuthState.initial();
}

// ── OTP Verify ────────────────────────────────────────────────────────────────

@riverpod
class OtpVerifyNotifier extends _$OtpVerifyNotifier {
  @override
  AuthState build() => const AuthState.initial();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  /// Verify OTP  →  POST /otp/verify-otp
  Future<void> verifyOtp(String otp) async {
    state = const AuthState.loading();
    final result = await _repo.verifyOtp(VerifyOtpRequest(otp: otp));
    state = result.when(
      success: (_) => const AuthState.success(),
      failure: AuthState.failure,
    );
  }

  void reset() => state = const AuthState.initial();
}

// ── Resend OTP ────────────────────────────────────────────────────────────────

@riverpod
class ResendOtpNotifier extends _$ResendOtpNotifier {
  @override
  AuthState build() => const AuthState.initial();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  /// Resend OTP  →  POST /otp/resend-otp
  Future<void> resendOtp(String email) async {
    state = const AuthState.loading();
    final result = await _repo.resendOtp(ResendOtpRequest(email: email));
    state = result.when(
      success: (_) => const AuthState.success(),
      failure: AuthState.failure,
    );
  }

  void reset() => state = const AuthState.initial();
}

// ── Forgot Password ───────────────────────────────────────────────────────────

@riverpod
class ForgotPasswordNotifier extends _$ForgotPasswordNotifier {
  @override
  AuthState build() => const AuthState.initial();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  /// Send reset email  →  PATCH /auth/forgot-password
  Future<void> forgotPassword(String email) async {
    state = const AuthState.loading();
    final result = await _repo.forgotPassword(
      ForgotPasswordRequest(email: email),
    );
    state = result.when(
      success: (_) => const AuthState.success(),
      failure: AuthState.failure,
    );
  }

  void reset() => state = const AuthState.initial();
}

// ── Reset Password ────────────────────────────────────────────────────────────

@riverpod
class ResetPasswordNotifier extends _$ResetPasswordNotifier {
  @override
  AuthState build() => const AuthState.initial();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  /// Reset password  →  PATCH /auth/reset-password
  Future<void> resetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = const AuthState.loading();
    final result = await _repo.resetPassword(
      ResetPasswordRequest(
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ),
    );
    state = result.when(
      success: (_) => const AuthState.success(),
      failure: AuthState.failure,
    );
  }

  void reset() => state = const AuthState.initial();
}

// ── Change Password ───────────────────────────────────────────────────────────

@riverpod
class ChangePasswordNotifier extends _$ChangePasswordNotifier {
  @override
  AuthState build() => const AuthState.initial();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  /// Change password  →  PATCH /auth/change-password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = const AuthState.loading();
    final result = await _repo.changePassword(
      ChangePasswordRequest(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ),
    );
    state = result.when(
      success: (_) => const AuthState.success(),
      failure: AuthState.failure,
    );
  }

  void reset() => state = const AuthState.initial();
}

// ── Logout ────────────────────────────────────────────────────────────────────

@riverpod
class LogoutNotifier extends _$LogoutNotifier {
  @override
  AuthState build() => const AuthState.initial();

  Future<void> logout() async {
    state = const AuthState.loading();
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState.initial();
  }
}
