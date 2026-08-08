part of 'service_search_results_screen.dart';

Widget _buildResultsList({required WidgetRef ref, required String serviceId}) {
  final state = ref.watch(searchServiceProvidersProvider);

  return state.when(
    loading: () {
      String? serviceName;
      final catState = ref.read(categoriesProvider);
      if (catState.hasValue) {
        final category = catState.value!.firstWhere(
          (c) => c.id == serviceId,
          orElse: () => catState.value!.first,
        );
        if (category.id == serviceId) {
          serviceName = category.name;
        }
      }

      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                style: AppTextStyles.bodyLg.copyWith(color: AppColors.textPrimary),
                children: [
                  TextSpan(text: AppLocalizations.of(ref.context)!.finding),
                  if (serviceName != null)
                    TextSpan(
                      text: '$serviceName ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  TextSpan(text: AppLocalizations.of(ref.context)!.professionals),
                ],
              ),
            ),
            16.verticalSpace,
            SizedBox(
              width: 150,
              child: LinearProgressIndicator(
                backgroundColor: AppColors.grey200,
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
                minHeight: 6,
              ),
            ),
          ],
        ),
      );
    },

    error: (e, _) => AppErrorWidget(
      error: e,
      onRetry: () => ref.read(searchServiceProvidersProvider.notifier).search(),
    ),

    data: (response) {
      final providers = response.results;

      if (providers.isEmpty) {
        return Center(child: Text(AppLocalizations.of(ref.context)!.noProvidersFound));
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
