// ─── Booking Card ─────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/datetime_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

class BookingCard extends ConsumerStatefulWidget {
  final BookingModel item;
  final VoidCallback? onTap;
  final VoidCallback? onRatingTap;

  const BookingCard({
    super.key,
    required this.item,
    this.onTap,
    this.onRatingTap,
  });

  @override
  ConsumerState<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends ConsumerState<BookingCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );

    _scale = _controller;
  }

  void _onTapDown(TapDownDetails _) {
    _controller.reverse(); // goes to 0.95
  }

  void _onTapUp(TapUpDetails _) async {
    await _controller.forward();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(appRoleProvider);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: 16.circular,
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
            padding: 14.paddingAll,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: 10.circular,
                  child: Container(
                    width: 72,
                    height: 72,
                    color: AppColors.primaryLight,
                    child: widget.item.provider != null
                        ? Image.network(
                            widget.item.provider!.profile,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.elderly_outlined, size: 36),
                  ),
                ),
                12.horizontalSpace,

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.labelLg(
                        "${widget.item.provider?.name ?? ""} (${widget.item.provider?.serviceName ?? ""})",
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                      6.verticalSpace,

                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 13),
                          4.horizontalSpace,
                          Flexible(
                            child: AppText.bodySm(
                              "From ${widget.item.bookingDays.first.startTime!.toDisplayTime} to ${widget.item.bookingDays.first.endTime!.toDisplayTime}",
                            ),
                          ),
                        ],
                      ),
                      4.verticalSpace,

                      if (widget.item.bookingDays.first.startTime != null)
                        Row(
                          children: [
                            const Icon(Icons.calendar_month_outlined, size: 13),
                            4.horizontalSpace,
                            Flexible(
                              child: AppText.bodySm(
                                widget
                                    .item
                                    .bookingDays
                                    .first
                                    .startTime!
                                    .toDisplayDate,
                              ),
                            ),
                          ],
                        ),
                      10.verticalSpace,

                      _buildStatusRow(role),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow(AppRole role) {
    switch (widget.item.status) {
      case BookingStatus.requested:
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

      case BookingStatus.pending:
        if (role == AppRole.user) {
          return Row(
            children: [
              const _StatusBadge(
                label: 'Pay now',
                color: AppColors.success,
                backgroundColor: AppColors.successLight,
              ),
              8.horizontalSpace,
              const _StatusBadge(
                label: 'Pending',
                color: AppColors.primary,
                backgroundColor: AppColors.primaryLight,
              ),
            ],
          );
        }
        return const _StatusBadge(
          label: 'Payment Pending',
          color: AppColors.primary,
          backgroundColor: AppColors.primaryLight,
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

      case BookingStatus.complete:
        if (role == AppRole.user) {
          return Row(
            children: [
              GestureDetector(
                onTap: widget.onRatingTap,
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

      case BookingStatus.canceled:
        return const _StatusBadge(
          label: 'Cancelled',
          color: AppColors.error,
          backgroundColor: AppColors.errorLight,
        );
      case BookingStatus.upcoming:
        // TODO: Handle this case.
        throw UnimplementedError();
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
        borderRadius: 8.circular,
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
  final List<BookingModel> items;
  final String emptyMessage;
  final String emptySubtitle;
  final void Function(BookingModel) onCardTap;
  final void Function(BookingModel)? onRatingTap;
  final VoidCallback? onLoadMore;
  final bool isLoadingMore;

  const BookingList({
    super.key,
    required this.items,
    required this.emptyMessage,
    required this.emptySubtitle,
    required this.onCardTap,
    this.onRatingTap,
    this.onLoadMore,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return ListView(
        children: [
          AppEmptyState(
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
          ),
        ],
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (onLoadMore != null &&
            scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 50) {
          onLoadMore!();
        }
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        itemCount: items.length + (isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) => 12.verticalSpace,
        itemBuilder: (_, i) {
          if (i == items.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return BookingCard(
            item: items[i],
            onTap: () => onCardTap(items[i]),
            onRatingTap: onRatingTap != null ? () => onRatingTap!(items[i]) : null,
          );
        },
      ),
    );
  }
}
