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
    if (!state.hasValue) {
      state = const AsyncLoading();
    }

    final result = await _repo.getFavorites();
    if (!ref.mounted) return;

    state = result.when(
      success: AsyncData.new,
      failure: (e) => AsyncError(e, StackTrace.current),
    );
  }

  Future<void> toggleFavorite(String providerId) async {
    final currentList = state.value ?? [];
    final isFavorite = currentList.any((e) => e.serviceProviderId == providerId);

    final result = await _repo.toggleFavorite(id: providerId);

    if (!ref.mounted) return;

    result.when(
      success: (_) {
        // Update local state instantly so UI updates immediately
        if (isFavorite) {
          state = AsyncData(currentList.where((e) => e.serviceProviderId != providerId).toList());
        } else {
          state = AsyncData([...currentList, FavoriteModel(
            id: '', 
            userId: '', 
            serviceProviderId: providerId,
            createdAt: DateTime.now(),
          )]);
        }
        
        // Fetch fresh data in the background
        fetch();
      },
      failure: (e) {
        fetch();
      },
    );
  }
}
