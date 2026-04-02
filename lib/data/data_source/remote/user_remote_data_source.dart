import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/user_models.dart';

abstract class UserRemoteDataSource {
  Future<UserProfile> getUserById(String id);
  Future<UserProfile> getMyProfile();
  Future<UserProfile> updateMyProfile(UpdateProfileRequest data);
  Future<void> deleteMyAccount();
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
  Future<UserProfile> updateMyProfile(UpdateProfileRequest data) async {
    final formData = await _buildUpdateFormData(data);
    final response = await _dio.patch(
      ApiEndpoints.updateMyProfile,
      data: formData,
    );
    return _parse(response, UserProfile.fromJson);
  }

  // ── DELETE /users/delete-my-account (bearer) ─────────────────────────────────
  @override
  Future<void> deleteMyAccount() async {
    await _dio.delete(ApiEndpoints.deleteMyAccount);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────
  Future<FormData> _buildUpdateFormData(UpdateProfileRequest data) async {
    // ✅ FIX: Flatten the fields directly into the FormData map instead of
    // nesting them under a 'data' key as a Map object. Passing a raw Map as
    // a multipart field value causes "Cannot convert object to primitive value"
    // on the server. Each key-value pair must be a primitive (String, num, bool).
    //
    // If your server expects a single JSON string field instead of flat fields,
    // replace the line below with: final formMap = {'data': jsonEncode(data.toJson())};
    final formMap = Map<String, dynamic>.from(data.toJson());

    if (data.profileImage != null) {
      formMap['profile'] = await MultipartFile.fromFile(
        data.profileImage!.path,
      );
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
