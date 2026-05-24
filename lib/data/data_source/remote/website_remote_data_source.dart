import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/website_models.dart';

abstract class WebsiteRemoteDataSource {
  Future<List<WebsiteServiceModel>> getAllServices();
  Future<List<AboutUsModel>> getAllAboutUs();
}

class WebsiteRemoteDataSourceImpl implements WebsiteRemoteDataSource {
  final Dio _dio;

  WebsiteRemoteDataSourceImpl({required Dio apiService}) : _dio = apiService;

  @override
  Future<List<WebsiteServiceModel>> getAllServices() async {
    final response = await _dio.get(ApiEndpoints.websiteServices);
    final apiResponse = ApiResponse<List<WebsiteServiceModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => (data['data'] as List)
          .map((e) => WebsiteServiceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (!apiResponse.success) {
      throw Exception(
        apiResponse.error?.message ?? 'Failed to fetch categories',
      );
    }
    return apiResponse.data ?? [];
  }

  @override
  Future<List<AboutUsModel>> getAllAboutUs() async {
    final response = await _dio.get(ApiEndpoints.websiteAboutUs);
    final apiResponse = ApiResponse<List<AboutUsModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => (data as List)
          .map((e) => AboutUsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
    if (!apiResponse.success) {
      throw Exception(
        apiResponse.error?.message ?? 'Failed to fetch categories',
      );
    }
    return apiResponse.data ?? [];
  }
}
