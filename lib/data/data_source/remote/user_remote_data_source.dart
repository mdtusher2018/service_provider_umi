import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/user_models.dart';

abstract class UserRemoteDataSource {
  Future<UserProfile> getUserById(String id);
  Future<UserProfile> getMyProfile();
  Future<UserProfile> updateMyProfile(
      UpdateProfileRequest data, String? profileImagePath);
  Future<void> deleteMyAccount();

  // Admin only
  Future<UserProfile> adminUpdateUser(
      String id, UpdateProfileRequest data, String? profileImagePath);
  Future<void> adminDeleteUser(String id);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSourceImpl({required Dio apiService}) : _dio = apiService;

  // ── GET /users/:id ───────────────────────────────────────────────────────────
  @override
  Future<UserProfile> getUserById(String id) async {
    final url = ApiEndpoints.getUserById.replaceFirst('{id}', id);
    final response = await _dio.get(url);
    return _parse(response, UserProfile.fromJson);
  }

  // ── GET /users/my-profile (bearer) ──────────────────────────────────────────
  @override
  Future<UserProfile> getMyProfile() async {
    final response = await _dio.get(ApiEndpoints.myProfile);
    return _parse(response, UserProfile.fromJson);
  }

  // ── PATCH /users/update-my-profile (bearer + multipart) ─────────────────────
  @override
  Future<UserProfile> updateMyProfile(
      UpdateProfileRequest data, String? profileImagePath) async {
    final formData = await _buildUpdateFormData(data, profileImagePath);
    final response =
        await _dio.patch(ApiEndpoints.updateMyProfile, data: formData);
    return _parse(response, UserProfile.fromJson);
  }

  // ── DELETE /users/delete-my-account (bearer) ─────────────────────────────────
  @override
  Future<void> deleteMyAccount() async {
    await _dio.delete(ApiEndpoints.deleteMyAccount);
  }

  // ── PATCH /users/:id (admin, bearer + multipart) ─────────────────────────────
  @override
  Future<UserProfile> adminUpdateUser(
      String id, UpdateProfileRequest data, String? profileImagePath) async {
    final url = ApiEndpoints.adminUpdateUser.replaceFirst('{id}', id);
    final formData = await _buildUpdateFormData(data, profileImagePath);
    final response = await _dio.patch(url, data: formData);
    return _parse(response, UserProfile.fromJson);
  }

  // ── DELETE /users/:id (admin, bearer) ────────────────────────────────────────
  @override
  Future<void> adminDeleteUser(String id) async {
    final url = ApiEndpoints.adminDeleteUser.replaceFirst('{id}', id);
    await _dio.delete(url);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────
  Future<FormData> _buildUpdateFormData(
      UpdateProfileRequest data, String? profileImagePath) async {
    final formMap = <String, dynamic>{
      'data': data.toJson().toString(), // JSON string in 'data' field
    };
    if (profileImagePath != null) {
      formMap['profile'] = await MultipartFile.fromFile(profileImagePath);
    }
    return FormData.fromMap(formMap);
  }

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
