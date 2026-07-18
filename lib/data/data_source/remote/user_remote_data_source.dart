import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/auth_models.dart';
import 'package:service_provider_umi/data/models/favorites_model.dart';
import 'package:service_provider_umi/data/models/mock_misc_models.dart';
import 'package:service_provider_umi/data/models/user_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/verification_provider.dart';

abstract class UserRemoteDataSource {
  Future<UserProfile> getUserById(String id);
  Future<UserProfile> getMyProfile();
  Future<UserProfile> updateMyProfile(UpdateProfileRequest data);
  Future<void> deleteMyAccount();

  // ── Password ───────────────────────────────────────────────────────────────
  Future<void> changePassword(ChangePasswordRequest request);

  // ── Favorites ──────────────────────────────────────────────────────────────
  Future<List<FavoriteModel>> getFavorites({int page = 1, int limit = 10});
  Future<void> toggleFavorite({required String id});

  // ── Support ────────────────────────────────────────────────────────────────
  Future<SupportResponse> getSupport();
  Future<String> getStripeConnetedUrl();
  Future<bool> submitVerification(VerificationRequest request);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final Dio _dio;

  UserRemoteDataSourceImpl({required Dio apiService}) : _dio = apiService;

  // ── GET /users/:id ─────────────────────────────────────────────────────────
  @override
  Future<UserProfile> getUserById(String id) async {
    final url = ApiEndpoints.getUserById(id);
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

  // ── PATCH /auth/change-password ────────────────────────────────────────────
  @override
  Future<void> changePassword(ChangePasswordRequest request) async {
    await _dio.patch(ApiEndpoints.changePassword, data: request.toJson());
  }

  // ── GET /users/favorites ───────────────────────────────────────────────────
  @override
  Future<List<FavoriteModel>> getFavorites({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.favorites,
      queryParameters: {
        'page': page,
        'limit': limit,
        "include": "serviceProvider,user",
      },
    );
    final apiResponse = ApiResponse<List<FavoriteModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) {
        final list = (data as Map<String, dynamic>)['data'] as List;
        return list
            .map((e) => FavoriteModel.fromJson(e as Map<String, dynamic>))
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

  @override
  Future<void> toggleFavorite({required String id}) async {
    await _dio.post(ApiEndpoints.favorites, data: {"serviceProviderId": id});
  }

  // ── GET /support ───────────────────────────────────────────────────────────
  @override
  Future<SupportResponse> getSupport() async {
    final response = await _dio.get(ApiEndpoints.support);
    return _parse(response, SupportResponse.fromJson);
  }

  @override
  Future<String> getStripeConnetedUrl() async {
    final url = ApiEndpoints.stripeConnect;
    final response = await _dio.patch(url);

    return response.data['data'] ?? "";
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

  // Add to UserRemoteDataSourceImpl:
  @override
  Future<bool> submitVerification(VerificationRequest request) async {
    final formMap = <String, dynamic>{};
    final List<MultipartFile> images = [];

    if (request.palliativeCare != null) {
      images.add(
        await MultipartFile.fromFile(
          request.palliativeCare!.path,
          filename: 'palliative_care.jpg',
        ),
      );
    }
    if (request.drivingLicense != null) {
      images.add(
        await MultipartFile.fromFile(
          request.drivingLicense!.path,
          filename: 'driving_license.jpg',
        ),
      );
    }
    if (request.businessProfilesOnly != null) {
      images.add(
        await MultipartFile.fromFile(
          request.businessProfilesOnly!.path,
          filename: 'business_profile.jpg',
        ),
      );
    }
    if (request.qualifiedOnly != null) {
      images.add(
        await MultipartFile.fromFile(
          request.qualifiedOnly!.path,
          filename: 'qualified_carer.jpg',
        ),
      );
    }

    formMap['data'] = jsonEncode({});
    formMap['images'] = images;

    final response = await _dio.post(
      ApiEndpoints.profileVerificationSubmit,
      data: FormData.fromMap(formMap),
    );

    final apiResponse = ApiResponse<bool>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => true,
    );

    if (!apiResponse.success) {
      throw Exception(
        apiResponse.error?.message ?? 'Verification submission failed',
      );
    }
    return true;
  }
}
