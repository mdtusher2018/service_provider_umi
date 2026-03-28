import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/service_models.dart';

abstract class ServiceRemoteDataSource {
  Future<List<ServiceModel>> getAllCategories();
  Future<ServiceModel> getServiceById(String id);

  // Admin only
  Future<ServiceModel> createService(
    CreateServiceRequest data,
    String? imagePath,
  );
  Future<ServiceModel> updateService(
    String id,
    UpdateServiceRequest data,
    String? imagePath,
  );
  Future<void> deleteService(String id);
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final Dio _dio;

  ServiceRemoteDataSourceImpl({required Dio apiService}) : _dio = apiService;

  // ── GET /categories ─────────────────────────────────────────────────────────
  @override
  Future<List<ServiceModel>> getAllCategories() async {
    final response = await _dio.get(ApiEndpoints.services);
    log(response.data.toString() + "========>>>>>>>>>>>>");
    final apiResponse = ApiResponse<List<ServiceModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => (data as List)
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (!apiResponse.success) {
      throw Exception(
        apiResponse.error?.message ?? 'Failed to fetch categories',
      );
    }
    return apiResponse.data ?? [];
  }

  // ── GET /categories/:id ─────────────────────────────────────────────────────
  @override
  Future<ServiceModel> getServiceById(String id) async {
    final url = ApiEndpoints.serviceById.replaceFirst('{id}', id);
    final response = await _dio.get(url);
    return _parse(response, ServiceModel.fromJson);
  }

  // ── POST /categories (admin, bearer + multipart) ────────────────────────────
  @override
  Future<ServiceModel> createService(
    CreateServiceRequest data,
    String? imagePath,
  ) async {
    final formData = FormData.fromMap({
      'data': data.toJson().toString(),
      if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
    });
    final response = await _dio.post(ApiEndpoints.services, data: formData);
    return _parse(response, ServiceModel.fromJson);
  }

  // ── PATCH /categories/:id (admin, bearer + multipart) ───────────────────────
  @override
  Future<ServiceModel> updateService(
    String id,
    UpdateServiceRequest data,
    String? imagePath,
  ) async {
    final url = ApiEndpoints.serviceById.replaceFirst('{id}', id);
    final formData = FormData.fromMap({
      'data': data.toJson().toString(),
      if (imagePath != null) 'image': await MultipartFile.fromFile(imagePath),
    });
    final response = await _dio.patch(url, data: formData);
    return _parse(response, ServiceModel.fromJson);
  }

  // ── DELETE /categories/:id (admin, bearer) ───────────────────────────────────
  @override
  Future<void> deleteService(String id) async {
    final url = ApiEndpoints.serviceById.replaceFirst('{id}', id);
    await _dio.delete(url);
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

// ── Contents ──────────────────────────────────────────────────────────────────

abstract class ContentRemoteDataSource {
  Future<List<ContentItem>> getContents();
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final Dio _dio;

  ContentRemoteDataSourceImpl({required Dio apiService}) : _dio = apiService;

  // ── GET /contents ────────────────────────────────────────────────────────────
  @override
  Future<List<ContentItem>> getContents() async {
    final response = await _dio.get(ApiEndpoints.contents);
    final apiResponse = ApiResponse<List<ContentItem>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => (data as List)
          .map((e) => ContentItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (!apiResponse.success) {
      throw Exception(apiResponse.error?.message ?? 'Failed to fetch contents');
    }
    return apiResponse.data ?? [];
  }
}
