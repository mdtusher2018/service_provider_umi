// featured/services/service_provider.dart

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/data/models/service_models.dart';

part 'service_provider.g.dart';

// ── Home Services Notifier ────────────────────────────────────────────────────

@riverpod
class HomeServicesNotifier extends _$HomeServicesNotifier {
  @override
  Future<HomeServicesResponse> build() => _fetch();

  Future<HomeServicesResponse> _fetch() async {
    final result = await ref.read(serviceRepositoryProvider).getHomeServices();

    return result.when(success: (data) => data, failure: (f) => throw f);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

// ── All Services Notifier ─────────────────────────────────────────────────────

@riverpod
class AllServicesNotifier extends _$AllServicesNotifier {
  @override
  Future<AllServicesResponse> build() => _fetch();

  Future<AllServicesResponse> _fetch() async {
    final result = await ref.read(serviceRepositoryProvider).getAllServices();

    return result.when(success: (data) => data, failure: (f) => throw f);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetch);
  }
}

// ── Sub-Categories Notifier ───────────────────────────────────────────────────

@riverpod
class SubCategoriesNotifier extends _$SubCategoriesNotifier {
  @override
  Future<AllServicesResponse> build(String serviceType) => _fetch(serviceType);

  Future<AllServicesResponse> _fetch(String serviceType) async {
    final result = await ref
        .read(serviceRepositoryProvider)
        .getSubCategories(serviceType);

    return result.when(success: (data) => data, failure: (f) => throw f);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch("arg"));
  }
}
