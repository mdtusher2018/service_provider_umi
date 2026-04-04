import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/data/models/misc_models.dart';
import 'package:service_provider_umi/data/models/mock_service_provider_models.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';

import 'package:service_provider_umi/data/models/service_models.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';

abstract class ServiceRemoteDataSource {
  // ── Categories ──────────────────────────────────────────────────────────────
  Future<List<ServiceModel>> getAllCategories();
  Future<ServiceModel> getServiceById(String id);
  Future<List<ServiceModel>> getSubCategories(String serviceId);

  // ── Providers ───────────────────────────────────────────────────────────────
  Future<SearchProvidersResponse> searchProviders(
    SearchProvidersRequest request,
  );
  Future<ServiceFiltersModel> getFilters(String serviceType);
  Future<ProviderProfile> getProviderProfile(String providerId);

  // ── Bookings ─────────────────────────────────────────────────────────────────
  Future<void> createBooking(CreateBookingRequest request);
  Future<BookingsListResponse> getMyBookings({
    BookingStatus? status,
    int page = 1,
    int limit = 10,
  });
  Future<BookingDetails> getBookingDetail(String bookingId);

  // ── FAQs ────────────────────────────────────────────────────────────────────
  Future<List<FaqItem>> getFaqs(String serviceType);
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

  // ── GET /categories/:id/subcategories ───────────────────────────────────────
  @override
  Future<List<ServiceModel>> getSubCategories(String serviceId) async {
    final url = ApiEndpoints.subCategories.replaceFirst('{id}', serviceId);
    final response = await _dio.get(url);
    final apiResponse = ApiResponse<List<ServiceModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) {
        final list = data is List ? data : (data['data'] as List);
        return list
            .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
    if (!apiResponse.success) {
      throw Exception(
        apiResponse.error?.message ?? 'Failed to fetch subcategories',
      );
    }
    return apiResponse.data ?? [];
  }

  // ── POST /service-providers/search ──────────────────────────────────────────
  @override
  Future<SearchProvidersResponse> searchProviders(
    SearchProvidersRequest request,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.searchProviders,
      data: request.toJson(),
    );
    return _parse(response, SearchProvidersResponse.fromJson);
  }

  // ── GET /service-providers/filters?service_type=X ───────────────────────────
  @override
  Future<ServiceFiltersModel> getFilters(String serviceType) async {
    final response = await _dio.get(
      ApiEndpoints.serviceFilters,
      queryParameters: {'service_type': serviceType},
    );
    return _parse(response, ServiceFiltersModel.fromJson);
  }

  // ── GET /service-providers/:id ───────────────────────────────────────────────
  @override
  Future<ProviderProfile> getProviderProfile(String providerId) async {
    final url = ApiEndpoints.providerProfile.replaceFirst('{id}', providerId);
    final response = await _dio.get(url);
    return _parse(response, ProviderProfile.fromJson);
  }

  // ── POST /bookings ───────────────────────────────────────────────────────────
  @override
  Future<void> createBooking(CreateBookingRequest request) async {
    await _dio.post(ApiEndpoints.createBooking, data: request.toJson());
  }

  // ── GET /bookings/my-bookings ────────────────────────────────────────────────
  @override
  Future<BookingsListResponse> getMyBookings({
    BookingStatus? status,
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.myBookings,
      queryParameters: {
        'page': page,
        'limit': limit,
        if (status != null) 'status': status.apiValue,
      },
    );
    return _parse(response, BookingsListResponse.fromJson);
  }

  // ── GET /bookings/:id ────────────────────────────────────────────────────────
  @override
  Future<BookingDetails> getBookingDetail(String bookingId) async {
    final url = ApiEndpoints.bookingDetail.replaceFirst('{id}', bookingId);
    final response = await _dio.get(url);
    return _parse(response, BookingDetails.fromJson);
  }

  // ── GET /faqs?service_type=X ─────────────────────────────────────────────────
  @override
  Future<List<FaqItem>> getFaqs(String serviceType) async {
    final response = await _dio.get(
      ApiEndpoints.faqs,
      queryParameters: {'service_type': serviceType},
    );
    final apiResponse = ApiResponse<List<FaqItem>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) {
        final list = data is List ? data : (data['data'] as List);
        return list
            .map((e) => FaqItem.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
    if (!apiResponse.success) {
      throw Exception(apiResponse.error?.message ?? 'Failed to fetch FAQs');
    }
    return apiResponse.data ?? [];
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
