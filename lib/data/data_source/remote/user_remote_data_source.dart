import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/address_model.dart';
import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/auth_models.dart';
import 'package:service_provider_umi/data/models/misc_models.dart';
import 'package:service_provider_umi/data/models/search_models.dart';
import 'package:service_provider_umi/data/models/user_models.dart';

abstract class UserRemoteDataSource {
  Future<UserProfile> getUserById(String id);
  Future<UserProfile> getMyProfile();
  Future<UserProfile> updateMyProfile(UpdateProfileRequest data);
  Future<void> deleteMyAccount();

  // ── Addresses ──────────────────────────────────────────────────────────────
  Future<List<AddressModel>> getSavedAddresses();
  Future<void> addAddress({
    required String name,
    required String address,
    required LatLng coordinates,
  });

  // ── Password ───────────────────────────────────────────────────────────────
  Future<void> changePassword(ChangePasswordRequest request);

  // ── Favorites ──────────────────────────────────────────────────────────────
  Future<List<ProviderSearchResult>> getFavorites({
    int page = 1,
    int limit = 10,
  });

  // ── Support ────────────────────────────────────────────────────────────────
  Future<SupportResponse> getSupport();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSourceImpl({required Dio apiService}) : _dio = apiService;

  // ── GET /users/:id ─────────────────────────────────────────────────────────
  @override
  Future<UserProfile> getUserById(String id) async {
    final url = ApiEndpoints.getUserById.replaceFirst('{id}', id);
    final response = await _dio.get(url);
    return _parse(response, UserProfile.fromJson);
  }

  // ── GET /users/my-profile ──────────────────────────────────────────────────
  @override
  Future<UserProfile> getMyProfile() async {
    final response = await _dio.get(ApiEndpoints.myProfile);
    return _parse(response, UserProfile.fromJson);
  }

  // ── PATCH /users/update-my-profile (multipart) ────────────────────────────
  @override
  Future<UserProfile> updateMyProfile(UpdateProfileRequest data) async {
    final formData = await _buildUpdateFormData(data);
    final response = await _dio.patch(
      ApiEndpoints.updateMyProfile,
      data: formData,
    );
    return _parse(response, UserProfile.fromJson);
  }

  // ── DELETE /users/delete-my-account ───────────────────────────────────────
  @override
  Future<void> deleteMyAccount() async {
    await _dio.delete(ApiEndpoints.deleteMyAccount);
  }

  // ── GET /users/addresses ───────────────────────────────────────────────────
  @override
  Future<List<AddressModel>> getSavedAddresses() async {
    final response = await _dio.get(ApiEndpoints.savedAddresses);
    final apiResponse = ApiResponse<List<AddressModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => (data as List)
          .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (!apiResponse.success) {
      throw Exception(
        apiResponse.error?.message ?? 'Failed to fetch addresses',
      );
    }
    return apiResponse.data ?? [];
  }

  // ── POST /users/addresses ──────────────────────────────────────────────────
  @override
  Future<void> addAddress({
    required String name,
    required String address,
    required LatLng coordinates,
  }) async {
    await _dio.post(
      ApiEndpoints.addAddress,
      data: {
        'name': name,
        'address': address,
        'lat': coordinates.latitude,
        'lng': coordinates.longitude,
      },
    );
  }

  // ── PATCH /auth/change-password ────────────────────────────────────────────
  @override
  Future<void> changePassword(ChangePasswordRequest request) async {
    await _dio.patch(ApiEndpoints.changePassword, data: request.toJson());
  }

  // ── GET /users/favorites ───────────────────────────────────────────────────
  @override
  Future<List<ProviderSearchResult>> getFavorites({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.favorites,
      queryParameters: {'page': page, 'limit': limit},
    );
    final apiResponse = ApiResponse<List<ProviderSearchResult>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) {
        final list = (data as Map<String, dynamic>)['results'] as List;
        return list
            .map(
              (e) => ProviderSearchResult.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      },
    );
    if (!apiResponse.success) {
      throw Exception(
        apiResponse.error?.message ?? 'Failed to fetch favorites',
      );
    }
    return apiResponse.data ?? [];
  }

  // ── GET /support ───────────────────────────────────────────────────────────
  @override
  Future<SupportResponse> getSupport() async {
    final response = await _dio.get(ApiEndpoints.support);
    return _parse(response, SupportResponse.fromJson);
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  Future<FormData> _buildUpdateFormData(UpdateProfileRequest data) async {
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
