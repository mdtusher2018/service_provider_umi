import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/theme/app_text_styles.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/featured/service/widgets/booking_card_widget.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

part '_rating_dialog.dart';
part '_segmented_tab_bar.dart';

class UserServiceScreen extends ConsumerStatefulWidget {
  const UserServiceScreen({super.key});

  @override
  ConsumerState<UserServiceScreen> createState() => _UserServiceScreenState();
}

class _UserServiceScreenState extends ConsumerState<UserServiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = const [
    BookingStatus.accepted,
    BookingStatus.completed,
    BookingStatus.cancelled,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  BookingStatus get _currentStatus => _tabs[_tabController.index];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(bookingsProvider(_currentStatus).notifier).fetch();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    setState(() {});
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingsProvider(_currentStatus));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 16),
              child: AppText.h1('Service'),
            ),

            Padding(
              padding: 20.paddingH,
              child: _SegmentedTabBar(
                controller: _tabController,
                onChanged: _onTabChanged,
              ),
            ),

            16.verticalSpace,

            Expanded(
              child: state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: AppText.h3(e.toString())),
                data: (data) {
                  final bookings = data.bookings;

                  if (bookings.isEmpty) {
                    return const Center(
                      child: AppText.bodyLg('No bookings found'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(bookingsProvider(_currentStatus).notifier)
                          .fetch();
                    },
                    child: BookingList(
                      items: bookings,
                      emptyMessage: 'No bookings',
                      emptySubtitle: 'Your bookings will appear here',
                      onCardTap: (item) => _onCardTap(item, context),
                      onRatingTap: _showRatingDialog,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCardTap(BookingItem item, BuildContext context) {
    context.push(AppRoutes.bookingDetail, extra: item);
  }

  void _showRatingDialog(BookingItem item) {
    showGeneralDialog(
      context: context,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (_, _, _) => RatingDialog(
        serviceName: item.serviceName,
        onSubmit: (rating, tags, comment) {
          context.pop();
        },
      ),
    );
  }
}
