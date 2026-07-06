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

      final isLoadingMore = state.isLoading && state.hasValue;

      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 50) {
            ref.read(searchServiceProvidersProvider.notifier).search();
          }
          return false;
        },
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          itemCount: providers.length + (isLoadingMore ? 1 : 0),
          separatorBuilder: (_, __) => 12.verticalSpace,
          itemBuilder: (_, i) {
            if (i == providers.length) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }

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
        ),
      );
    },
  );
}
