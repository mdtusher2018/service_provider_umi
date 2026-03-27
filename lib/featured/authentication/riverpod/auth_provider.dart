import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/models/auth_models.dart';
import 'package:service_provider_umi/data/repository/auth_repository.dart';

part 'auth_provider.freezed.dart';
part 'auth_provider.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared State (reused by all auth notifiers)
// ─────────────────────────────────────────────────────────────────────────────

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.success(String token) = AuthSuccess;
  const factory AuthState.failure(Failure failure) = AuthFailure;
}

// ─────────────────────────────────────────────────────────────────────────────
// Login Notifier  — email / google / apple
// ─────────────────────────────────────────────────────────────────────────────

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  AuthState build() => const AuthState.initial();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> withEmail(String email, String password) async {
    state = const AuthState.loading();
    final result = await _repo.loginWithEmail(
      LoginEmailRequest(email: email, password: password),
    );
    state = result.when(success: AuthState.success, failure: AuthState.failure);
  }

  Future<void> withGoogle(String email, {String? role}) async {
    state = const AuthState.loading();
    final result = await _repo.loginWithGoogle(
      LoginGoogleRequest(email: email, role: role),
    );
    state = result.when(success: AuthState.success, failure: AuthState.failure);
  }

  Future<void> withApple(String appleId, {String? role}) async {
    state = const AuthState.loading();
    final result = await _repo.loginWithApple(
      LoginAppleRequest(appleId: appleId, role: role),
    );
    state = result.when(success: AuthState.success, failure: AuthState.failure);
  }

  void reset() => state = const AuthState.initial();
}

// ─────────────────────────────────────────────────────────────────────────────
// Signup Notifier
// ─────────────────────────────────────────────────────────────────────────────

@riverpod
class SignupNotifier extends _$SignupNotifier {
  @override
  AuthState build() => const AuthState.initial();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  Future<void> signup({
    required String fullName,
    required String email,
    required String password,
    LatLng? location,
    String? phone,
    String role = 'user',
  }) async {
    state = const AuthState.loading();
    final result = await _repo.signup(
      SignupRequest(
        role: role,
        email: email,
        password: password,
        fullName: fullName,
        location: location,
        phoneNumber: phone,
      ),
    );
    state = result.when(success: AuthState.success, failure: AuthState.failure);
  }

  void reset() => state = const AuthState.initial();
}
// ─────────────────────────────────────────────────────────────────────────────
// OTP Verify Notifier
// ─────────────────────────────────────────────────────────────────────────────

@riverpod
class OtpVerifyNotifier extends _$OtpVerifyNotifier {
  @override
  AuthState build() => const AuthState.initial();

  AuthRepository get _repo => ref.read(authRepositoryProvider);

  // OTP verification function
  Future<void> verifyOtp({required String otp}) async {
    state = const AuthState.loading();

    // Perform the OTP verification via the repository
    final result = await _repo.verifyOtp(otp);

    // Update state based on result
    state = result.when(
      success: AuthState
          .success, // Assuming successful verification leads to success state
      failure: AuthState.failure, // Failure leads to failure state
    );
  }

  // Reset the state to initial when needed
  void reset() => state = const AuthState.initial();
}
// ─────────────────────────────────────────────────────────────────────────────
// Logout Notifier
// ─────────────────────────────────────────────────────────────────────────────

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
