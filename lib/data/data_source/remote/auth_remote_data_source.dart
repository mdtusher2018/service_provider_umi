import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<String> loginWithEmail(LoginEmailRequest request);
  Future<String> loginWithGoogle(LoginGoogleRequest request);
  Future<String> loginWithApple(LoginAppleRequest request);
  Future<String> signup(SignupRequest request);
  Future<String> verifyOtp(String request);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl({required Dio apiService}) : _dio = apiService;

  @override
  Future<String> loginWithEmail(LoginEmailRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'email': request.email, 'password': request.password},
    );
    return _extractToken<SignInResponse>(response, (data) {
      return SignInResponse.fromJson((data ?? {}) as Map<String, dynamic>);
    });
  }

  @override
  Future<String> loginWithGoogle(LoginGoogleRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.socialLogin,
      data: {'email': request.email, 'role': ?request.role},
    );
    return _extractToken<SignInResponse>(response, (data) {
      return SignInResponse.fromJson((data ?? {}) as Map<String, dynamic>);
    });
  }

  @override
  Future<String> loginWithApple(LoginAppleRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.socialLogin,
      data: {'appleId': request.appleId, 'role': ?request.role},
    );
    return _extractToken<SignInResponse>(response, (data) {
      return SignInResponse.fromJson((data ?? {}) as Map<String, dynamic>);
    });
  }

  @override
  Future<String> signup(SignupRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.register,
      data: request.toJson(),
    );
    return _extractToken<SignupResponse>(response, (data) {
      return SignupResponse.fromJson((data ?? {}) as Map<String, dynamic>);
    });
  }

  @override
  Future<String> verifyOtp(String request) async {
    final response = await _dio.post(
      ApiEndpoints.verifyOtp,
      data: {'otp': request},
    );
    return _extractToken<SignupResponse>(response, (data) {
      return SignupResponse.fromJson((data ?? {}) as Map<String, dynamic>);
    });
  }

  @override
  Future<void> logout() async {
    await _dio.post(ApiEndpoints.logout);
  }

  String _extractToken<T>(Response response, Function(dynamic) dataCasting) {
    final apiResponse = ApiResponse<T>.fromJson(
      response.data,
      (data) => dataCasting(data),
    );

    if (!apiResponse.success) {
      throw Exception(
        apiResponse.error?.message ?? apiResponse.message ?? 'Login failed',
      );
    }

    // Assuming the token is always in the data model
    final token = (apiResponse.data as dynamic).token;

    if (token == null || token.isEmpty) {
      throw Exception('Token not found in response');
    }

    return token;
  }
}
