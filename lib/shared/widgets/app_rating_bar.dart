import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Star rating display + optional interactive rating
class AppRatingBar extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final double starSize;
  final bool showCount;
  final bool showValue;
  final bool isInteractive;
  final ValueChanged<double>? onRatingChanged;

  const AppRatingBar({
    super.key,
    required this.rating,
    this.reviewCount = 0,
    this.starSize = 14,
    this.showCount = true,
    this.showValue = true,
    this.isInteractive = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showValue) ...[
          Text(rating.toStringAsFixed(1), style: AppTextStyles.rating),
          4.horizontalSpace,
        ],
        Row(
          children: List.generate(5, (i) {
            final starValue = i + 1.0;
            return GestureDetector(
              onTap: isInteractive
                  ? () => onRatingChanged?.call(starValue)
                  : null,
              child: Padding(
                padding: const EdgeInsets.only(right: 2),
                child: _buildStar(i, starSize),
              ),
            );
          }),
        ),
        if (showCount && reviewCount > 0) ...[
          4.horizontalSpace,
          Text('($reviewCount)', style: AppTextStyles.bodySm),
        ],
      ],
    );
  }

  Widget _buildStar(int index, double size) {
    final filled = (index + 1).toDouble() <= rating;
    final halfFilled = !filled && (index + 0.5).toDouble() <= rating;

    if (filled) {
      return Icon(Icons.star_rounded, color: AppColors.star, size: size);
    }
    if (halfFilled) {
      return Icon(Icons.star_half_rounded, color: AppColors.star, size: size);
    }
    return Icon(
      Icons.star_outline_rounded,
      color: AppColors.starEmpty,
      size: size,
    );
  }
}

/// Detailed rating breakdown - as seen in service provider profile
class AppRatingBreakdown extends StatelessWidget {
  final double overall;
  final int totalReviews;
  final Map<String, double> breakdown;

  const AppRatingBreakdown({
    super.key,
    required this.overall,
    required this.totalReviews,
    required this.breakdown,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AppText(
              overall.toStringAsFixed(1),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                height: 1,
              ),
            ),

            Icon(Icons.star_rate_rounded, size: 48, color: AppColors.star),
            8.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.h4("Outstanding"),
                4.verticalSpace,
                AppText.bodySm(
                  '($totalReviews ${totalReviews == 1 ? "rating" : "ratings"})',
                ),
              ],
            ),
          ],
        ),
        16.verticalSpace,
        ...breakdown.entries.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _RatingRow(label: e.key, value: e.value),
          ),
        ),
      ],
    );
  }
}

class _RatingRow extends StatelessWidget {
  final String label;
  final double value;

  const _RatingRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 110, child: Text(label, style: AppTextStyles.bodyMd)),
        16.horizontalSpace,
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: value / 5.0,
              backgroundColor: AppColors.grey200,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.star),
              minHeight: 6,
            ),
          ),
        ),
        10.horizontalSpace,
        AppText(value.toStringAsFixed(1)),
      ],
    );
  }
}
