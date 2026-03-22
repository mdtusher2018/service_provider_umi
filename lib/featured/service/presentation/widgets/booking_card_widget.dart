// ─── Booking Card ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/theme/app_role.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

// ─── Models ───────────────────────────────────────────────────

class BookingItem {
  final String id;
  final String serviceTitle;
  final String imageUrl;
  final String timeRange;
  final String date;
  final BookingStatus status;
  final bool needsRating;
  final bool needsSupport;

  const BookingItem({
    required this.id,
    required this.serviceTitle,
    required this.imageUrl,
    required this.timeRange,
    required this.date,
    required this.status,
    this.needsRating = false,
    this.needsSupport = false,
  });
}

class BookingCard extends ConsumerWidget {
  final BookingItem item;
  final VoidCallback? onTap;
  final VoidCallback? onRatingTap;

  const BookingCard({
    super.key,
    required this.item,
    this.onTap,
    this.onRatingTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(appRoleProvider);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Image ──────────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 72,
                  height: 72,
                  color: AppColors.primaryLight,
                  child: item.imageUrl.isNotEmpty
                      ? Image.network(item.imageUrl, fit: BoxFit.cover)
                      : const Icon(Icons.elderly_outlined, size: 36),
                ),
              ),
              12.horizontalSpace,

              // ─── Details ────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    AppText.labelLg(
                      item.serviceTitle,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                    6.verticalSpace,

                    // Time
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 13),
                        4.horizontalSpace,
                        AppText.bodySm(item.timeRange),
                      ],
                    ),
                    4.verticalSpace,

                    // Date
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined, size: 13),
                        4.horizontalSpace,
                        AppText.bodySm(item.date),
                      ],
                    ),
                    10.verticalSpace,

                    // ─── Status badges ───────────────
                    _buildStatusRow(role),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow(AppRole role) {
    switch (item.status) {
      case BookingStatus.pending:
        if (role == AppRole.provider) {
          return Row(
            children: [
              _StatusBadge(
                label: 'Accept',
                color: AppColors.success,
                backgroundColor: AppColors.successLight,
                isInteractive: true,
              ),
              8.horizontalSpace,
              const _StatusBadge(
                label: 'Cancel',
                color: AppColors.error,
                backgroundColor: AppColors.errorLight,
              ),
            ],
          );
        }

        return const _StatusBadge(
          label: 'Pending acceptance',
          color: AppColors.primary,
          backgroundColor: AppColors.primaryLight,
        );

      case BookingStatus.accepted:
        return const _StatusBadge(
          label: 'Accepted',
          color: AppColors.success,
          backgroundColor: AppColors.successLight,
        );

      case BookingStatus.ongoing:
        if (role == AppRole.provider) {
          return const _StatusBadge(
            label: 'Ongoing',
            color: AppColors.info,
            backgroundColor: AppColors.infoLight,
          );
        }

        return const _StatusBadge(
          label: 'Service in progress',
          color: AppColors.info,
          backgroundColor: AppColors.infoLight,
        );

      case BookingStatus.completed:
        if (role == AppRole.user) {
          return Row(
            children: [
              GestureDetector(
                onTap: onRatingTap,
                child: const _StatusBadge(
                  label: 'Rating',
                  color: AppColors.primary,
                  backgroundColor: AppColors.primaryLight,
                  isInteractive: true,
                ),
              ),
              8.horizontalSpace,
              _StatusBadge(
                label: 'Need Support Immediately',
                color: AppColors.textSecondary,
                backgroundColor: AppColors.info.withOpacity(0.3),
              ),
            ],
          );
        }

        return const _StatusBadge(
          label: 'Completed',
          color: AppColors.success,
          backgroundColor: AppColors.successLight,
        );

      case BookingStatus.cancelled:
        return const _StatusBadge(
          label: 'Cancelled',
          color: AppColors.error,
          backgroundColor: AppColors.errorLight,
        );

      case BookingStatus.rejected:
        return const _StatusBadge(
          label: 'Rejected',
          color: AppColors.error,
          backgroundColor: AppColors.errorLight,
        );
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color backgroundColor;
  final bool isInteractive;

  const _StatusBadge({
    required this.label,
    required this.color,
    required this.backgroundColor,
    this.isInteractive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: isInteractive
            ? Border.all(color: color.withOpacity(0.3))
            : null,
      ),
      child: AppText.bodySm(label, color: color, fontWeight: FontWeight.w500),
    );
  }
}

// ─── Booking List ─────────────────────────────────────────────
class BookingList extends StatelessWidget {
  final List<BookingItem> items;
  final String emptyMessage;
  final String emptySubtitle;
  final void Function(BookingItem) onCardTap;
  final void Function(BookingItem)? onRatingTap;

  const BookingList({
    super.key,
    required this.items,
    required this.emptyMessage,
    required this.emptySubtitle,
    required this.onCardTap,
    this.onRatingTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return AppEmptyState(
        title: emptyMessage,
        subtitle: emptySubtitle,
        icon: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.calendar_today_outlined,
            color: AppColors.primary,
            size: 32,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => 12.verticalSpace,
      itemBuilder: (_, i) => BookingCard(
        item: items[i],
        onTap: () => onCardTap(items[i]),
        onRatingTap: onRatingTap != null ? () => onRatingTap!(items[i]) : null,
      ),
    );
  }
}
