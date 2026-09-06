import 'package:dio/dio.dart';
import 'package:service_provider_umi/core/services/network/api_endpoints.dart';
import 'package:service_provider_umi/data/models/api_response.dart';
import 'package:service_provider_umi/data/models/availability_model.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/data/models/faq_model.dart';
import 'package:service_provider_umi/data/models/service_provider_models.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';

import 'package:service_provider_umi/data/models/category_models.dart';
import 'package:service_provider_umi/data/models/user_models.dart';
import 'package:service_provider_umi/data/models/work_schedule_model.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';

abstract class ServiceRemoteDataSource {
  // ── Categories ──────────────────────────────────────────────────────────────
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel> getServiceById(String id);
  Future<List<CategoryModel>> getSubCategories(String serviceId);
  Future<List<SubCategoryModel>> getSubCategoriesByQuery(String categoryId);

  // ── Providers ───────────────────────────────────────────────────────────────
  Future<SearchProvidersResponse> searchProviders(
    SearchProvidersRequest request,
  );
  Future<ServiceFiltersModel> getFilters();
  Future<UserProfile> getProviderProfile(String providerId);
  Future<List<ProviderComment>> getProviderReviews(
    String providerId, {
    int page = 1,
    int limit = 10,
  });

  // ── Bookings ─────────────────────────────────────────────────────────────────
  Future<String> createBooking(CreateBookingRequest request);
  Future<void> acceptBooking(String bookingId);
  Future<void> rejectBooking(String bookingId);
  Future<void> completeBooking(String bookingId);
  Future<void> confirmPayment(String bookingId, String? additionalComment);
  Future<void> giveReview(String userId, String review, double rating);
  Future<BookingsListResponse> getMyBookings({
    required int page,
    required BookingStatus status,
    required AppRole appRole,
    String? date,
  });
  Future<BookingDetailModel> getBookingDetail(String bookingId);

  // ── FAQs ────────────────────────────────────────────────────────────────────
  Future<List<FaqItem>> getFaqs(String serviceId);
  Future<List<FaqItem>> getFaqsByUserId(String userId);
  Future<void> createFaq({
    required String question,
    required String answer,
    required String userId,
  });

  Future<WorkScheduleListResponse> getWorkSchedule({required String userId});
  Future<void> createWorkSchedule(List<WorkScheduleRequest> schedules);
  Future<void> updateWorkSchedule(List<WorkScheduleRequest> schedules);

  Future<List<AvailabilitySlot>> getAvailability(AvailabilityRequest request);

