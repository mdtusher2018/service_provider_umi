import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

import 'app_avatar.dart';

/// Base card container
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final BorderRadius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.borderRadius,
    this.border,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? AppColors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          border: border ?? Border.all(color: AppColors.border, width: 1),
          boxShadow:
              boxShadow ??
              [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: padding ?? const EdgeInsets.all(16),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Service provider result card - as seen in search results screen
class ProviderCard extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final String serviceType;
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

  const ProviderCard({
    super.key,
    required this.name,
    this.imageUrl,
    required this.serviceType,
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
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            children: [
              AppAvatar(
                imageUrl: imageUrl,
                name: name,
                size: AvatarSize.md,

                isFavorite: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.favorite_border, size: 16),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AppText(
                          name,
                          style: AppTextStyles.h4,
                          maxLines: 1,
                          color: AppColors.textSecondary,
                          overflow: TextOverflow.ellipsis,
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
                        Icon(Icons.star, color: AppColors.star, size: 20),
                        6.horizontalSpace,
                        AppText.labelMd(
                          '${rating.toStringAsFixed(1)}  (${reviewCount.toString()}) | $serviceCount Services',
                        ),
                      ],
                    ),
                    4.verticalSpace,
                  ],
                ),
              ),
              8.horizontalSpace,
              AppText(
                '\$${pricePerHour.toStringAsFixed(0)}/h',
                style: AppTextStyles.price.copyWith(color: AppColors.secondary),
              ),
            ],
          ),
          8.verticalSpace,
          Row(
            children: [
              if (hasRepeated)
                _buildBadge('$reviewCount has repeated', Icons.refresh_rounded),
              if (hasRepeated && hasUpdatedSchedule) 6.horizontalSpace,
              if (hasUpdatedSchedule)
                _buildBadge('Updated Schedule', Icons.calendar_today),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.grey600),
          3.horizontalSpace,
          Text(
            text,
            style: AppTextStyles.bodyXs.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
