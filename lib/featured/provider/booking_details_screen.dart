import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/featured/service/presentation/screens/booking_card_widget.dart';
import '../../../../core/di/app_role_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class BookingDetailScreen extends ConsumerStatefulWidget {
  final BookingItem booking;
  const BookingDetailScreen({super.key, required this.booking});

  @override
  ConsumerState<BookingDetailScreen> createState() =>
      _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  bool _showCongrats = false;

  void _complete() => setState(() => _showCongrats = true);

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(appRoleProvider);
    final primary = AppColors.primaryFor(role);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Details', style: AppTextStyles.h3),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // ─── Main content ────────────────────────────
          SingleChildScrollView(
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
              ],
            ),
          ),

          // ─── Complete button ─────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: AppColors.white,
              padding: EdgeInsets.fromLTRB(
                20,
                12,
                20,
                MediaQuery.of(context).padding.bottom + 12,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _complete,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Complete', style: AppTextStyles.buttonLg),
                ),
              ),
            ),
          ),

          // ─── Congratulations overlay ──────────────────
          if (_showCongrats)
            _CongratsOverlay(
              primary: primary,
              onDone: () {
                setState(() => _showCongrats = false);
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }

  // ─── Provider row ────────────────────────────────────────
  Widget _buildProviderRow(Color primary) {
    return Row(
      children: [
        // Avatar
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryLight,
            border: Border.all(color: AppColors.grey200),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: AppColors.primary,
            size: 28,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Mr. Raju',
                style: AppTextStyles.h4.copyWith(color: AppColors.textPrimary),
              ),
              Text('+880 1840 560614', style: AppTextStyles.bodySm),
            ],
          ),
        ),
        // Chat icon
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: primary.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.chat_bubble_outline_rounded,
            color: primary,
            size: 20,
          ),
        ),
      ],
    );
  }

  // ─── Comment ─────────────────────────────────────────────
  Widget _buildComment() {
    return Text(
      'Service booked successfully for elder care. Please ensure '
      'assistance includes daily check-ins, medication reminders, and help '
      'with mobility as discussed.',
      style: AppTextStyles.bodyMd.copyWith(color: AppColors.textSecondary),
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
            const Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: AppColors.grey400,
            ),
            const SizedBox(width: 8),
            Text(widget.booking.date, style: AppTextStyles.labelLg),
          ],
        ),
        const SizedBox(height: 12),
        // Timeline
        _TimelineRow(
          startTime: '16:30',
          endTime: '18:30',
          duration: '{widget.booking.hours.toStringAsFixed(0)}h',
        ),
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
      (
        'Elderly care',
        '\${widget.booking.pricePerHour.toStringAsFixed(2)}/h',
        false,
      ),
      ('Booking hours', '{widget.booking.hours.toStringAsFixed(0)}h', false),
      ('Subtotal', '\${widget.booking.totalPrice.toStringAsFixed(2)}', false),
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
            Text(
              'Price',
              style: AppTextStyles.labelLg.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '\${widget.booking.totalPrice.toStringAsFixed(2)}',
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
    return Row(
      children: [
        // Vertical line + dots
        SizedBox(
          width: 20,
          child: Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.grey400, width: 2),
                ),
              ),
              Container(width: 2, height: 20, color: AppColors.grey300),
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: AppColors.textPrimary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Start: $startTime', style: AppTextStyles.bodyMd),
            const SizedBox(height: 6),
            Text('End: $endTime', style: AppTextStyles.bodyMd),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 15,
              color: AppColors.grey400,
            ),
            const SizedBox(width: 4),
            Text('Duration: $duration', style: AppTextStyles.bodySm),
          ],
        ),
      ],
    );
  }
}

// ─── Congratulations Overlay ──────────────────────────────────
class _CongratsOverlay extends StatelessWidget {
  final Color primary;
  final VoidCallback onDone;
  const _CongratsOverlay({required this.primary, required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 28),
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
                // Trophy / medal illustration
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Decorative dots
                    ..._buildDots(),
                    // Medal
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3CD),
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.emoji_events_rounded,
                            color: const Color(0xFFFFB300),
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
                  style: AppTextStyles.h2.copyWith(
                    color: primary,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Congratulations on achieving this milestone in your '
                  'professional journey! Your dedication, expertise, and '
                  'hard work are truly commendable. This new step is a '
                  'testament to your skill and determination to grow and '
                  'succeed.',
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
        ),
      ),
    );
  }

  List<Widget> _buildDots() {
    // Decorative coloured circles around the medal
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
