part of 'work_schedule_screen.dart';

// ─── Day Row ──────────────────────────────────────────────────
class _DayRow extends StatelessWidget {
  final DaySchedule schedule;
  final Color primary;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onTapTime;

  const _DayRow({
    required this.schedule,
    required this.primary,
    required this.onToggle,
    this.onTapTime,
  });

  String _fmt(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day name + toggle + status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(schedule.day, style: AppTextStyles.h3),

            Switch(
              value: schedule.isAvailable,
              onChanged: onToggle,
              activeThumbColor: primary,
              activeTrackColor: primary.withOpacity(0.25),
              inactiveThumbColor: AppColors.grey300,
              inactiveTrackColor: AppColors.grey200,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),

            AppText(
              schedule.isAvailable ? 'Available' : 'Not available',
              style: AppTextStyles.bodySm.copyWith(
                color: schedule.isAvailable
                    ? AppColors.textSecondary
                    : AppColors.grey400,
              ),
            ),
          ],
        ),

        // Time range (only shown when available)
        if (schedule.isAvailable) ...[
          6.verticalSpace,
          GestureDetector(
            onTap: onTapTime,
            child: Row(
              children: [
                // From box
                _TimeBox(time: _fmt(schedule.from), primary: primary),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: AppText.bodyMd('—', color: AppColors.textSecondary),
                ),
                // To box
                _TimeBox(time: _fmt(schedule.to), primary: primary),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Time Box ─────────────────────────────────────────────────
class _TimeBox extends StatelessWidget {
  final String time;
  final Color primary;

  const _TimeBox({required this.time, required this.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border(),
      ),
      child: AppText(
        time,
        style: AppTextStyles.labelLg.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
