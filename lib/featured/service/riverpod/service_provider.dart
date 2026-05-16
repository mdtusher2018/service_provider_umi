import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/core/logger/app_logger.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/data/models/faq_model.dart';
import 'package:service_provider_umi/data/models/service_provider_models.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';
import 'package:service_provider_umi/data/models/category_models.dart';
import 'package:service_provider_umi/data/models/user_models.dart';
import 'package:service_provider_umi/data/models/work_schedule_model.dart';
import 'package:service_provider_umi/data/repository/chat_repository.dart';
import 'package:service_provider_umi/data/repository/service_repository.dart';

import 'package:service_provider_umi/shared/enums/booking_status.dart';

part 'service_provider.g.dart';

// ── GET /categories ───────────────────────────────────────────────────────────

@riverpod
class CategoriesNotifier extends _$CategoriesNotifier {
  @override
  AsyncValue<List<CategoryModel>> build() {
    return const AsyncLoading();
  }

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  Future<void> fetch() async {
    state = const AsyncLoading();

    final result = await _repo.getAllCategories();

    state = result.when(
      success: (data) => AsyncData(data),
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }

  void reset() {
    state = const AsyncData([]);
  }
}

@riverpod
class SubCategoriesNotifier extends _$SubCategoriesNotifier {
  @override
  AsyncValue<List<CategoryModel>> build() {
    return const AsyncLoading();
  }

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  Future<void> fetch(String serviceId) async {
    state = const AsyncLoading();

    final result = await _repo.getSubCategories(serviceId);

    state = result.when(
      success: (data) => AsyncData(data),
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}

@riverpod
class ServiceDetailsNotifier extends _$ServiceDetailsNotifier {
  @override
  AsyncValue<CategoryModel> build() => const AsyncLoading();

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  Future<void> fetch(String id) async {
    state = const AsyncLoading();

    final result = await _repo.getServiceById(id);

    state = result.when(
      success: AsyncData.new,
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}

@riverpod
class SearchServiceProvidersNotifier extends _$SearchServiceProvidersNotifier {
  @override
  AsyncValue<SearchProvidersResponse> build() => const AsyncLoading();

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  Future<void> search(SearchProvidersRequest request) async {
    state = const AsyncLoading();

    final result = await _repo.searchProviders(request);

    state = result.when(
      success: (data) => AsyncData(data),
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}

@riverpod
class BookingsNotifier extends _$BookingsNotifier {
  int _page = 1;
  bool _hasMore = true;
  bool _isFetching = false;
  BookingStatus? bookingStatus;
  final isAccepting = ValueNotifier<bool>(false);
  final isCancelling = ValueNotifier<bool>(false);

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  @override
  AsyncValue<List<BookingModel>> build(BookingStatus status) {
    bookingStatus = status;
    fetch(initial: true);

    return const AsyncLoading();
  }

  Future<void> fetch({bool initial = false}) async {
    if (_isFetching) return;

    if (initial) {
      _page = 1;
      _hasMore = true;
      state = const AsyncLoading();
    }

    if (!_hasMore) return;

    _isFetching = true;

    final result = await _repo.getMyBookings(
      page: _page,
      status: bookingStatus!,
      appRole: ref.read(appRoleProvider),
    );

    if (!ref.mounted) return;

    result.when(
      success: (res) {
        final newItems = res.bookings;

        final current = state.value ?? [];

        final updated = initial ? newItems : [...current, ...newItems];

        _hasMore = newItems.isNotEmpty;
        _page++;

        state = AsyncData(updated);
      },
      failure: (e) {
        state = AsyncError(e, StackTrace.current);
      },
    );

    _isFetching = false;
  }

  Future<String?> createBooking({required CreateBookingRequest request}) async {
    final result = await _repo.createBooking(request);

    return result.when(
      success: (_) async {
        await fetch(initial: true);
        return "Successfully Booked";
      },
      failure: (e) {
        return e.message;
      },
    );
  }

  Future<void> acceptBooking(String bookingId) async {
    final current = state.value ?? [];
    isAccepting.value = true;
    final result = await _repo.acceptBooking(bookingId);
    isAccepting.value = false;

    if (!ref.mounted) return;

    result.when(
      success: (_) {
        final updated = current.map((b) {
          return b;
        }).toList();

        state = AsyncData(updated);
      },
      failure: (e) async {
        await fetch(initial: true);
      },
    );
  }

  Future<void> rejectBooking(String bookingId) async {
    final current = state.value ?? [];

    isCancelling.value = true;
    final result = await _repo.rejectBooking(bookingId);
    isCancelling.value = false;

    if (!ref.mounted) return;

    result.when(
      success: (_) {
        final updated = current.map((b) {
          return b;
        }).toList();

        state = AsyncData(updated);
      },
      failure: (e) async {
        await fetch(initial: true);
      },
    );
  }
}

@riverpod
class BookingDetailNotifier extends _$BookingDetailNotifier {
  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  final isAccepting = ValueNotifier<bool>(false);
  final isCancelling = ValueNotifier<bool>(false);
  final isConfirmimgPayment = ValueNotifier<bool>(false);

  @override
  Future<BookingDetailModel?> build(String bookingId) async {
    return fetch(bookingId);
  }

  Future<BookingDetailModel?> fetch(String bookingId) async {
    final result = await _repo.getBookingDetail(bookingId);

    return result.when(success: (data) => data, failure: (e) => throw e);
  }

  Future<void> refresh(String bookingId) async {
    state = const AsyncLoading();

    final result = await _repo.getBookingDetail(bookingId);

    state = result.when(
      success: AsyncData.new,
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }

  Future<void> acceptBooking(String bookingId) async {
    isAccepting.value = true;
    final result = await _repo.acceptBooking(bookingId);
    isAccepting.value = false;

    if (!ref.mounted) return;

    result.when(
      success: (_) {
        fetch(bookingId);
      },
      failure: (e) {
        state = AsyncError(e, StackTrace.current);
      },
    );
  }

  Future<void> rejectBooking(String bookingId) async {
    isCancelling.value = true;
    final result = await _repo.rejectBooking(bookingId);
    isCancelling.value = false;

    if (!ref.mounted) return;

    result.when(
      success: (_) {
        fetch(bookingId);
      },
      failure: (e) {
        state = AsyncError(e, StackTrace.current);
      },
    );
  }

  Future<void> confirmPayment(String bookingId) async {
    isConfirmimgPayment.value = true;
    final result = await _repo.confirmPayment(bookingId);
    isConfirmimgPayment.value = false;

    if (!ref.mounted) return;

    result.when(
      success: (_) {
        fetch(bookingId);
      },
      failure: (e) {
        state = AsyncError(e, StackTrace.current);
      },
    );
  }
}

@riverpod
class FaqNotifier extends _$FaqNotifier {
  @override
  AsyncValue<List<FaqItem>> build() => const AsyncLoading();

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  Future<void> fetch(String serviceId) async {
    state = const AsyncLoading();

    final result = await _repo.getFaqs(serviceId);

    state = result.when(
      success: (data) => AsyncData(data),
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}

@riverpod
class WorkScheduleNotifier extends _$WorkScheduleNotifier {
  @override
  AsyncValue<WorkScheduleListResponse> build() {
    fetch();
    return const AsyncLoading();
  }

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  Future<void> fetch({int page = 1, int limit = 10}) async {
    state = const AsyncLoading();

    final result = await _repo.getWorkSchedule(page: page, limit: limit);
    if (!ref.mounted) return;

    state = result.when(
      success: AsyncData.new,
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}

@riverpod
class SaveWorkScheduleNotifier extends _$SaveWorkScheduleNotifier {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  /// Call this from the screen.  Pass [isUpdate] = true for PATCH, false for POST.
  Future<bool> save({
    required List<WorkScheduleRequest> schedules,
    required bool isUpdate,
  }) async {
    state = const AsyncLoading();

    final result = isUpdate
        ? await _repo.updateWorkSchedule(schedules)
        : await _repo.createWorkSchedule(schedules);

    if (!ref.mounted) return false;

    return result.when(
      success: (_) {
        state = const AsyncData(null);
        ref.invalidate(workScheduleProvider);
        return true;
      },
      failure: (e) {
        state = AsyncError(e, StackTrace.current);
        return false;
      },
    );
  }
}

//========================================
//============Filter Page Api=============
//========================================

@riverpod
class FilterNotifier extends _$FilterNotifier {
  @override
  AsyncValue<ServiceFiltersModel> build() {
    return const AsyncLoading();
  }

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  Future<void> fetch() async {
    state = const AsyncLoading();
    final result = await _repo.getFilters();
    state = result.when(
      success: (data) => AsyncData(data),
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}

//========================================
//==========Service Profile API===========
//========================================

@riverpod
class ProviderProfileNotifier extends _$ProviderProfileNotifier {
  @override
  AsyncValue<(UserProfile, List<ProviderComment>, String)> build() {
    return const AsyncLoading();
  }

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);
  ChatRepository get _chatRepo => ref.read(chatRepositoryProvider);

  Future<void> fetch(String providerId) async {
    state = const AsyncLoading();

    final results = await Future.wait([
      _repo.getProviderProfile(providerId),
      _repo.getProviderReviews(providerId),
      _chatRepo.getChatId(providerId),
    ]);

    final profileResult = results[0] as Result<UserProfile, Failure>;
    final reviewsResult = results[1] as Result<List<ProviderComment>, Failure>;
    final chatId = results[2] as Result<String, Failure>;

    // handle both results safely
    state = profileResult.when(
      success: (profile) {
        return reviewsResult.when(
          success: (data) {
            return chatId.when(
              success: (id) => AsyncData((profile, data, id)),
              failure: (e) => AsyncError(e, StackTrace.current),
            );
          }, // ✅ tuple combined
          failure: (e) => AsyncError(e, StackTrace.current),
        );
      },
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}

@riverpod
class UpdateProviderNotifier extends _$UpdateProviderNotifier {
  @override
  AsyncValue<bool> build() {
    return const AsyncData(false);
  }

  Future<bool> update(UpdateProviderRequest data) async {
    state = const AsyncLoading();

    final repo = ref.read(serviceRepositoryProvider);
    final result = await repo.updateServiceProviderProfile(data);

    final success = result.when(
      success: (_) {
        state = AsyncData(true);
        return true;
      },
      failure: (e) {
        AppLogger.error(e.message);
        AppLogger.error(StackTrace.current.toString());
        state = AsyncError(e.message, StackTrace.current);
        return false;
      },
    );

    return success;
  }
}
