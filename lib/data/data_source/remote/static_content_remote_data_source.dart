import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/static_content_model.dart';

abstract class StaticContentRemoteDataSource {
  /// Fetches the full static content object (terms, privacy, refund, etc.)
  Future<StaticContentItem> getStaticContents();
}

class StaticContentRemoteDataSourceImpl
    implements StaticContentRemoteDataSource {
  final Dio _dio;

  StaticContentRemoteDataSourceImpl({required Dio apiService})
    : _dio = apiService;

  // ── GET /contents ─────────────────────────────────────────────────────────────
  // Returns a single object (not a list) — see API response in Postman.
  @override
  Future<StaticContentItem> getStaticContents() async {
    final response = await _dio.get(ApiEndpoints.contents);
    final apiResponse = ApiResponse<StaticContentItem>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => StaticContentItem.fromJson(data as Map<String, dynamic>),
    );
    if (!apiResponse.success) {
      throw Exception(apiResponse.error?.message ?? 'Failed to fetch contents');
    }
    if (apiResponse.data == null) throw Exception('Empty content response');
    return apiResponse.data!;
  }
}
