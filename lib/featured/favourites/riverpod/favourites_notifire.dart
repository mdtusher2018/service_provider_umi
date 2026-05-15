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

  /// ✅ TOGGLE FAVORITE (Optimistic UI)
  Future<void> toggleFavorite(String providerId) async {
    final currentList = state.value ?? [];

    final isAlreadyFavorite = currentList.any(
      (e) => e.serviceProviderId == providerId,
    );

    // 🔥 Optimistic update (instant UI change)
    List<FavoriteModel> updatedList;

    if (isAlreadyFavorite) {
      updatedList = currentList
          .where((e) => e.serviceProviderId != providerId)
          .toList();
    } else {
      // Minimal temp object (adjust if needed)
      final newItem = FavoriteModel(
        id: DateTime.now().toString(),
        userId: '',
        serviceProviderId: providerId,
        serviceProvider: currentList.isNotEmpty
            ? currentList.first.serviceProvider
            : throw Exception("Missing serviceProvider"),
      );

      updatedList = [...currentList, newItem];
    }

    // ✅ IMPORTANT: new reference
    state = AsyncData(updatedList);

    // 🔥 API call
    final result = await _repo.toggleFavorite(id: providerId);
    if (!ref.mounted) return;

    result.when(
      success: (_) {
        // Optional: sync with backend
        // fetch();
      },
      failure: (e) {
        // ❌ rollback if API fails
        fetch();
      },
    );
  }
}
