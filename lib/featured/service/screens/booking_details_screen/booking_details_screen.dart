import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
import 'package:service_provider_umi/core/utils/extensions/datetime_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/utils/extensions/string_ext.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/gen/assets.gen.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import '../../../../../../../core/di/app_role_provider.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';

part '_congratulations_overlay.dart';
part '_timeline_row.dart';

class BookingDetailScreen extends ConsumerStatefulWidget {
  final String bookingId;
  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  ConsumerState<BookingDetailScreen> createState() =>
      _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  void _complete() {
    final role = ref.read(appRoleProvider);
    final primary = AppColors.primaryFor(role);

    showGeneralDialog(
      context: context,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      barrierDismissible: false,
      pageBuilder: (_, _, _) => _CongratsDialog(
        primary: primary,
        onDone: () {
          context.pop();
          context.pop();
        },
      ),
    );
  }

  void _accept() async {
    await ref
        .read(bookingsProvider(BookingStatus.requested).notifier)
        .acceptBooking(widget.bookingId);
    ref.invalidate(bookingDetailProvider(widget.bookingId));
  }

  void _cancel() async {
    await ref
        .read(bookingsProvider(BookingStatus.requested).notifier)
        .rejectBooking(widget.bookingId);
    ref.invalidate(bookingDetailProvider(widget.bookingId));
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(appRoleProvider);
    final primary = AppColors.primaryFor(role);
    final state = ref.watch(bookingDetailProvider(widget.bookingId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: "Details"),
      body: state.when(
        error: (error, stackTrace) => AppEmptyState(
          title: error.toString(),
          icon: Icon(Icons.error, color: AppColors.error),
        ),
        loading: () => AppLoader(),
        data: (data) {
          if (data == null) {
            return AppEmptyState(title: "No data found");
          }
          return _BookingDetailBody(
            data: data,
            primary: primary,
            onComplete: _complete,
            onAccept: _accept,
            onCancel: _cancel,
          );
        },
      ),
    );
  }
}

// ─── Body extracted so `data` is always in scope ─────────────────────────────
class _BookingDetailBody extends ConsumerWidget {
  final BookingDetailModel data;
  final Color primary;
  final VoidCallback onComplete;
  final VoidCallback onAccept;
  final VoidCallback onCancel;

  const _BookingDetailBody({
    required this.data,
    required this.primary,
    required this.onComplete,
    required this.onAccept,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(appRoleProvider);
    final bookingStatus = BookingStatus.fromString(data.status);
    final notifier = ref.watch(
      bookingsProvider(BookingStatus.requested).notifier,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProviderRow(ref, role),
          20.verticalSpace,
          _buildSection('Comment', _buildComment()),
          20.verticalSpace,
          _buildSection('Date and time', _buildDateTime()),
          20.verticalSpace,
          _buildSection('Address', _buildAddress()),
          20.verticalSpace,
          _buildSection('Service price', _buildPrice()),
          40.verticalSpace,

          // ── Action buttons driven by real status ──────────────────
          if (bookingStatus == BookingStatus.complete)
            AppButton.primary(label: "Complete", onPressed: onComplete),

          if (bookingStatus == BookingStatus.requested)
            Row(
              spacing: 16,
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: notifier.isAccepting,
                    builder: (context, isloading, child) {
                      return AppButton.primary(
                        label: "Accept",
                        onPressed: onAccept,
                        isLoading: isloading,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: notifier.isCancelling,
                    builder: (context, isloading, child) {
                      return AppButton.outline(
                        label: "Cancel",
                        onPressed: onCancel,
                        isLoading: isloading,
                      );
                    },
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ─── Provider row ─────────────────────────────────────────────────────────
  Widget _buildProviderRow(WidgetRef ref, AppRole role) {
    // Show the other party: if viewing as provider → show user, else → show provider
    final name = data.user?.name ?? data.provider?.name ?? '—';
    final phone = data.user?.phoneNumber ?? data.provider?.phoneNumber ?? '—';
    final profileUrl = data.user?.profile ?? data.provider?.profile;

    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: profileUrl != null && profileUrl.isNotEmpty
              ? NetworkImage(profileUrl)
              : null,
          child: profileUrl == null || profileUrl.isEmpty
              ? const Icon(Icons.person, size: 36)
              : null,
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            spacing: 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [AppText.h4(name), AppText.bodySm(phone)],
          ),
        ),
        AppAvatar(
          imageUrl: Assets.icons.chatIcon.keyName,
          size: AvatarSize.md,
          backgroundColor: AppColors.primaryFor(role),
        ),
      ],
    );
  }

  // ─── Comment ──────────────────────────────────────────────────────────────
  Widget _buildComment() {
    // Replace with a real comment field from model when available
    return AppText.bodySm(
      'Service booked successfully for elder care. Please ensure '
      'assistance includes daily check-ins, medication reminders, and help '
      'with mobility as discussed.',
    );
  }

  // ─── Date and time — iterate ALL booking days ─────────────────────────────
  Widget _buildDateTime() {
    if (data.bookingDays.isEmpty) {
      return AppText.bodySm('No schedule available.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.bookingDays.map((day) {
        // Use a helper instead of a context-dependent format
        final start = day.startTime!.toDisplayTime;
        final end = day.endTime!.toDisplayTime;

        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Day label + relative date
              Row(
                children: [
                  const Icon(Icons.calendar_month_outlined, size: 18),
                  8.horizontalSpace,
                  Flexible(
                    child: AppText.bodyMd(
                      '${day.day.capitalize}'
                      '${day.startTime != null ? '  •  ${day.startTime!.toDisplayDate}' : ''}',
                    ),
                  ),
                ],
              ),
              12.verticalSpace,
              _TimelineRow(
                startTime: start,
                endTime: end,
                duration: '${day.durationHours}h',
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ─── Address ──────────────────────────────────────────────────────────────
  Widget _buildAddress() {
    final coords = data.provider?.location?.coordinates;
    final addressText = (coords != null && coords.length >= 2)
        ? 'Lat: ${coords[1].toStringAsFixed(4)}, Lng: ${coords[0].toStringAsFixed(4)}'
        : 'Address not available';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.location_on_outlined,
          size: 18,
          color: AppColors.grey400,
        ),
        8.horizontalSpace,
        Expanded(
          child: AppText.bodyMd(addressText, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  // ─── Price breakdown ──────────────────────────────────────────────────────
  Widget _buildPrice() {
    final rows = [
      ('Service', '\$${data.price}', false),
      ('Booking hours', '${data.totalHours}h', false),
      ('Subtotal', '\$${data.price}', false),
      ('Client protection', 'Free', false),
    ];

    return Column(
      children: [
        ...rows.map(
          (r) => Padding(
            padding: 6.paddingBottom,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.bodyMd(r.$1),
                AppText.bodyMd(r.$2, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
        const Divider(height: 16, color: AppColors.grey200),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.bodyMd('Total'),
            AppText(
              '\$${data.price}',
              style: AppTextStyles.labelLg.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Section wrapper ──────────────────────────────────────────────────────
  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.h4(title, color: AppColors.textPrimary),
        10.verticalSpace,
        child,
      ],
    );
  }
}
