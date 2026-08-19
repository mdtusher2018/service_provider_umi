part of 'provider_profile_screen.dart';

final favoriteProvider = Provider.family<bool, String>((ref, providerId) {
  final asyncFavorites = ref.watch(favouritesNotifireProvider);

  return asyncFavorites.when(
    data: (list) => list.any((e) => e.serviceProviderId == providerId),
    loading: () => false,
    error: (_, __) => false,
  );
});
AppBar _buildAppBar({
  required WidgetRef ref,
  required UserProfile data,
  required String providerId,
}) {
  final isFavorited = ref.watch(favoriteProvider(providerId));

  return AppBar(
    leading: (kIsWeb)
        ? null
        : GestureDetector(
            onTap: () => ref.context.pop(),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
    title: AppText.h3("${data.name}'s profile"),
    centerTitle: true,
    backgroundColor: AppColors.background,
    surfaceTintColor: Colors.transparent,
    actions: [
      IconButton(
        icon: const Icon(
          Icons.ios_share_outlined,
          color: AppColors.textPrimary,
        ),
        onPressed: () {},
      ),

      /// ❤️ FAVORITE BUTTON
      GestureDetector(
        onTap: () {
          ref
              .read(favouritesNotifireProvider.notifier)
              .toggleFavorite(providerId);
          if (isFavorited) {
            ref.context.showFavoriteToast("Removed from favorites");
          } else {
            ref.context.showFavoriteToast("Added to favorites");
          }
        },
        child: Icon(
          isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isFavorited ? AppColors.error : AppColors.textPrimary,
        ),
      ),

      24.horizontalSpace,
    ],
  );
}