  Future<UserProfile> updateServiceProviderProfile(
    UpdateProviderRequest schedules,
  );
}

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final Dio _dio;

  ServiceRemoteDataSourceImpl({required Dio apiService}) : _dio = apiService;

  // ── GET /categories ─────────────────────────────────────────────────────────
  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final response = await _dio.get(ApiEndpoints.services);
    final apiResponse = ApiResponse<List<CategoryModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => (data['data'] as List)
          .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
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
  Future<CategoryModel> getServiceById(String id) async {
    final url = ApiEndpoints.serviceById.replaceFirst('{id}', id);
    final response = await _dio.get(url);
    return _parse(response, CategoryModel.fromJson);
  }

  // ── GET /categories/:id/subcategories ───────────────────────────────────────
  @override
  Future<List<CategoryModel>> getSubCategories(String serviceId) async {
    final url = ApiEndpoints.subCategories.replaceFirst('{id}', serviceId);
    final response = await _dio.get(url);
    final apiResponse = ApiResponse<List<CategoryModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) {
        final list = data is List ? data : (data['data'] as List);
        return list
            .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
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

  // ── GET /subcategories ───────────────────────────────────────
  @override
  Future<List<SubCategoryModel>> getSubCategoriesByQuery(
    String categoryId,
  ) async {
    final response = await _dio.get(
      ApiEndpoints.subCategoriesPaginated,
      queryParameters: {
        'page': 1,
        'limit': 100,
        'categoryId': categoryId,
        'sort': '-createdAt',
      },
    );
    final apiResponse = ApiResponse<List<SubCategoryModel>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) {
        final list = data is List ? data : (data['data'] as List);
        return list
            .map((e) => SubCategoryModel.fromJson(e as Map<String, dynamic>))
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
  Future<List<ProviderComment>> getProviderReviews(
    String providerId, {
    int page = 1,
    int limit = 10,
  }) async {
    final responses = await _dio.get(
      ApiEndpoints.providerReviews(providerId),
      queryParameters: {"page": page, "limit" : limit, "sort" : "-createdAt"},
    );

    final parsed = ApiResponse<List<ProviderComment>>.fromJson(
      responses.data as Map<String, dynamic>,
      (data) {
        final list = data is List ? data : (data['data'] as List);
        return list
            .map((e) => ProviderComment.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );

    return parsed.data ?? [];
  }

  // ── POST /bookings ───────────────────────────────────────────────────────────
  @override
  Future<String> createBooking(CreateBookingRequest request) async {
    final response = await _dio.post(
      ApiEndpoints.createBooking,
      data: request.toJson(),
    );
    return response.data['data']?['id'] ?? "";
  }

  @override
  Future<void> acceptBooking(String bookingId) async {
    await _dio.patch(ApiEndpoints.acceptBooking(bookingId));
  }

  @override
  Future<void> rejectBooking(String bookingId) async {
    await _dio.patch(ApiEndpoints.cancelBooking(bookingId));
  }

  @override
  Future<void> completeBooking(String bookingId) async {
    await _dio.patch(ApiEndpoints.completeBooking(bookingId));
  }

  @override
  Future<void> giveReview(String userId, String review, double rating) async {
    await _dio.post(
      ApiEndpoints.giveReview,
      data: {"rating": rating, "review": review, "userId": userId},
    );
  }

  @override
  Future<void> confirmPayment(
    String bookingId,
    String? additionalComment,
  ) async {
    await _dio.post(
      ApiEndpoints.confirmPayment,
      data: {
        "bookingId": bookingId,
        "additionalComment": additionalComment,
      },
    );
  }

  // ── GET /bookings/my-bookings ────────────────────────────────────────────────
  @override
  Future<BookingsListResponse> getMyBookings({
    int page = 1,
    required BookingStatus status,
    required AppRole appRole,
    String? date,
  }) async {
    final endpoint = (appRole == AppRole.user)
        ? ApiEndpoints.userBookings
        : ApiEndpoints.providerBookings;

    // 🔥 CASE: accepted tab → call twice
    if (status == BookingStatus.requested || status == BookingStatus.pending) {
      final responses = await Future.wait([
        _dio.get(
          endpoint,
          queryParameters: {
            'page': page,
            'include': 'user,provider,bookingDays,address',
            'status': BookingStatus.requested.name,
            if (date != null) 'date': DateTime.parse(date).toLocal(),
          },
        ),
        _dio.get(
          endpoint,
          queryParameters: {
            'page': page,
            'include': 'user,provider,bookingDays,address',
            'status': BookingStatus.pending.name,
            if (date != null) 'date': DateTime.parse(date).toLocal(),
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
    final queryParams = <String, dynamic>{
      'page': page,
      'include': 'user,provider,bookingDays,address',
      if (status == BookingStatus.upcoming)
        'upcoming': true
      else
        'status': status.name,
      if (date != null)
        'date': DateTime.parse(date).toIso8601String().split('.').first,
    };

    final response = await _dio.get(endpoint, queryParameters: queryParams);

    return _parse(response, BookingsListResponse.fromJson);
  }

  // ── GET /bookings/:id ────────────────────────────────────────────────────────
  @override
  Future<BookingDetailModel> getBookingDetail(String bookingId) async {
    final url = ApiEndpoints.bookingDetail.replaceFirst('{id}', bookingId);
    final response = await _dio.get(
      url,
      queryParameters: {'include': 'user,provider,bookingDays,address'},
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

  @override
  Future<List<FaqItem>> getFaqsByUserId(String userId) async {
    final response = await _dio.get(
      ApiEndpoints.faqs,
      queryParameters: {'userId': userId},
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

  @override
  Future<void> createFaq({
    required String question,
    required String answer,
    required String userId,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.faqs,
      data: {"question": question, "answer": answer, "userId": userId},
    );
    final apiResponse = ApiResponse<void>.fromJson(
      response.data as Map<String, dynamic>,
      (data) => null,
    );
    if (!apiResponse.success) {
      throw Exception(
        apiResponse.error?.message ??
            apiResponse.message ??
            'Failed to create FAQ',
      );
    }
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
    required String userId,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.workSchedule,
      queryParameters: {'userId': userId},
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

  @override
  Future<List<AvailabilitySlot>> getAvailability(
    AvailabilityRequest request,
  ) async {
    final response = await _dio.post(
      ApiEndpoints.availability,
      data: request.toJson(),
    );
    final apiResponse = ApiResponse<List<AvailabilitySlot>>.fromJson(
      response.data as Map<String, dynamic>,
      (data) {
        final list = data is List ? data : (data['data'] as List);
        return list
            .map((e) => AvailabilitySlot.fromJson(e as Map<String, dynamic>))
            .toList();
      },
    );
    if (!apiResponse.success) {
      throw Exception(
        apiResponse.error?.message ?? 'Failed to fetch availability',
      );
    }
    return apiResponse.data ?? [];
  }
}
