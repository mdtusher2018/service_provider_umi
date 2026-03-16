import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/featured/service/presentation/screens/booking_card_widget.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import '../../../../../../core/di/app_role_provider.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

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
            const SizedBox(height: 20),
            _buildSection('Comment', _buildComment()),
            const SizedBox(height: 20),
            _buildSection('Date and time', _buildDateTime()),
            const SizedBox(height: 20),
            _buildSection('Address', _buildAddress()),
            const SizedBox(height: 20),
            _buildSection('Service price', _buildPrice()),
            SizedBox(height: 40),
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
        const SizedBox(width: 12),
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
            const SizedBox(width: 8),
            AppText.bodyMd(widget.booking.date),
          ],
        ),

        const SizedBox(height: 12),
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
        const SizedBox(width: 8),
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
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

// ─── Timeline Row ─────────────────────────────────────────────
class _TimelineRow extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String duration;
  const _TimelineRow({
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vertical line + dots
        Row(
          spacing: 4,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.grey600, width: 2),
              ),
            ),
            AppText.bodyMd('Start: $startTime'),
          ],
        ),
        Row(
          children: [
            const SizedBox(width: 6),
            Container(width: 2, height: 20, color: AppColors.grey600),
          ],
        ),
        Row(
          spacing: 4,
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.textPrimary,
                shape: BoxShape.circle,
              ),
            ),
            AppText.bodyMd('End: $endTime'),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            const Icon(Icons.access_time_rounded, size: 15),
            const SizedBox(width: 4),
            AppText.bodyMd(
              '(Duration: $duration)',
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Congratulations Overlay ──────────────────────────────────
class _CongratsDialog extends StatelessWidget {
  final Color primary;
  final VoidCallback onDone;

  const _CongratsDialog({required this.primary, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ..._buildDots(),

                Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF3CD),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.emoji_events_rounded,
                        color: Color(0xFFFFB300),
                        size: 52,
                      ),
                      Positioned(
                        bottom: 14,
                        child: Container(
                          width: 36,
                          height: 10,
                          decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              'Congratulations',
              style: AppTextStyles.h2.copyWith(color: primary, fontSize: 22),
            ),

            const SizedBox(height: 10),

            Text(
              'Congratulations on achieving this milestone in your '
              'professional journey! Your dedication, expertise, and '
              'hard work are truly commendable.',
              style: AppTextStyles.bodySm.copyWith(height: 1.6),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onDone,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text('Done', style: AppTextStyles.buttonMd),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDots() {
    const items = [
      _Dot(top: 0, left: 20, color: Color(0xFFE91E63), size: 8),
      _Dot(top: 10, right: 10, color: Color(0xFF9C27B0), size: 6),
      _Dot(bottom: 5, left: 5, color: Color(0xFF2196F3), size: 6),
      _Dot(bottom: 0, right: 20, color: Color(0xFFFF5722), size: 8),
      _Dot(top: 30, left: 0, color: Color(0xFF4CAF50), size: 5),
      _Dot(top: 5, right: 35, color: Color(0xFFFFEB3B), size: 7),
    ];

    return items
        .map(
          (d) => Positioned(
            top: d.top,
            left: d.left,
            right: d.right,
            bottom: d.bottom,
            child: Container(
              width: d.size,
              height: d.size,
              decoration: BoxDecoration(color: d.color, shape: BoxShape.circle),
            ),
          ),
        )
        .toList();
  }
}

class _Dot {
  final double? top, left, right, bottom, size;
  final Color color;
  const _Dot({
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.color,
    required this.size,
  });
}
