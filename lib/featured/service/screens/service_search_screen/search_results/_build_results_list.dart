part of 'service_search_results_screen.dart';

Widget _buildResultsList({required WidgetRef ref}) {
  final state = ref.watch(searchServiceProvidersProvider);

  return state.when(
    loading: () => const AppLoader(),

    error: (e, _) => Center(child: AppText.bodyLg(e.toString())),

    data: (response) {
      final providers = response.results;

      if (providers.isEmpty) {
        return const Center(child: Text("No providers found"));
      }

      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: providers.length,
        separatorBuilder: (_, __) => 12.verticalSpace,
        itemBuilder: (_, i) {
          final p = providers[i];

          return ProviderCard(
            name: p.name,

            rating: p.rating.toDouble(),
            reviewCount: p.reviewsCount,
            serviceCount: p.servicesCount,
            pricePerHour: p.pricePerHour,
            imageUrl: p.avatarUrl,
            isVerified: p.verified,
            hasRepeated: p.repeatedCount > 0,
            isFavorited: p.isLiked,
            hasUpdatedSchedule: true,
            onTap: () {
              if (kIsWeb) {
                ref.context.go(AppRoutes.providerProfilePath(p.id));
              } else {
                ref.context.push(AppRoutes.providerProfilePath(p.id));
              }
            },
            onFavorite: () {},
          );
        },
      );
    },
  );
}
