part of 'booking_details_screen.dart';

// ─── Date and time — iterate ALL booking days ─────────────────────────────
Widget _buildDateTime(BookingDetailModel data) {
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
            6.horizontalSpace,
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

        16.verticalSpace,

        Row(
          children: [
            const Icon(Icons.access_time_rounded, size: 15),
            4.horizontalSpace,
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
