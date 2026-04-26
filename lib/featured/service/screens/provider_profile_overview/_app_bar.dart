part of 'provider_profile_screen.dart';

final favoriteProvider = StateProvider<bool>((ref) => false);
Widget _buildAppBar({
  required WidgetRef ref,
  required ProviderProfile mockProvider,
}) {
  final isFavorited = ref.watch(favoriteProvider);

  return SafeArea(
    bottom: false,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => ref.context.pop(),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ),
          Expanded(
            child: Center(child: AppText.h3("${mockProvider.name}'s profile")),
          ),
          IconButton(
            icon: const Icon(
              Icons.ios_share_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {},
          ),
          GestureDetector(
            onTap: () {
              ref.read(favoriteProvider.notifier).state = !isFavorited;
            },
            child: Icon(
              isFavorited
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: isFavorited ? AppColors.error : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    ),
  );
}
