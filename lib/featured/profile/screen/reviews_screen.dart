import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/utils/helpers/decode_helper.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';
import 'package:service_provider_umi/featured/profile/riverpod/user_provider.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_rating_bar.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import '../../../core/theme/app_colors.dart';

class ReviewsScreen extends ConsumerStatefulWidget {
  const ReviewsScreen({super.key});

  @override
  ConsumerState<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends ConsumerState<ReviewsScreen> {
  final _scrollCtrl = ScrollController();
  String? id;
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      id = await getMyUserId(ref);
      if (id != null) ref.read(myReviewProvider.notifier).fetch(id!);
    });

    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 200) {
      if (id != null) ref.read(myReviewProvider.notifier).loadMore(id!);
    }
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviewsState = ref.watch(myReviewProvider);
    final notifier = ref.read(myReviewProvider.notifier);
    final hasMore = notifier.hasMore;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: "Reviews"),
      body: reviewsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(child: Text(e.toString())),

        data: (reviews) {
          if (reviews.isEmpty) {
            return const Center(child: Text("No reviews found"));
          }

          return ListView.separated(
            controller: _scrollCtrl,
            padding: 16.paddingAll,
            itemCount: reviews.length + (hasMore ? 1 : 0),
            separatorBuilder: (_, __) =>
                AppDivider(height: 20, color: AppColors.grey500),
            itemBuilder: (_, i) {
              // 🔥 Loader ONLY if more data exists
              if (i == reviews.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              final r = reviews[i];
              return _ReviewTile(review: r);
            },
          );
        },
      ),
    );
  }
}

// ─── Review Tile ──────────────────────────────────────────────
class _ReviewTile extends StatelessWidget {
  final ProviderComment review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.grey100,
                border: Border.all(color: AppColors.grey200),
              ),
              child: review.userImage.isNotEmpty
                  ? ClipOval(
                      child: Image.network(review.userImage, fit: BoxFit.cover),
                    )
                  : const Icon(
                      Icons.person_rounded,
                      color: AppColors.grey400,
                      size: 24,
                    ),
            ),
            12.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.labelLg(review.userName, fontWeight: FontWeight.w600),
                3.verticalSpace,
                AppRatingBar(rating: 3),
              ],
            ),
          ],
        ),
        10.verticalSpace,
        AppText.bodyMd(review.comment),
      ],
    );
  }
}
