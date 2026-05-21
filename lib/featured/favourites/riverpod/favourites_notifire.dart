import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/data/models/favorites_model.dart';
import 'package:service_provider_umi/data/repository/user_repository.dart';

part 'favourites_notifire.g.dart';

@Riverpod(keepAlive: true)
class FavouritesNotifire extends _$FavouritesNotifire {
  @override
  AsyncValue<List<FavoriteModel>> build() => const AsyncLoading();

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

  Future<void> toggleFavorite(String providerId) async {
    final result = await _repo.toggleFavorite(id: providerId);

    if (!ref.mounted) return;

    result.when(
      success: (_) async {
        // ✅ Always fetch fresh data from server
        await fetch();
      },
      failure: (e) async {
        await fetch();
      },
    );
  }
}
