import 'package:service_provider_umi/core/base/repository.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/data_source/remote/service_remote_data_source.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/data/models/faq_model.dart';
import 'package:service_provider_umi/data/models/mock_service_provider_models.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';
import 'package:service_provider_umi/data/models/service_models.dart';
import 'package:service_provider_umi/data/models/user_models.dart';
import 'package:service_provider_umi/data/models/work_schedule_model.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';

class ServiceRepository with SafeCall {
  final ServiceRemoteDataSource _remote;

  ServiceRepository({required ServiceRemoteDataSource remote})
    : _remote = remote;

  // ── GET /categories ──────────────────────────────────────────────────────────
  Future<Result<List<ServiceModel>, Failure>> getAllCategories() =>
      asyncGuard(() => _remote.getAllCategories());

  // ── GET /categories/:id ──────────────────────────────────────────────────────
  Future<Result<ServiceModel, Failure>> getServiceById(String id) =>
      asyncGuard(() => _remote.getServiceById(id));

  // ── GET /categories/:id/subcategories ────────────────────────────────────────
  Future<Result<List<ServiceModel>, Failure>> getSubCategories(
    String serviceId,
  ) => asyncGuard(() => _remote.getSubCategories(serviceId));

  // ── POST /service-providers/search ───────────────────────────────────────────
  Future<Result<SearchProvidersResponse, Failure>> searchProviders(
    SearchProvidersRequest request,
  ) => asyncGuard(() => _remote.searchProviders(request));

  // ── GET /service-providers/filters ───────────────────────────────────────────
  Future<Result<ServiceFiltersModel, Failure>> getFilters() =>
      asyncGuard(() => _remote.getFilters());

  // ── GET /service-providers/:id ───────────────────────────────────────────────
  Future<Result<UserProfile, Failure>> getProviderProfile(String providerId) =>
      asyncGuard(() => _remote.getProviderProfile(providerId));

  Future<Result<List<ProviderComment>, Failure>> getProviderReviews(
    String providerId,
  ) => asyncGuard(() => _remote.getProviderReviews(providerId));
  // ── POST /bookings ────────────────────────────────────────────────────────────
  Future<Result<void, Failure>> createBooking(CreateBookingRequest request) =>
      asyncGuard(() => _remote.createBooking(request));
  Future<Result<void, Failure>> acceptBooking(String bookingId) =>
      asyncGuard(() => _remote.acceptBooking(bookingId));
  Future<Result<void, Failure>> rejectBooking(String bookingId) =>
      asyncGuard(() => _remote.rejectBooking(bookingId));

  // ── GET /bookings/my-bookings ─────────────────────────────────────────────────
  Future<Result<BookingsListResponse, Failure>> getMyBookings({
    required int page,
    required BookingStatus status,
    required AppRole appRole,
  }) => asyncGuard(
    () => _remote.getMyBookings(page: page, status: status, appRole: appRole),
  );

  // ── GET /bookings/:id ─────────────────────────────────────────────────────────
  Future<Result<BookingDetailModel, Failure>> getBookingDetail(
    String bookingId,
  ) => asyncGuard(() => _remote.getBookingDetail(bookingId));

  // ── GET /faqs ────────────────────────────────────────────────────────────────
  Future<Result<List<FaqItem>, Failure>> getFaqs(String serviceId) =>
      asyncGuard(() => _remote.getFaqs(serviceId));

  // ── GET /workSchedule ────────────────────────────────────────────────────────
  Future<Result<WorkScheduleListResponse, Failure>> getWorkSchedule({
    int page = 1,
    int limit = 10,
  }) => asyncGuard(() => _remote.getWorkSchedule(page: page, limit: limit));

  // ── POST /workSchedule ───────────────────────────────────────────────────────
  Future<Result<void, Failure>> createWorkSchedule(
    List<WorkScheduleRequest> schedules,
  ) => asyncGuard(() => _remote.createWorkSchedule(schedules));

  // ── PATCH /workSchedule ──────────────────────────────────────────────────────
  Future<Result<void, Failure>> updateWorkSchedule(
    List<WorkScheduleRequest> schedules,
  ) => asyncGuard(() => _remote.updateWorkSchedule(schedules));

  // ── PATCH /workSchedule ──────────────────────────────────────────────────────
  Future<Result<UserProfile, Failure>> updateServiceProviderProfile(
    UpdateProviderRequest schedules,
  ) => asyncGuard(() => _remote.updateServiceProviderProfile(schedules));
}
