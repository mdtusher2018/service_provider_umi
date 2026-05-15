import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/api_response.dart';

abstract class ChatRemoteDataSource {
  Future<String> getChatId({required String reciverId});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final Dio _dio;

  ChatRemoteDataSourceImpl({required Dio apiService}) : _dio = apiService;

  // ── GET / Chat Id ─────────────────────────────────────────────────────────
  @override
  Future<String> getChatId({required String reciverId}) async {
    final response = await _dio.get(ApiEndpoints.getChatId(reciverId));
    final apiResponse = ApiResponse.fromJson(response.data, (p0) {
      return p0['id'] ?? "";
    });
    return apiResponse.data;
  }
}
