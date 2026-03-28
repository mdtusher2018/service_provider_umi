import 'package:service_provider_umi/core/base/repository.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/core/services/storage/local_storage_service.dart';
import 'package:service_provider_umi/core/services/storage/storage_key.dart';
import 'package:service_provider_umi/data/data_source/remote/auth_remote_data_source.dart';
import 'package:service_provider_umi/data/models/auth_models.dart';

class AuthRepository with SafeCall {
  final AuthRemoteDataSource _remote;
  final LocalStorageService _local;

  AuthRepository({
    required AuthRemoteDataSource remote,
    required LocalStorageService local,
  }) : _remote = remote,
       _local = local;

  // ── POST /auth/login ─────────────────────────────────────────────────────────
  Future<Result<SignInResponse, Failure>> loginWithEmail(
    LoginEmailRequest request,
  ) async {
    final result = await asyncGuard(() => _remote.loginWithEmail(request));
    return result.when(
      success: (tokens) async {
        await _saveTokens(tokens.token, refreshToken: tokens.refreshToken);
        return Success(tokens);
      },
      failure: (f) async => Error(f),
    );
  }

  // ── POST /auth/google-login ──────────────────────────────────────────────────
  Future<Result<SignInResponse, Failure>> loginWithGoogle(
    GoogleLoginRequest request,
  ) async {
    final result = await asyncGuard(() => _remote.loginWithGoogle(request));
    return result.when(
      success: (data) async {
        await _saveTokens(data.token);
        return Success(data);
      },
      failure: (f) async => Error(f),
    );
  }

  // ── POST /users ──────────────────────────────────────────────────────────────
  Future<Result<SignUpOtpTokenResponse, Failure>> signup(
    SignupRequest request,
  ) async {
    final result = await asyncGuard(() => _remote.signup(request));
    return result.when(
      success: (otpResp) async {
        // Store the short-lived OTP token so the interceptor / verify call
        // can attach it as a bearer token.
        await _local.write(StorageKey.accessToken, otpResp.token);
        return Success(otpResp);
      },
      failure: (f) async => Error(f),
    );
  }

  // ── POST /otp/verify-otp ─────────────────────────────────────────────────────
  Future<Result<OtpVerifedResponse, Failure>> verifyOtp(
    VerifyOtpRequest request,
  ) async {
    final result = await asyncGuard(() => _remote.verifyOtp(request));
    return result.when(
      success: (data) async {
        await _saveTokens(data.token);
        return Success(data);
      },
      failure: (f) async => Error(f),
    );
  }

  // ── POST /otp/resend-otp ─────────────────────────────────────────────────────
  Future<Result<ResendOtpTokenResponse, Failure>> resendOtp(
    ResendOtpRequest request,
  ) async {
    final result = await asyncGuard(() => _remote.resendOtp(request));
    return result.when(
      success: (data) async {
        await _saveTokens(data.token);
        return Success(data);
      },
      failure: (f) async => Error(f),
    );
  }

  // ── PATCH /auth/forgot-password ──────────────────────────────────────────────
  Future<Result<ForgotPasswordOtpTokenResponse, Failure>> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    final result = await asyncGuard(() => _remote.forgotPassword(request));
    return result.when(
      success: (data) async {
        await _saveTokens(data.token);
        return Success(data);
      },
      failure: (f) async => Error(f),
    );
  }

  // ── PATCH /auth/reset-password ───────────────────────────────────────────────
  Future<Result<void, Failure>> resetPassword(ResetPasswordRequest request) =>
      asyncGuard(() => _remote.resetPassword(request));

  // ── PATCH /auth/change-password ──────────────────────────────────────────────
  Future<Result<void, Failure>> changePassword(ChangePasswordRequest request) =>
      asyncGuard(() => _remote.changePassword(request));

  // ── Local helpers ────────────────────────────────────────────────────────────
  Future<bool> isLoggedIn() async {
    final token = await _local.read<String>(StorageKey.accessToken);
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async => _local.clearAll();

  Future<void> _saveTokens(String accessToken, {String? refreshToken}) async {
    await _local.write(StorageKey.accessToken, accessToken);

    await _local.write(StorageKey.refreshToken, refreshToken);
  }
}
