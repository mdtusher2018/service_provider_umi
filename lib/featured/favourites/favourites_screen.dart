import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/featured/favourites/riverpod/favourites_notifire.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
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
    final role = ref.watch(appRoleProvider);
    final isUser = role == AppRole.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: "Favourites",
        centerTitle: false,
        showBackButton: Navigator.of(context).canPop(),
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
                final fav = favourites[i];
                final p = fav.serviceProvider;
                
                final displayName = isUser 
                    ? (fav.serviceProviderUser?.name ?? "Unnamed provider")
                    : (fav.userProfile?.name ?? "Unnamed user");

                final displayImage = isUser
                    ? (p?.coverImage ?? fav.serviceProviderUser?.profileImage)
                    : fav.userProfile?.profileImage;

                final avgRating = isUser
                    ? (fav.serviceProviderUser?.avgRating ?? 0.0)
                    : (fav.userProfile?.avgRating ?? 0.0);

                final totalReview = isUser
                    ? (fav.serviceProviderUser?.totalReview ?? 0.0)
                    : (fav.userProfile?.totalReview ?? 0.0);

                return ProviderCard(
                  name: displayName,
                  imageUrl: displayImage,
                  isFavorited: true,
                  rating: avgRating.toDouble(),
                  reviewCount: totalReview.toInt(),
                  serviceCount: 1,
                  pricePerHour: p?.perHourPrice ?? 0.0,
                  hasRepeated: 5 > 0,
                  hasUpdatedSchedule: true,
                  onTap: () {
                    context.push(
                      AppRoutes.providerProfilePath(
                        favourites[i].serviceProviderId,
                      ),
                    );
                  },
                  addedAt: fav.createdAt,
                  onFavorite: () {
                    ref.read(favouritesNotifireProvider.notifier).toggleFavorite(fav.serviceProviderId);
                    context.showFavoriteToast("Removed from favorites");
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
