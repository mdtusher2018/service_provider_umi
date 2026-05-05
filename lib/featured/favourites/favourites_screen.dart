import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/featured/favourites/riverpod/favourites_notifire.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';

import 'package:service_provider_umi/shared/widgets/app_card.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: AppText.h3(e.toString())),
        data: (favourites) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.read(favouritesNotifireProvider.notifier).fetch();
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              itemCount: favourites.length,
              separatorBuilder: (_, __) => 12.verticalSpace,
              itemBuilder: (_, i) {
                final p = favourites[i];
                return ProviderCard(
                  name: p.name,
                  imageUrl: p.avatarUrl,
                  isFavorited: p.isLiked,

                  rating: p.rating,
                  reviewCount: p.reviewsCount,
                  serviceCount: p.servicesCount,
                  pricePerHour: p.pricePerHour,
                  isVerified: p.verified,
                  hasRepeated: p.repeatedCount > 0,
                  hasUpdatedSchedule: true,
                  onTap: () {
                    // context.go('/user/services/provider/${p.id}');
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
