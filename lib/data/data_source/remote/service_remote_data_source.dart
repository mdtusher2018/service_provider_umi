import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/data/models/mock_service_provider_models.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';
import 'package:service_provider_umi/data/models/service_models.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';

abstract class ServiceRemoteDataSource {
  Future<List<ServiceModel>> getAllCategories();
  Future<ServiceModel> getServiceById(String id);

  Future<List<ServiceModel>> getSubCategories(String serviceType);

  Future<SearchProvidersResponse> searchProviders(
    SearchProvidersRequest request,
  );

  Future<ServiceFiltersModel> getFilters(String serviceType);

  Future<ProviderProfile> getProviderProfile(String providerId);

  Future<void> createBooking(CreateBookingRequest request);

  Future<BookingsListResponse> getMyBookings({
    BookingStatus? status,
    int page = 1,
    int limit = 10,
  });

  Future<BookingDetails> getBookingDetail(String bookingId);
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final Dio _dio;

  ServiceRemoteDataSourceImpl({required Dio apiService}) : _dio = apiService;

  // ── GET /categories ─────────────────────────────────────────────────────────
  @override
  Future<List<ServiceModel>> getAllCategories() async {
    final response = await _dio.get(ApiEndpoints.services);

    final apiResponse = ApiResponse<List<ServiceModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => (data['data'] as List)
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

  @override
  Future<void> createBooking(CreateBookingRequest request) {
    // TODO: implement createBooking
    throw UnimplementedError();
  }

  @override
  Future<BookingDetails> getBookingDetail(String bookingId) {
    // TODO: implement getBookingDetail
    throw UnimplementedError();
  }

  @override
  getFilters(String serviceType) {
    // TODO: implement getFilters
    throw UnimplementedError();
  }

  @override
  Future<BookingsListResponse> getMyBookings({
    BookingStatus? status,
    int page = 1,
    int limit = 10,
  }) {
    // TODO: implement getMyBookings
    throw UnimplementedError();
  }

  @override
  Future<ProviderProfile> getProviderProfile(String providerId) {
    // TODO: implement getProviderProfile
    throw UnimplementedError();
  }

  @override
  Future<List<ServiceModel>> getSubCategories(String serviceType) {
    // TODO: implement getSubCategories
    throw UnimplementedError();
  }

  @override
  searchProviders(request) {
    // TODO: implement searchProviders
    throw UnimplementedError();
  }
}
