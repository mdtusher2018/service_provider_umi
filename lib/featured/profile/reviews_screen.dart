import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_rating_bar.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import '../../core/theme/app_colors.dart';

// ─── Model ────────────────────────────────────────────────────
class Review {
  final String id;
  final String reviewerName;
  final String? imageUrl;
  final double rating;
  final String comment;
  final DateTime date;

  const Review({
    required this.id,
    required this.reviewerName,
    this.imageUrl,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

// ─── Screen ───────────────────────────────────────────────────
class ReviewsScreen extends ConsumerWidget {
  const ReviewsScreen({super.key});

  static final List<Review> _reviews = List.generate(
    10,
    (i) => Review(
      id: '$i',
      reviewerName: 'Mr. Raju',
      rating: 5.0,
      imageUrl:
          "https://png.pngtree.com/png-clipart/20230927/original/pngtree-man-avatar-image-for-profile-png-image_13001882.png",
      comment:
          '"Excellent service! Professional, reliable, and exceeded my expectations. Highly recommended!"',
      date: DateTime(2025, 1, i + 10),
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: "Reviews"),
      body: Padding(
        padding: 16.paddingAll,
        child: ListView.separated(
          padding: 16.paddingAll,
          itemCount: _reviews.length,
          separatorBuilder: (_, __) =>
              AppDivider(height: 20, color: AppColors.grey500),
          itemBuilder: (_, i) => _ReviewTile(review: _reviews[i]),
        ),
      ),
    );
  }
}

// ─── Review Tile ──────────────────────────────────────────────
class _ReviewTile extends StatelessWidget {
  final Review review;
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
              child: review.imageUrl != null
                  ? ClipOval(
                      child: Image.network(review.imageUrl!, fit: BoxFit.cover),
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
                AppText.labelLg(
                  review.reviewerName,

                  fontWeight: FontWeight.w600,
                ),
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
