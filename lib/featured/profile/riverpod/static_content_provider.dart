import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/core/error/failure.dart';
import 'package:service_provider_umi/data/models/static_content_model.dart';
import 'package:service_provider_umi/data/repository/static_content_repository.dart';

part 'static_content_provider.freezed.dart';
part 'static_content_provider.g.dart';

@freezed
abstract class StaticContentState with _$StaticContentState {
  const factory StaticContentState.initial() = StaticContentStateInitial;
  const factory StaticContentState.loading() = StaticContentStateLoading;
  const factory StaticContentState.success(StaticContentItem content) =
      StaticContentStateSuccess;
  const factory StaticContentState.failure(Failure failure) =
      StaticContentStateFailure;
}

@riverpod
class StaticContentNotifier extends _$StaticContentNotifier {
  @override
  StaticContentState build() => const StaticContentState.initial();

  StaticContentRepository get _repo =>
      ref.read(staticContentRepositoryProvider);

  Future<void> fetch() async {
    if (!ref.mounted) return;
    state = const StaticContentState.loading();

    final result = await _repo.getStaticContents();

    if (!ref.mounted) return;
    state = result.when(
      success: StaticContentState.success,
      failure: StaticContentState.failure,
    );
  }
}
