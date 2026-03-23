import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/featured/service/presentation/widgets/booking_card_widget.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/core/theme/app_text_styles.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
part '_rating_dialog.dart';
part '_segmented_tab_bar.dart';

// ─── Screen ───────────────────────────────────────────────────
class UserServiceScreen extends ConsumerStatefulWidget {
  const UserServiceScreen({super.key});

  @override
  ConsumerState<UserServiceScreen> createState() => _UserServiceScreenState();
}

class _UserServiceScreenState extends ConsumerState<UserServiceScreen>
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
      status: BookingStatus.accepted,
    ),
  ];

  final _past = const [
    BookingItem(
      id: '2',
      serviceTitle: 'Elderly care',
      imageUrl: '',
      timeRange: 'From 16:30 to 18:30',
      date: 'Monday, 1 Feb 2025',
      status: BookingStatus.completed,
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

            16.verticalSpace,

            // ─── Tab Views ────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  BookingList(
                    items: _upcoming,
                    emptyMessage: 'No upcoming bookings',
                    emptySubtitle: 'Book a service to see it here',
                    onCardTap: _onCardTap,
                  ),
                  BookingList(
                    items: _past,
                    emptyMessage: 'No past bookings',
                    emptySubtitle: 'Your completed services will appear here',
                    onCardTap: _onCardTap,
                    onRatingTap: _showRatingDialog,
                  ),
                  BookingList(
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
          context.pop();
          // TODO: submit rating via provider
        },
      ),
    );
  }
}
