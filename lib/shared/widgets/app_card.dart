import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

import 'app_avatar.dart';

/// Service provider result card - as seen in search results screen
class ProviderCard extends StatelessWidget {
  final String name;
  final String? imageUrl;

  final double rating;
  final int reviewCount;
  final int serviceCount;
  final double pricePerHour;
  final bool isVerified;
  final bool hasRepeated;
  final bool hasUpdatedSchedule;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorited;
  final String? experience;
  final List<String> expertise;
  final DateTime? addedAt;

  const ProviderCard({
    super.key,
    required this.name,
    this.imageUrl,

    required this.rating,
    this.reviewCount = 0,
    this.serviceCount = 0,
    required this.pricePerHour,
    this.isVerified = false,
    this.hasRepeated = false,
    this.hasUpdatedSchedule = false,
    this.onTap,
    this.onFavorite,
    this.isFavorited = true,
    this.experience,
    this.expertise = const [],
    this.addedAt,
  });

  @override
  Widget build(BuildContext context) {
    return _AppCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(horizontal: 12,),
      child: Column(
        children: [
          12.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppAvatar(
                imageUrl: imageUrl,
                name: name,
                size: AvatarSize.md,
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: AppText(
                            name,
                            style: AppTextStyles.h4,
                            maxLines: 1,
                            color: AppColors.textSecondary,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isVerified) ...[
                          4.horizontalSpace,
                          const Icon(
                            Icons.verified,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ],
                      ],
                    ),
                    2.verticalSpace,
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          if (index < rating.floor()) {
                            return const Icon(Icons.star, color: AppColors.star, size: 16);
                          } else if (index < rating) {
                            return const Icon(Icons.star_half, color: AppColors.star, size: 16);
                          } else {
                            return const Icon(Icons.star_border, color: AppColors.grey400, size: 16);
                          }
                        }),
                        6.horizontalSpace,
                        Flexible(
                          child: AppText.labelMd(
                            '${rating.toStringAsFixed(1)} (${reviewCount.toString()})',
                            color: AppColors.grey500,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (addedAt != null) ...[
                      6.verticalSpace,
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: 20.circular,
                          border: Border.all(color: AppColors.grey300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_month_outlined, size: 16, color: AppColors.primary),
                            6.horizontalSpace,
                            AppText.labelSm(
                              'Added ${DateFormat('MMM dd, yyyy').format(addedAt!)}',
                              color: AppColors.grey600,
                            ),
                          ],
                        ),
                      ),
                    ],
                    4.verticalSpace,
                  ],
                ),
              ),
              8.horizontalSpace,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (onFavorite != null)
                    GestureDetector(
                      onTap: onFavorite,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Icon(
                          isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFavorited ? AppColors.error : AppColors.grey400,
                          size: 24,
                        ),
                      ),
                    ),
                  AppText(
                    '\$${pricePerHour.toStringAsFixed(0)}/h',
                    style: AppTextStyles.price.copyWith(color: AppColors.secondary),
                  ),
                ],
              ),
            ],
          ),
          12.verticalSpace,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (experience != null && experience!.isNotEmpty)
                _buildOutlineBadge(experience!),
              ...expertise.map((exp) => _buildOutlineBadge(exp)),
            ],
          ),
          8.verticalSpace
        ],
      ),
    );
  }

  Widget _buildOutlineBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: 16.circular,
        border: Border.all(color: AppColors.grey300),
      ),
      child: AppText.labelSm(
        text,
        color: AppColors.grey600,
      ),
    );
  }
}

/// app card container
class _AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  const _AppCard({required this.child, this.padding, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: 16.circular,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(padding: padding ?? 16.paddingAll, child: child),
            ),
          ),
        ),
      ),
    );
  }
}
