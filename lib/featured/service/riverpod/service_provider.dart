import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/models/service_models.dart';
import 'package:service_provider_umi/data/models/static_content_model.dart';
import 'package:service_provider_umi/data/repository/service_repository.dart';

part 'service_provider.freezed.dart';
part 'service_provider.g.dart';

// ── States ────────────────────────────────────────────────────────────────────

@freezed
abstract class ServiceListState with _$ServiceListState {
  const factory ServiceListState.initial() = ServiceListInitial;
  const factory ServiceListState.loading() = ServiceListLoading;
  const factory ServiceListState.success(List<ServiceModel> categories) =
      ServiceListSuccess;
  const factory ServiceListState.failure(Failure failure) = ServiceListFailure;
}

@freezed
abstract class ContentListState with _$ContentListState {
  const factory ContentListState.initial() = ContentListInitial;
  const factory ContentListState.loading() = ContentListLoading;
  const factory ContentListState.success(List<StaticContentItem> items) =
      ContentListSuccess;
  const factory ContentListState.failure(Failure failure) = ContentListFailure;
}

// ── GET /categories ───────────────────────────────────────────────────────────

@riverpod
class CategoriesNotifier extends _$CategoriesNotifier {
  @override
  ServiceListState build() => const ServiceListState.initial();

  ServiceRepository get _repo => ref.read(serviceRepositoryProvider);

  Future<void> fetch() async {
    state = const ServiceListState.loading();
    final result = await _repo.getAllCategories();
    state = result.when(
      success: ServiceListState.success,
      failure: ServiceListState.failure,
    );
  }

  void reset() => state = const ServiceListState.initial();
}
