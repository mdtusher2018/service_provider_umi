import 'package:service_provider_umi/core/base/repository.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/data_source/remote/service_remote_data_source.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/data/models/misc_models.dart';
import 'package:service_provider_umi/data/models/mock_service_provider_models.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';
import 'package:service_provider_umi/data/models/service_models.dart';
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
  ) =>
      asyncGuard(() => _remote.getSubCategories(serviceId));

  // ── POST /service-providers/search ───────────────────────────────────────────
  Future<Result<SearchProvidersResponse, Failure>> searchProviders(
    SearchProvidersRequest request,
  ) =>
      asyncGuard(() => _remote.searchProviders(request));

  // ── GET /service-providers/filters ───────────────────────────────────────────
  Future<Result<ServiceFiltersModel, Failure>> getFilters(
    String serviceType,
  ) =>
      asyncGuard(() => _remote.getFilters(serviceType));

  // ── GET /service-providers/:id ───────────────────────────────────────────────
  Future<Result<ProviderProfile, Failure>> getProviderProfile(
    String providerId,
  ) =>
      asyncGuard(() => _remote.getProviderProfile(providerId));

  // ── POST /bookings ────────────────────────────────────────────────────────────
  Future<Result<void, Failure>> createBooking(
    CreateBookingRequest request,
  ) =>
      asyncGuard(() => _remote.createBooking(request));

  // ── GET /bookings/my-bookings ─────────────────────────────────────────────────
  Future<Result<BookingsListResponse, Failure>> getMyBookings({
    BookingStatus? status,
    int page = 1,
    int limit = 10,
  }) =>
      asyncGuard(
        () => _remote.getMyBookings(status: status, page: page, limit: limit),
      );

  // ── GET /bookings/:id ─────────────────────────────────────────────────────────
  Future<Result<BookingDetails, Failure>> getBookingDetail(
    String bookingId,
  ) =>
      asyncGuard(() => _remote.getBookingDetail(bookingId));

  // ── GET /faqs ────────────────────────────────────────────────────────────────
  Future<Result<List<FaqItem>, Failure>> getFaqs(String serviceType) =>
      asyncGuard(() => _remote.getFaqs(serviceType));
}
