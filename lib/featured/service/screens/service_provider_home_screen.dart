import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/featured/profile/riverpod/user_provider.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';

import 'package:service_provider_umi/featured/service/widgets/booking_card_widget.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import '../../../../../../core/di/app_role_provider.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

class ServiceProviderHomeScreen extends ConsumerStatefulWidget {
  const ServiceProviderHomeScreen({super.key});

  @override
  ConsumerState<ServiceProviderHomeScreen> createState() =>
      _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<ServiceProviderHomeScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myProfileProvider.notifier).fetch();
    });
  }

  void _onCardTap(BookingModel item, BuildContext context) {
    if (kIsWeb) {
      context.go(AppRoutes.bookingDetailPath(item.id));
    } else {
      context.push(AppRoutes.bookingDetailPath(item.id));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final primary = AppColors.primaryFor(ref.read(appRoleProvider));
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: primary),
          dialogTheme: const DialogThemeData(backgroundColor: AppColors.white),
        ),
        child: child!,
      ),
    );
    if (picked == null || picked == _selectedDate) return;
    setState(() => _selectedDate = picked);
    ref
        .read(bookingsProvider(BookingStatus.upcoming).notifier)
        .fetch(initial: true, date: DateFormat('yyyy-MM-dd').format(picked));
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(appRoleProvider);
    final primary = AppColors.primaryFor(role);
    final state = ref.watch(bookingsProvider(BookingStatus.upcoming));

    ref.listen(myProfileProvider, (_, next) {
      next.whenOrNull(
        success: (profile) {
          final isVerified = profile.isVerified ?? false;
          if (!context.mounted) return;
          if (!isVerified) {
            context.go(AppRoutes.providerOnboarding);
          } else {
            ref
                .read(bookingsProvider(BookingStatus.upcoming).notifier)
                .fetch(initial: true);
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(primary),
            Expanded(
              child: state.when(
                loading: () => const AppLoader(),
                error: (e, _) => const Center(
                  child: AppText.bodyLg('No bookings found'),
                ),
                data: (bookings) {
                  if (bookings.isEmpty) {
                    return const Center(
                      child: AppText.bodyLg('No bookings found'),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      await ref
                          .read(bookingsProvider(BookingStatus.upcoming).notifier)
                          .fetch(initial: true);
                    },
                    child: BookingList(
                      items: bookings,
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

  Widget _buildHeader(Color primary) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.timer, color: AppColors.primaryFor(AppRole.provider)),
          10.horizontalSpace,
          AppText('Upcoming Bookings', style: AppTextStyles.h3),
          const Spacer(),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: 8.circular,
                border: Border.all(color: AppColors.grey200),
              ),
              child: Row(
                children: [
                  AppText(
                    DateFormat('d MMM, yyyy').format(_selectedDate),
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  4.horizontalSpace,
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.grey400,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
