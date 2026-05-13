import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/data/models/faq_model.dart';
import 'package:service_provider_umi/data/models/mock_service_provider_models.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';

import 'package:service_provider_umi/data/models/service_models.dart';
import 'package:service_provider_umi/data/models/user_models.dart';
import 'package:service_provider_umi/data/models/work_schedule_model.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
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
  Future<ServiceFiltersModel> getFilters();
  Future<UserProfile> getProviderProfile(String providerId);
  Future<List<ProviderComment>> getProviderReviews(String providerId);

  // ── Bookings ─────────────────────────────────────────────────────────────────
  Future<void> createBooking(CreateBookingRequest request);
  Future<void> acceptBooking(String bookingId);
  Future<void> rejectBooking(String bookingId);
  Future<BookingsListResponse> getMyBookings({
    required int page,
    required BookingStatus status,
    required AppRole appRole,
  });
  Future<BookingDetailModel> getBookingDetail(String bookingId);

  // ── FAQs ────────────────────────────────────────────────────────────────────
  Future<List<FaqItem>> getFaqs(String serviceId);

  Future<WorkScheduleListResponse> getWorkSchedule({int page, int limit});
  Future<void> createWorkSchedule(List<WorkScheduleRequest> schedules);
  Future<void> updateWorkSchedule(List<WorkScheduleRequest> schedules);

  Future<UserProfile> updateServiceProviderProfile(
    UpdateProviderRequest schedules,
  );
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
    final response = await _dio.get(
      ApiEndpoints.searchProviders,
      queryParameters: request.toQuery(),
    );
    return _parse(response, SearchProvidersResponse.fromJson);
  }

  // ── GET /service-providers/filters?service_type=X ───────────────────────────
  @override
  Future<ServiceFiltersModel> getFilters() async {
    final responses = await Future.wait([
      _dio.get(ApiEndpoints.serviceExperience),
      _dio.get(ApiEndpoints.serviceOthersTaskOptions),
    ]);

    final experienceResponse = ApiResponse<List<FilterOptionModel>>.fromJson(
      responses[0].data as Map<String, dynamic>,
      (data) {
        final list = data is List ? data : (data['data'] as List);
        return list
            .map((e) => FilterOptionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );

    final othersTaskResponse = ApiResponse<List<FilterOptionModel>>.fromJson(
      responses[1].data as Map<String, dynamic>,
      (data) {
        final list = data is List ? data : (data['data'] as List);
        return list
            .map((e) => FilterOptionModel.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
    final categoryResponse = await getAllCategories();

    return ServiceFiltersModel(
      experienceOptions: experienceResponse.data ?? [],
      othersTaskOptions: othersTaskResponse.data ?? [],
      category: categoryResponse,
    );
  }

  // ── GET /service-providers/:id ───────────────────────────────────────────────
  @override
  Future<UserProfile> getProviderProfile(String providerId) async {
    final url = ApiEndpoints.providerProfile(providerId);
    final response = await _dio.get(url);
    return _parse(response, UserProfile.fromJson);
  }

  @override
  Future<List<ProviderComment>> getProviderReviews(String providerId) async {
    final responses = await _dio.get(ApiEndpoints.providerReviews(providerId));
    final othersTaskResponse = ApiResponse<List<ProviderComment>>.fromJson(
      responses.data as Map<String, dynamic>,
      (data) {
        final list = data is List ? data : (data['data'] as List);
        return list
            .map((e) => ProviderComment.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
    return othersTaskResponse.data ?? [];
  }

  // ── POST /bookings ───────────────────────────────────────────────────────────
  @override
  Future<void> createBooking(CreateBookingRequest request) async {
    await _dio.post(ApiEndpoints.createBooking, data: request.toJson());
  }

  @override
  Future<void> acceptBooking(String bookingId) async {
    await _dio.patch(ApiEndpoints.acceptBooking(bookingId));
  }

  @override
  Future<void> rejectBooking(String bookingId) async {
    await _dio.patch(ApiEndpoints.cancelBooking(bookingId));
  }

  // ── GET /bookings/my-bookings ────────────────────────────────────────────────
  @override
  Future<BookingsListResponse> getMyBookings({
    int page = 1,
    required BookingStatus status,
    required AppRole appRole,
  }) async {
    final endpoint = (appRole == AppRole.user)
        ? ApiEndpoints.userBookings
        : ApiEndpoints.providerBookings;

    // 🔥 CASE: accepted tab → call twice
    if (status == BookingStatus.accepted || status == BookingStatus.requested) {
      final responses = await Future.wait([
        _dio.get(
          endpoint,
          queryParameters: {
            'page': page,
            'include': 'user,provider,bookingDays',
            'status': BookingStatus.requested.name,
          },
        ),
        _dio.get(
          endpoint,
          queryParameters: {
            'page': page,
            'include': 'user,provider,bookingDays',
            'status': BookingStatus.accepted.name,
          },
        ),
      ]);

      final res1 = _parse(responses[0], BookingsListResponse.fromJson);
      final res2 = _parse(responses[1], BookingsListResponse.fromJson);

      // 🔥 MERGE
      return BookingsListResponse(
        bookings: [...res1.bookings, ...res2.bookings],
      );
    }

    // ✅ NORMAL FLOW
    final response = await _dio.get(
      endpoint,
      queryParameters: {
        'page': page,
        'include': 'user,provider,bookingDays',
        'status': status.name,
      },
    );

    return _parse(response, BookingsListResponse.fromJson);
  }

  // ── GET /bookings/:id ────────────────────────────────────────────────────────
  @override
  Future<BookingDetailModel> getBookingDetail(String bookingId) async {
    final url = ApiEndpoints.bookingDetail.replaceFirst('{id}', bookingId);
    final response = await _dio.get(
      url,
      queryParameters: {'include': 'user,provider,bookingDays'},
    );
    return _parse(response, BookingDetailModel.fromJson);
  }

  // ── GET /faqs?service_type=X ─────────────────────────────────────────────────
  @override
  Future<List<FaqItem>> getFaqs(String serviceId) async {
    final response = await _dio.get(
      ApiEndpoints.faqs,
      queryParameters: {'categoryId': serviceId},
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

  @override
  Future<WorkScheduleListResponse> getWorkSchedule({
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.workSchedule,
      queryParameters: {'page': page, 'limit': limit},
    );
    final apiResponse = ApiResponse<WorkScheduleListResponse>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => WorkScheduleListResponse.fromJson(
        response.data
            as Map<
              String,
              dynamic
            >, // pass root so nested data/meta is accessible
      ),
    );
    if (!apiResponse.success) {
      throw Exception(
        apiResponse.error?.message ?? 'Failed to fetch work schedule',
      );
    }
    return apiResponse.data!;
  }

  // ── POST /workSchedule ───────────────────────────────────────────────────────
  @override
  Future<void> createWorkSchedule(List<WorkScheduleRequest> schedules) async {
    await _dio.post(
      ApiEndpoints.workSchedule,
      data: schedules.map((s) => s.toJson()).toList(),
    );
  }

  // ── PATCH /workSchedule ──────────────────────────────────────────────────────
  @override
  Future<void> updateWorkSchedule(List<WorkScheduleRequest> schedules) async {
    await _dio.patch(
      ApiEndpoints.workSchedule,
      data: schedules.map((s) => s.toJson()).toList(),
    );
  }

  // ── PATCH /updateServiceProviderProfile ──────────────────────────────────────────────────────
  @override
  Future<UserProfile> updateServiceProviderProfile(
    UpdateProviderRequest data,
  ) async {
    final response = await _dio.patch(
      ApiEndpoints.updateServiceProviderProfile,
      data: await data.toFormData(), // ✅ await the async FormData
      options: Options(
        contentType: 'multipart/form-data', // ✅ explicit content type
      ),
    );
    return _parse<UserProfile>(response, UserProfile.fromJson);
  }
}
