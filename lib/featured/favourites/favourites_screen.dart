import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/featured/favourites/riverpod/favourites_notifire.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';

import 'package:service_provider_umi/shared/widgets/app_card.dart';
import 'package:service_provider_umi/shared/widgets/app_error_widget.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

// ─── Screen ───────────────────────────────────────────────────
class FavouritesScreen extends ConsumerStatefulWidget {
  const FavouritesScreen({super.key});

  @override
  ConsumerState<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends ConsumerState<FavouritesScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(favouritesNotifireProvider.notifier).fetch();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(favouritesNotifireProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: "Favourites",
        centerTitle: false,
        showBackButton: false,
        backgroundColor: AppColors.background,
      ),
      body: state.when(
        loading: () => const AppLoader(),
        error: (e, _) => AppErrorWidget(
          error: e,
          onRetry: () => ref.read(favouritesNotifireProvider.notifier).fetch(),
        ),
        data: (favourites) {
          if (favourites.isEmpty) {
            return AppEmptyState(
              title: "No Favorites Found",
              icon: Icon(Icons.favorite),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.read(favouritesNotifireProvider.notifier).fetch();
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: favourites.length,
              separatorBuilder: (_, __) => 12.verticalSpace,
              itemBuilder: (_, i) {
                final p = favourites[i].serviceProvider;
                if (p == null) return SizedBox.shrink();
                return ProviderCard(
                  name: favourites[i].userProfile?.name ?? "Unnamed user",
                  imageUrl: p.coverImage,
                  isFavorited: true,

                  rating: (favourites[i].userProfile?.avgRating ?? 0.0)
                      .toDouble(),
                  reviewCount: (favourites[i].userProfile?.totalReview ?? 0.0)
                      .toInt(),
                  serviceCount: 1,
                  pricePerHour: p.perHourPrice,

                  hasRepeated: 5 > 0,
                  hasUpdatedSchedule: true,
                  onTap: () {
                    context.push(
                      AppRoutes.providerProfilePath(
                        favourites[i].serviceProviderId,
                      ),
                    );
                  },
                  onFavorite: () {},
                );
              },
            ),
          );
        },
      ),
    );
  }
}
