// ─── Booking Card ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

// ─── Models ───────────────────────────────────────────────────
enum BookingStatus {
  upcoming,
  past,
  cancelled,
  accepted,
  inProgress,
  completed,
}

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

class BookingCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
              const SizedBox(width: 12),

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
                    const SizedBox(height: 6),

                    // Time
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 13),
                        const SizedBox(width: 4),
                        AppText.bodySm(item.timeRange),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Date
                    Row(
                      children: [
                        const Icon(Icons.calendar_month_outlined, size: 13),
                        const SizedBox(width: 4),
                        AppText.bodySm(item.date),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ─── Status badges ───────────────
                    _buildStatusRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow() {
    switch (item.status) {
      case BookingStatus.upcoming:
        return const _StatusBadge(
          label: 'Pending acceptance',
          color: AppColors.primary,
          backgroundColor: AppColors.primaryLight,
        );
      case BookingStatus.accepted:
        return const _StatusBadge(
          label: 'Accepted by provider',
          color: AppColors.success,
          backgroundColor: AppColors.successLight,
        );
      case BookingStatus.inProgress:
        return const _StatusBadge(
          label: 'In Progress',
          color: AppColors.info,
          backgroundColor: AppColors.infoLight,
        );
      case BookingStatus.completed:
        return const _StatusBadge(
          label: 'Completed',
          color: AppColors.success,
          backgroundColor: AppColors.successLight,
        );
      case BookingStatus.past:
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
            const SizedBox(width: 8),
            _StatusBadge(
              label: 'Need Support Immediately',
              color: AppColors.textSecondary,
              backgroundColor: AppColors.info.withOpacity(0.3),
            ),
          ],
        );
      case BookingStatus.cancelled:
        return const _StatusBadge(
          label: 'Cancelled',
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
