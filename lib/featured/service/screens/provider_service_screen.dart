import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/featured/service/screens/user_service_screen/user_service_screen.dart';

import 'package:service_provider_umi/featured/service/widgets/booking_card_widget.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_error_widget.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

import '../../../l10n/app_localizations.dart';
import 'package:service_provider_umi/featured/subscription/riverpod/subscription_provider.dart';
import 'package:service_provider_umi/featured/subscription/screens/subscription_screen.dart';
import 'package:service_provider_umi/featured/subscription/widgets/subscription_required_card.dart';
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

  BookingStatus get _currentStatus => _tabs[_tabController.index];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(bookingsProvider(_currentStatus).notifier).fetch();
    }
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

  void _onCardTap(BookingModel item, BuildContext context) {
    if (kIsWeb) {
      context.go(AppRoutes.bookingDetailPath(item.id));
    } else {
      context.push(AppRoutes.bookingDetailPath(item.id));
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
    final subState = ref.watch(subscriptionProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppAppBar(
        title: AppLocalizations.of(context)!.request,
        showBackButton: false,
        centerTitle: false,
        actions: [
          InkWell(
            onTap: _openCompleted,
            child: _StatusBadge(
              label: AppLocalizations.of(context)!.completed,
              color: AppColors.primary,
              backgroundColor: AppColors.white,
            ),
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
              child: (_currentStatus == BookingStatus.requested && !subState.hasActiveAccess)
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: SubscriptionRequiredCard(
                        isEligibleForTrial: subState.isEligibleForTrial,
                        onStartTrialTapped: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
                          );
                        },
                        onUpgradeTapped: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const SubscriptionScreen()),
                          );
                        },
                      ),
                    )
                  : state.when(
                      loading: () => const AppLoader(),
                      error: (e, _) => AppErrorWidget(
                        error: e,
                        onRetry: () => ref.invalidate(bookingsProvider(_currentStatus)),
                      ),
                      data: (data) {
                        if (data.isEmpty) {
                          return Center(
                            child: AppText.bodyLg(AppLocalizations.of(context)!.noBookingsFound),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async {
                            ref.invalidate(bookingsProvider(_currentStatus));
                          },
                          child: BookingList(
                            items: data,
                            emptyMessage: AppLocalizations.of(context)!.noBookings,
                            emptySubtitle: AppLocalizations.of(context)!.yourBookingsWillAppearHere,
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
            ? Border.all(color: color.withValues(alpha: 0.3))
            : null,
      ),
      child: AppText.bodySm(label, color: color, fontWeight: FontWeight.w700),
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
            children: [
              AppLocalizations.of(context)!.request,
              AppLocalizations.of(context)!.ongoing,
              AppLocalizations.of(context)!.cancelled
            ].asMap().entries.map((
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
                                color: Colors.black.withValues(alpha: 0.08),
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
