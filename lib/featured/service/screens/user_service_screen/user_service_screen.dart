import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/logger/app_logger.dart';

import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/theme/app_text_styles.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';

import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/featured/service/widgets/booking_card_widget.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/app_error_widget.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

import '../../../../l10n/app_localizations.dart';

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
  late ScrollController _scrollController;

  final _tabs = const [
    BookingStatus.requested,
    BookingStatus.ongoing,
    BookingStatus.canceled,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(bookingsProvider(_currentStatus).notifier).fetch();
    }
  }

  void _openCompleted() {
    if (kIsWeb) {
      context.go(
        AppRoutes.providerCompletedServiceScreen,
      ); //replace extra with a approch by id and pass in params else navigation back will caused runtime null vaule
    } else {
      context.push(AppRoutes.providerCompletedServiceScreen);
    }
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                  child: AppText.h1(AppLocalizations.of(context)!.service),
                ),
                Padding(
                  padding: 20.paddingRight,
                  child:  InkWell(
                    onTap: _openCompleted,
                    child: _StatusBadge(
                      label: 'Completed',
                      color: AppColors.success,
                      backgroundColor: AppColors.white,
                    ),
                  ),
                ),
              ],
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
                loading: () => const AppLoader(),
                error: (e, _) => AppErrorWidget(
                  error: e,
                  onRetry: () => ref.invalidate(bookingsProvider(_currentStatus)),
                ),
                data: (data) {
                  final bookings = data;

                  if (bookings.isEmpty) {
                    return const Center(
                      child: AppText.bodyLg('No bookings found'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(bookingsProvider(_currentStatus));
                    },
                    child: BookingList(
                      items: bookings,
                      emptyMessage: 'No bookings',
                      emptySubtitle: 'Your bookings will appear here',
                      onCardTap: (item) => _onCardTap(item, context),
                      onLoadMore: () => ref
                          .read(bookingsProvider(_currentStatus).notifier)
                          .fetch(),
                      isLoadingMore: state.isLoading && state.hasValue,
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

  void _onCardTap(BookingModel item, BuildContext context) {
    if (kIsWeb) {
      context.go(AppRoutes.bookingDetailPath(item.id));
    } else {
      context.push(AppRoutes.bookingDetailPath(item.id));
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
      child: AppText.bodySm(label, color: color, fontWeight: FontWeight.w700),
    );
  }
}