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
import 'package:service_provider_umi/l10n/app_localizations.dart';
import 'package:service_provider_umi/shared/widgets/app_error_widget.dart';

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
    final profileState = ref.watch(myProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: AppLocalizations.of(context)!.reviews),
      body: reviewsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => AppErrorWidget(
          error: e,
          onRetry: () {
            if (id != null) ref.read(myReviewProvider.notifier).fetch(id!);
          },
        ),

        data: (reviews) {
          if (reviews.isEmpty) {
            return Center(child: Text(AppLocalizations.of(context)!.noReviewsFound));
          }

          return ListView.separated(
            controller: _scrollCtrl,
            padding: 16.paddingAll,
            itemCount: reviews.length + (hasMore ? 1 : 0) + 1, // +1 for header
            separatorBuilder: (_, __) => 16.verticalSpace,
            itemBuilder: (_, index) {
              if (index == 0) {
                // Header
                return profileState.maybeWhen(
                  success: (profile) {
                    final avgRating = profile.avgRating ?? 0.0;
                    final totalReviews = profile.totalReview ?? 0;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.grey200.withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const AppText(
                              'Overall Rating',
                              style: TextStyle(fontSize: 16, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                            ),
                            12.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AppText(
                                  avgRating.toStringAsFixed(2),
                                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, height: 1),
                                ),
                                8.horizontalSpace,
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 6),
                                  child: Icon(Icons.star_rounded, color: Colors.amber, size: 36),
                                ),
                              ],
                            ),
                            12.verticalSpace,
                            AppText(
                              'Based on $totalReviews reviews',
                              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  orElse: () => const SizedBox.shrink(),
                );
              }

              final i = index - 1; // Adjust index for reviews

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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey200.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 48,
                height: 48,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.labelLg(review.userName, fontWeight: FontWeight.bold),
                    4.verticalSpace,
                    Row(
                      children: [
                        AppRatingBar(rating: review.rating),
                        8.horizontalSpace,
                        AppText(
                          review.rating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (review.createdAt != null)
                AppText(
                  _formatDate(review.createdAt!),
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
            ],
          ),
          16.verticalSpace,
          AppText.bodyMd(
            review.comment,
            height: 1.5,
            color: AppColors.textPrimary,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inDays > 365) return '${(difference.inDays / 365).floor()}y ago';
    if (difference.inDays > 30) return '${(difference.inDays / 30).floor()}mo ago';
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }
}
