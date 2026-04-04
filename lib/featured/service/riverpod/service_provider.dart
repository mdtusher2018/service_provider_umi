import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/base/result.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';

import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/data/models/misc_models.dart';
import 'package:service_provider_umi/data/models/mock_service_provider_models.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';
import 'package:service_provider_umi/data/models/service_models.dart';

import 'package:service_provider_umi/data/repository/service_repository.dart';

part 'service_provider.g.dart';

// ── GET /categories ───────────────────────────────────────────────────────────

@riverpod
class CategoriesNotifier extends _$CategoriesNotifier {
  @override
  AsyncValue<List<ServiceModel>> build() {
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
  AsyncValue<List<ServiceModel>> build() {
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
  AsyncValue<ServiceModel> build() => const AsyncLoading();

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
      success: (data) => AsyncData((result as Success).data),
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}

@riverpod
class BookingsNotifier extends _$BookingsNotifier {
  @override
  AsyncValue<BookingsListResponse> build() => const AsyncLoading();

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  Future<void> fetch() async {
    state = const AsyncLoading();

    final result = await _repo.getMyBookings();

    state = result.when(
      success: AsyncData.new,
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}

@riverpod
class FaqNotifier extends _$FaqNotifier {
  @override
  AsyncValue<List<FaqItem>> build() => const AsyncLoading();

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  Future<void> fetch(String type) async {
    state = const AsyncLoading();

    final result = await _repo.getFaqs(type);

    state = result.when(
      success: (data) => AsyncData(data),
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}

@riverpod
class ProviderProfileNotifier extends _$ProviderProfileNotifier {
  @override
  AsyncValue<ProviderProfile> build() {
    return const AsyncLoading();
  }

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  Future<void> fetch(String providerId) async {
    state = const AsyncLoading();

    final result = await _repo.getProviderProfile(providerId);

    state = result.when(
      success: (data) => AsyncData(data),
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}
