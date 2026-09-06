import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/core/logger/app_logger.dart';
import 'package:service_provider_umi/core/utils/helpers/decode_helper.dart';
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
  int _page = 1;
  bool _hasMore = true;
  bool _isFetching = false;
  SearchProvidersRequest? _currentRequest;

  @override
  AsyncValue<SearchProvidersResponse> build() => const AsyncLoading();

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  Future<void> search([
    SearchProvidersRequest? request,
    bool initial = false,
  ]) async {
    if (_isFetching) return;

    final req = request ?? _currentRequest;
    if (req == null) return;

    if (initial || _currentRequest != req) {
      _page = 1;
      _hasMore = true;
      _currentRequest = req;
      state = const AsyncLoading();
    } else if (!_hasMore) {
      return;
    }

    _isFetching = true;
    if (!initial && _currentRequest == req) {
      state = AsyncLoading<SearchProvidersResponse>().copyWithPrevious(state);
    }

    final pagedRequest = _currentRequest!.mergeWith(page: _page);
    final result = await _repo.searchProviders(pagedRequest);

    if (!ref.mounted) return;

    state = result.when(
      success: (data) {
        final newItems = data.results;
        final currentItems = state.value?.results ?? [];
        final updatedItems = initial
            ? newItems
            : [...currentItems, ...newItems];

        _hasMore = updatedItems.length < data.pagination.totalPage;
        _page++;
        _isFetching = false;

        return AsyncData(
          SearchProvidersResponse(
            results: updatedItems,
            pagination: data.pagination,
          ),
        );
      },
      failure: (e) {
        _isFetching = false;
        return AsyncError(e, StackTrace.current);
      },
    );
  }
}

@riverpod
class BookingsNotifier extends _$BookingsNotifier {
  int _page = 1;
  bool _hasMore = true;
  bool _isFetching = false;
  BookingStatus? bookingStatus;
  String? _selectedDate;
  final isAccepting = ValueNotifier<bool>(false);
  final isCancelling = ValueNotifier<bool>(false);

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  @override
  AsyncValue<List<BookingModel>> build(BookingStatus status) {
    bookingStatus = status;
    fetch(initial: true);

    return const AsyncLoading();
  }

  Future<void> fetch({
    bool initial = false,
    String? date,
    bool clearDate = false,
  }) async {
    if (_isFetching) return;

    if (initial) {
      _page = 1;
      _hasMore = true;
      if (clearDate) {
        _selectedDate = null;
      } else if (date != null) {
        _selectedDate = date;
      }
      state = const AsyncLoading();
    }

    if (!_hasMore) return;

    _isFetching = true;

    if (!initial) {
      state = AsyncLoading<List<BookingModel>>().copyWithPrevious(state);
    }

    final result = await _repo.getMyBookings(
      page: _page,
      status: bookingStatus!,
      appRole: ref.read(appRoleProvider),
      date: _selectedDate,
    );

    if (!ref.mounted) return;

    result.when(
      success: (res) {
        var newItems = res.bookings;

        if (bookingStatus == BookingStatus.upcoming) {
          newItems = newItems
              .where((b) => b.status != BookingStatus.canceled)
              .toList();
        }

        final current = state.value ?? [];

        final updated = initial ? newItems : [...current, ...newItems];

        if (res.meta != null) {
          _hasMore = updated.length < res.meta!.total;
        } else {
          _hasMore = newItems.isNotEmpty;
        }

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
      success: (data) async {
        await fetch(initial: true);
        return "Successfully Booked: $data";
      },
      failure: (e) {
        return e.message;
      },
    );
  }
}

@riverpod
class BookingDetail extends _$BookingDetail {
  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  @override
  Future<BookingDetailModel?> build(String bookingId) async {
    final result = await _repo.getBookingDetail(bookingId);

    return result.when(success: (data) => data, failure: (e) => throw e);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();

    final result = await _repo.getBookingDetail(bookingId);

    state = result.when(
      success: AsyncData.new,
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}

@riverpod
class AcceptBooking extends _$AcceptBooking {
  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  @override
  FutureOr<void> build() {}

  Future<void> accept(String bookingId) async {
    state = const AsyncLoading();

    final result = await _repo.acceptBooking(bookingId);

    state = result.when(
      success: (_) => const AsyncData(null),
      failure: (e) => AsyncError(e, StackTrace.current),
    );

    if (state is AsyncData) {
      ref.invalidate(bookingDetailProvider(bookingId));
      ref.invalidate(bookingsProvider);
    }
  }
}

@riverpod
class RejectBooking extends _$RejectBooking {
  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  @override
  FutureOr<void> build() {}

  Future<void> reject(String bookingId) async {
    state = const AsyncLoading();

    final result = await _repo.rejectBooking(bookingId);

    state = result.when(
      success: (_) => const AsyncData(null),
      failure: (e) => AsyncError(e, StackTrace.current),
    );

    if (state is AsyncData) {
      ref.invalidate(bookingDetailProvider(bookingId));
      ref.invalidate(bookingsProvider);
    }
  }
}

@riverpod
class CompleteBooking extends _$CompleteBooking {
  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  @override
  FutureOr<void> build() {}

  Future<void> complete(String bookingId) async {
    state = const AsyncLoading();

    final result = await _repo.completeBooking(bookingId);

    state = result.when(
      success: (_) => const AsyncData(null),
      failure: (e) => AsyncError(e, StackTrace.current),
    );

    if (state is AsyncData) {
      ref.invalidate(bookingDetailProvider(bookingId));
      ref.invalidate(bookingsProvider);
    }
  }
}

@riverpod
class ConfirmPayment extends _$ConfirmPayment {
  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  @override
  FutureOr<void> build() {}

  Future<void> confirm(String bookingId, String? additionalComment) async {
    state = const AsyncLoading();

    final result = await _repo.confirmPayment(bookingId, additionalComment);

    state = result.when(
      success: (_) => const AsyncData(null),
      failure: (e) => AsyncError(e, StackTrace.current),
    );

    if (state is AsyncData) {
      ref.invalidate(bookingDetailProvider(bookingId));
      ref.invalidate(bookingsProvider);
    }
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
class ProviderFaqsNotifier extends _$ProviderFaqsNotifier {
  @override
  AsyncValue<List<FaqItem>> build(String userId) {
    _fetch(userId);
    return const AsyncLoading();
  }

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  Future<void> _fetch(String userId) async {
    final result = await _repo.getFaqsByUserId(userId);

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
    return const AsyncLoading();
  }

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  Future<void> fetch(WidgetRef widref) async {
    state = const AsyncLoading();
    final userId = await getMyUserId(widref);
    final result = await _repo.getWorkSchedule(userId: userId);
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

    final result = await _repo.createWorkSchedule(schedules);

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

final subcategoriesProvider =
    FutureProvider.family<List<SubCategoryModel>, String>((
      ref,
      categoryId,
    ) async {
      final result = await ref
          .read(serviceRepositoryProvider)
          .getSubCategoriesByQuery(categoryId);
      return result.when(
        success: (data) => data,
        failure: (failure) => throw Exception(failure.message),
      );
    });

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
    if (!ref.mounted) return;
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

@riverpod
class GiveReviewNotifier extends _$GiveReviewNotifier {
  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  @override
  FutureOr<void> build() {}

  Future<void> giveReview(String userId, String review, double rating) async {
    state = const AsyncLoading();

    final result = await _repo.giveReviews(userId, review, rating);

    state = result.when(
      success: (_) => const AsyncData(null),
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}
