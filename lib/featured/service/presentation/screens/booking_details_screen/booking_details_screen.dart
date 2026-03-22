import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/featured/service/presentation/widgets/booking_card_widget.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import '../../../../../../../core/di/app_role_provider.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
part '_congratulations_overlay.dart';
part '_timeline_row.dart';

class BookingDetailScreen extends ConsumerStatefulWidget {
  final BookingItem booking;
  const BookingDetailScreen({super.key, required this.booking});

  @override
  ConsumerState<BookingDetailScreen> createState() =>
      _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  void _complete() {
    final role = ref.read(appRoleProvider);
    final primary = AppColors.primaryFor(role);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _CongratsDialog(
        primary: primary,
        onDone: () {
          Navigator.of(context).pop(); // close dialog
          Navigator.of(context).pop(); // go back screen
        },
      ),
    );
  }

  void _accept() {}
  void _cancel() {}

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(appRoleProvider);
    final primary = AppColors.primaryFor(role);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: "Details"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProviderRow(primary),
            20.verticalSpace,
            _buildSection('Comment', _buildComment()),
            20.verticalSpace,
            _buildSection('Date and time', _buildDateTime()),
            20.verticalSpace,
            _buildSection('Address', _buildAddress()),
            20.verticalSpace,
            _buildSection('Service price', _buildPrice()),
            40.verticalSpace,
            if (widget.booking.status == BookingStatus.ongoing)
              AppButton.primary(label: "Complete", onPressed: _complete),
            if (widget.booking.status == BookingStatus.pending)
              Row(
                spacing: 16,
                children: [
                  Expanded(
                    child: AppButton.primary(
                      label: "Accept",
                      onPressed: _accept,
                    ),
                  ),
                  Expanded(
                    child: AppButton.outline(
                      label: "Cancel",
                      onPressed: _cancel,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // ─── Provider row ────────────────────────────────────────
  Widget _buildProviderRow(Color primary) {
    return Row(
      children: [
        // Avatar
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(
            "https://th.bing.com/th/id/OIP.zSjnJGFe_TxQyoSX48_Z6wHaHa?o=7rm=3&rs=1&pid=ImgDetMain&o=7&rm=3",
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            spacing: 2,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.h4('Mr. Raju'),
              AppText.bodySm('+880 1840 560614'),
            ],
          ),
        ),
        // Chat icon
        AppAvatar(
          imageUrl: "assets/icons/chat_icon.png",
          size: AvatarSize.md,
          backgroundColor: AppColors.primaryFor(ref.watch(appRoleProvider)),
        ),
      ],
    );
  }

  // ─── Comment ─────────────────────────────────────────────
  Widget _buildComment() {
    return AppText.bodySm(
      'Service booked successfully for elder care. Please ensure '
      'assistance includes daily check-ins, medication reminders, and help '
      'with mobility as discussed.',
    );
  }

  // ─── Date and time ────────────────────────────────────────
  Widget _buildDateTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date row
        Row(
          children: [
            const Icon(Icons.calendar_month_outlined, size: 18),
            8.horizontalSpace,
            AppText.bodyMd(widget.booking.date),
          ],
        ),

        12.verticalSpace,
        // Timeline
        _TimelineRow(startTime: '16:30', endTime: '18:30', duration: '${2}h'),
      ],
    );
  }

  // ─── Address ─────────────────────────────────────────────
  Widget _buildAddress() {
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
          child: Text(
            'Tallapoosa county, east-central Alabama, U.S',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Price breakdown ─────────────────────────────────────
  Widget _buildPrice() {
    final rows = [
      ('Elderly care', '\$${1000}/h', false),
      ('Booking hours', '${2}h', false),
      ('Subtotal', '\$${2000}', false),
      ('Client protection', 'Free', false),
    ];

    return Column(
      children: [
        ...rows.map(
          (r) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(r.$1, style: AppTextStyles.bodyMd),
                Text(
                  r.$2,
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 16, color: AppColors.grey200),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.bodyMd('Price'),
            AppText(
              '\$${2000}',
              style: AppTextStyles.labelLg.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Section wrapper ──────────────────────────────────────
  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
        ),
        10.verticalSpace,
        child,
      ],
    );
  }
}
