import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/core/theme/app_text_styles.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

// ─── Models ───────────────────────────────────────────────────
enum BookingStatus { upcoming, past, cancelled }

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

// ─── Screen ───────────────────────────────────────────────────
class ServiceScreen extends ConsumerStatefulWidget {
  const ServiceScreen({super.key});

  @override
  ConsumerState<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends ConsumerState<ServiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data
  final _upcoming = const [
    BookingItem(
      id: '1',
      serviceTitle: 'Elderly care',
      imageUrl: '',
      timeRange: 'From 16:30 to 18:30',
      date: 'Monday, 1 Feb 2025',
      status: BookingStatus.upcoming,
    ),
  ];

  final _past = const [
    BookingItem(
      id: '2',
      serviceTitle: 'Elderly care',
      imageUrl: '',
      timeRange: 'From 16:30 to 18:30',
      date: 'Monday, 1 Feb 2025',
      status: BookingStatus.past,
      needsRating: true,
      needsSupport: true,
    ),
  ];

  final _cancelled = const [
    BookingItem(
      id: '3',
      serviceTitle: 'Elderly care',
      imageUrl: '',
      timeRange: 'From 16:30 to 18:30',
      date: 'Monday, 1 Feb 2025',
      status: BookingStatus.cancelled,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Title ────────────────────────────────
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: AppText.h1('Service'),
            ),

            // ─── Tab Bar ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SegmentedTabBar(controller: _tabController),
            ),

            const SizedBox(height: 16),

            // ─── Tab Views ────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _BookingList(
                    items: _upcoming,
                    emptyMessage: 'No upcoming bookings',
                    emptySubtitle: 'Book a service to see it here',
                    onCardTap: _onCardTap,
                  ),
                  _BookingList(
                    items: _past,
                    emptyMessage: 'No past bookings',
                    emptySubtitle: 'Your completed services will appear here',
                    onCardTap: _onCardTap,
                    onRatingTap: _showRatingDialog,
                  ),
                  _BookingList(
                    items: _cancelled,
                    emptyMessage: 'No cancelled bookings',
                    emptySubtitle: 'Cancelled services will appear here',
                    onCardTap: _onCardTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCardTap(BookingItem item) {
    // Navigate to booking detail
  }

  void _showRatingDialog(BookingItem item) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) => RatingDialog(
        serviceName: item.serviceTitle,
        onSubmit: (rating, tags, comment) {
          Navigator.of(context).pop();
          // TODO: submit rating via provider
        },
      ),
    );
  }
}

// ─── Segmented Tab Bar ────────────────────────────────────────
class _SegmentedTabBar extends StatelessWidget {
  final TabController controller;
  const _SegmentedTabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: ['Upcoming', 'Past', 'Cancelled'].asMap().entries.map((
              e,
            ) {
              final isSelected = controller.index == e.key;
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.animateTo(e.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.grey200
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(7),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: AppText.labelMd(
                        e.value,
                        color: AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

// ─── Booking List ─────────────────────────────────────────────
class _BookingList extends StatelessWidget {
  final List<BookingItem> items;
  final String emptyMessage;
  final String emptySubtitle;
  final void Function(BookingItem) onCardTap;
  final void Function(BookingItem)? onRatingTap;

  const _BookingList({
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
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => BookingCard(
        item: items[i],
        onTap: () => onCardTap(items[i]),
        onRatingTap: onRatingTap != null ? () => onRatingTap!(items[i]) : null,
      ),
    );
  }
}

// ─── Booking Card ─────────────────────────────────────────────
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
        return _StatusBadge(
          label: 'Pending acceptance',
          color: AppColors.primary,
          backgroundColor: AppColors.primaryLight,
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
          label: 'Cancel',
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

// ─── Rating Dialog ────────────────────────────────────────────
class RatingDialog extends StatefulWidget {
  final String serviceName;
  final void Function(int rating, List<String> tags, String comment) onSubmit;

  const RatingDialog({
    super.key,
    required this.serviceName,
    required this.onSubmit,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _rating = 5;
  final Set<String> _selectedTags = {'Overall Service', 'Repair Quality'};
  final _commentController = TextEditingController(text: 'Nice work');

  static const _tags = [
    'Overall Service',
    'Customer Support',
    'Speed and Efficiency',
    'Repair Quality',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ─────────────────────────────
            Row(
              children: [
                const Expanded(child: AppText.h3('Rate Your Experience')),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            AppText.bodySm(
              'Are you Satisfied with the service?',
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),

            // ─── Stars ──────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _rating = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        i < _rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        key: ValueKey('$i-${i < _rating}'),
                        color: AppColors.primary,
                        size: 38,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const AppDivider(height: 20),
            const SizedBox(height: 10),

            // ─── Tags ────────────────────────────────
            AppText.labelLg(
              'Tell us what can be Improved?',
              color: AppColors.textPrimary,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return GestureDetector(
                  onTap: () => setState(() {
                    isSelected
                        ? _selectedTags.remove(tag)
                        : _selectedTags.add(tag);
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: AppText.labelMd(
                      tag,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // ─── Comment box ─────────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _commentController,
                maxLines: 4,
                style: AppTextStyles.bodyMd,
                decoration: InputDecoration(
                  hintText: 'Write your comment...',
                  hintStyle: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textgrey,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ─── Submit ──────────────────────────────
            AppButton.primary(
              label: 'Submit',
              onPressed: () => widget.onSubmit(
                _rating,
                _selectedTags.toList(),
                _commentController.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
