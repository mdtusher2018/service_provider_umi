import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';

import 'package:service_provider_umi/featured/service/widgets/booking_card_widget.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
part 'provider_completed_service_screen.dart';

class ProviderServiceScreen extends ConsumerStatefulWidget {
  const ProviderServiceScreen({super.key});

  @override
  ConsumerState<ProviderServiceScreen> createState() =>
      _ProviderServiceScreenState();
}

class _ProviderServiceScreenState extends ConsumerState<ProviderServiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = const [
    BookingStatus.pending,
    BookingStatus.ongoing,
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

  void _onCardTap(BookingItem item, BuildContext context) {
    if (kIsWeb) {
      context.go(
        AppRoutes.bookingDetail,
        extra: item,
      ); //replace extra with a approch by id and pass in params else navigation back will caused runtime null vaule
    } else {
      context.push(AppRoutes.bookingDetail, extra: item);
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingsProvider(_currentStatus));
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppAppBar(
        title: "Request",
        showBackButton: false,
        centerTitle: false,
        actions: [
          InkWell(
            onTap: _openCompleted,
            child: Icon(Icons.domain_verification_rounded),
          ),
          16.horizontalSpace,
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: 20.paddingH,
              child: _ProviderTabBar(
                controller: _tabController,
                onChanged: _onTabChanged,
              ),
            ),

            16.verticalSpace,

            Expanded(
              child: state.when(
                loading: () => const AppLoader(),
                error: (e, _) => Center(child: AppText.h3(e.toString())),
                data: (data) {
                  if (data.bookings.isEmpty) {
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
                      items: data.bookings,
                      emptyMessage: 'No bookings',
                      emptySubtitle: 'Your bookings will appear here',
                      onCardTap: (item) => _onCardTap(item, context),
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
}

class _ProviderTabBar extends StatelessWidget {
  final TabController controller;
  final VoidCallback? onChanged;

  const _ProviderTabBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: 10.circular,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: ["Request", "Ongoing", "Cancelled"].asMap().entries.map((
              e,
            ) {
              final isSelected = controller.index == e.key;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.animateTo(e.key);
                    onChanged?.call(); // ✅ notify parent
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: 3.paddingAll,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.grey200
                          : Colors.transparent,
                      borderRadius: 7.circular,
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
