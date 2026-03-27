// data/data_source/remote/service_remote_data_source.dart

import 'package:dio/dio.dart';
import 'package:service_provider_umi/data/models/service_models.dart';

abstract class ServiceRemoteDataSource {
  Future<HomeServicesResponse> getHomeServices();
  Future<AllServicesResponse> getAllServices();
  Future<AllServicesResponse> getSubCategories(String serviceType);
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final Dio _dio;

  ServiceRemoteDataSourceImpl({required Dio apiService}) : _dio = apiService;

  @override
  Future<HomeServicesResponse> getHomeServices() async {
    final response = await _dio.get('/home/services');
    return HomeServicesResponse.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<AllServicesResponse> getAllServices() async {
    final response = await _dio.get('/services');
    return AllServicesResponse.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<AllServicesResponse> getSubCategories(String serviceType) async {
    final response = await _dio.get(
      '/services',
      queryParameters: {'service_type': serviceType},
    );
    return AllServicesResponse.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }
}
