import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/data/models/search_models.dart';
import 'package:service_provider_umi/data/repository/user_repository.dart';

part 'favourites_notifire.g.dart';

@riverpod
class FavouritesNotifire extends _$FavouritesNotifire {
  @override
  AsyncValue<List<ProviderSearchResult>> build() => const AsyncLoading();

  UserRepository get _repo => ref.read(userRepositoryProvider);

  Future<void> fetch() async {
    state = const AsyncLoading();

    final result = await _repo.getFavorites();
    if (!ref.mounted) return;

    state = result.when(
      success: AsyncData.new,
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }
}
