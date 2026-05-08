part of 'provider_profile_screen.dart';

final _favoriteProvider = StateProvider<bool>((ref) => false);
AppBar _buildAppBar({
  required WidgetRef ref,
  required ProviderProfile mockProvider,
}) {
  final isFavorited = ref.watch(_favoriteProvider);

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
    title: AppText.h3("${mockProvider.name}'s profile"),
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
      GestureDetector(
        onTap: () {
          ref.read(_favoriteProvider.notifier).state = !isFavorited;
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
