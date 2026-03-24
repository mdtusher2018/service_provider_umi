import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/auth_models.dart';

abstract class AuthRemoteDataSource {
  Future<String> loginWithEmail(String email, String password);
  Future<String> loginWithGoogle(String email, {String? role});
  Future<String> loginWithApple(String appleId, {String? role});
  Future<String> signup(SignupRequest request);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl({required Dio apiService}) : _dio = apiService;

  @override
  Future<String> loginWithEmail(String email, String password) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    return _extractToken(response);
  }

  @override
  Future<String> loginWithGoogle(String email, {String? role}) async {
    final response = await _dio.post(
      ApiEndpoints.socialLogin,
      data: {'email': email, 'role': ?role},
    );
    return _extractToken(response);
  }

  @override
  Future<String> loginWithApple(String appleId, {String? role}) async {
    final response = await _dio.post(
      ApiEndpoints.socialLogin,
      data: {'appleId': appleId, if (role != null) 'role': role},
    );
    return _extractToken(response);
  }

  @override
  Future<String> signup(SignupRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.register,
      data: request.toJson(),
    );
    return _extractToken(response);
  }

  @override
  Future<void> logout() async {
    await _dio.post(ApiEndpoints.logout);
  }

  String _extractToken(Response response) {
    final token = response.data?['data']?['token'] as String?;
    if (token == null || token.isEmpty) {
      throw Exception(response.data?['error']?['message'] ?? 'Login failed');
    }
    return token;
  }
}
