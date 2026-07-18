import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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

import '../../../l10n/app_localizations.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/data/models/user_models.dart';

final providerHomeRefreshProvider = StateProvider<int>((ref) => 0);

class ServiceProviderHomeScreen extends ConsumerStatefulWidget {
  const ServiceProviderHomeScreen({super.key});

  @override
  ConsumerState<ServiceProviderHomeScreen> createState() =>
      _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<ServiceProviderHomeScreen> {
  DateTime? _selectedDate;
  bool isSubmitted = false;
  bool _isPending = false;

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
      initialDate: _selectedDate ?? DateTime.now(),
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

    ref.listen(providerHomeRefreshProvider, (_, __) {
      if (mounted) {
        setState(() {
          _selectedDate = null;
        });
        ref.read(bookingsProvider(BookingStatus.upcoming).notifier).fetch(initial: true, clearDate: true);
      }
    });

    ref.listen(myProfileProvider, (_, next) {
      next.whenOrNull(
        success: (profile) {
          final isVerified = profile.isVerified ?? false;
          final isPending = !isVerified && (
            (profile.workSchedule != null && profile.workSchedule!.isNotEmpty) ||
            (profile.deviceHistory != null && profile.deviceHistory!.isNotEmpty) ||
            profile.serviceProviderInfo != null
          );
          if (!context.mounted) return;

          setState(() {
            _isPending = isPending;
          });

          if (!isVerified && !isPending) {
            context.go(AppRoutes.providerOnboarding);
          } else if (isVerified) {
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
              child: _isPending
                  ? _buildVerificationPendingWidget(context, ref)
                  : _buildBookingsContent(state, context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsContent(AsyncValue<List<BookingModel>> state, BuildContext context) {
    return state.when(
      loading: () => const AppLoader(),
      error: (e, _) => Center(
        child: AppText.bodyLg(AppLocalizations.of(context)!.noBookingsFound),
      ),
      data: (bookings) {
        if (bookings.isEmpty) {
          return Center(
            child: AppText.bodyLg(AppLocalizations.of(context)!.noBookingsFound),
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
            emptyMessage: AppLocalizations.of(context)!.noBookings,
            emptySubtitle: AppLocalizations.of(context)!.yourBookingsWillAppearHere,
            onCardTap: (item) => _onCardTap(item, context),
            onLoadMore: () => ref
                .read(bookingsProvider(BookingStatus.upcoming).notifier)
                .fetch(),
            isLoadingMore: state.isLoading && state.hasValue,
          ),
        );
      },
    );
  }

  Widget _buildVerificationPendingWidget(BuildContext context, WidgetRef ref) {
    final isProfileLoading = ref.watch(myProfileProvider).maybeWhen(
      loading: () => true,
      orElse: () => false,
    );
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                color: AppColors.primary,
                size: 36,
              ),
            ),
            16.verticalSpace,
            const Text(
              'Verification Pending',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            12.verticalSpace,
            const Text(
              'Your account is pending verification. Some features may be limited until your account is verified.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey500,
                height: 1.5,
              ),
            ),
            24.verticalSpace,
            AppButton.primary(
              label: 'Refresh',
              isLoading: isProfileLoading,
              onPressed: () {
                ref.read(myProfileProvider.notifier).fetch();
              },
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
          AppText(AppLocalizations.of(context)!.upcomingBookings, style: AppTextStyles.h3),
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
                    _selectedDate != null
                        ? DateFormat('d MMM, yyyy').format(_selectedDate!)
                        : AppLocalizations.of(context)!.dateFilter,
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
