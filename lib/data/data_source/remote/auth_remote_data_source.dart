import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<SignInResponse> loginWithEmail(LoginEmailRequest request);
  Future<SignInResponse> loginWithGoogle(GoogleLoginRequest request);
  Future<SignUpOtpTokenResponse> signup(SignupRequest request);
  Future<OtpVerifedResponse> verifyOtp(VerifyOtpRequest request);
  Future<ResendOtpTokenResponse> resendOtp(ResendOtpRequest request);
  Future<ForgotPasswordOtpTokenResponse> forgotPassword(
    ForgotPasswordRequest request,
  );
  Future<void> resetPassword(ResetPasswordRequest request);
  Future<void> changePassword(ChangePasswordRequest request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl({required Dio apiService}) : _dio = apiService;

  // ── POST /auth/login ─────────────────────────────────────────────────────────
  @override
  Future<SignInResponse> loginWithEmail(LoginEmailRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );
    return _parse(response, SignInResponse.fromJson);
  }

  // ── POST /auth/google-login ──────────────────────────────────────────────────
  @override
  Future<SignInResponse> loginWithGoogle(GoogleLoginRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.googleLogin,
      data: request.toJson(),
    );
    return _parse(response, SignInResponse.fromJson);
  }

  // ── POST /users (register) ───────────────────────────────────────────────────
  @override
  Future<SignUpOtpTokenResponse> signup(SignupRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.register,
      data: request.toJson(),
    );
    return _parse(response, SignUpOtpTokenResponse.fromJson);
  }

  // ── POST /otp/verify-otp ─────────────────────────────────────────────────────
  @override
  Future<OtpVerifedResponse> verifyOtp(VerifyOtpRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.verifyOtp,
      data: request.toJson(),
    );
    return _parse(response, OtpVerifedResponse.fromJson);
  }

  // ── POST /otp/resend-otp ─────────────────────────────────────────────────────
  @override
  Future<ResendOtpTokenResponse> resendOtp(ResendOtpRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.resendOtp,
      data: request.toJson(),
    );

    return _parse(response, ResendOtpTokenResponse.fromJson);
  }

  // ── PATCH /auth/forgot-password ──────────────────────────────────────────────
  @override
  Future<ForgotPasswordOtpTokenResponse> forgotPassword(
    ForgotPasswordRequest request,
  ) async {
    final response = await _dio.patch(
      ApiEndpoints.forgotPassword,
      data: request.toJson(),
    );

    return _parse(response, ForgotPasswordOtpTokenResponse.fromJson);
  }

  // ── PATCH /auth/reset-password ───────────────────────────────────────────────
  @override
  Future<void> resetPassword(ResetPasswordRequest request) async {
    await _dio.patch(ApiEndpoints.resetPassword, data: request.toJson());
  }

  // ── PATCH /auth/change-password (requires bearer token) ─────────────────────
  @override
  Future<void> changePassword(ChangePasswordRequest request) async {
    await _dio.patch(ApiEndpoints.changePassword, data: request.toJson());
  }

  // ── Helper ───────────────────────────────────────────────────────────────────
  T _parse<T>(Response response, T Function(Map<String, dynamic>) fromJson) {
    final apiResponse = ApiResponse<T>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => fromJson(data as Map<String, dynamic>),
    );
    if (!apiResponse.success) {
      throw Exception(
        apiResponse.error?.message ?? apiResponse.message ?? 'Request failed',
      );
    }
    if (apiResponse.data == null) throw Exception('Empty response data');
    return apiResponse.data as T;
  }
}
