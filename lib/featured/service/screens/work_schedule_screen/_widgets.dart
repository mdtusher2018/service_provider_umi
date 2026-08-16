part of 'work_schedule_screen.dart';

// ─── Day Row ──────────────────────────────────────────────────────────────────

class _DayRow extends StatelessWidget {
  final String dayLabel; // e.g. "Monday"
  final bool isAvailable; // mapped from WorkScheduleModel.status
  final TimeOfDay from; // mapped from WorkScheduleModel.startTime
  final TimeOfDay to; // mapped from WorkScheduleModel.endTime
  final Color primary;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onTapTime;

  const _DayRow({
    required this.dayLabel,
    required this.isAvailable,
    required this.from,
    required this.to,
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
        // ── Day name + toggle + status label ──────────────────────────────
        Row(
          children: [
            Expanded(
              flex: 2,
              child: AppText(dayLabel, style: AppTextStyles.h3),
            ),

            Switch(
              value: isAvailable,
              onChanged: onToggle,
              activeThumbColor: primary,
              activeTrackColor: primary.withValues(alpha: 0.25),
              inactiveThumbColor: AppColors.grey300,
              inactiveTrackColor: AppColors.grey200,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),

            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: AppText(
                  isAvailable ? AppLocalizations.of(context)!.available : AppLocalizations.of(context)!.notAvailable,
                  style: AppTextStyles.bodySm.copyWith(
                    color: isAvailable
                        ? AppColors.textSecondary
                        : AppColors.grey400,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ],
        ),

        // ── Time range (only when available) ──────────────────────────────
        if (isAvailable) ...[
          6.verticalSpace,
          GestureDetector(
            onTap: onTapTime,
            child: Row(
              children: [
                _TimeBox(time: _fmt(from), primary: primary),
                Padding(
                  padding: 10.paddingH,
                  child: AppText.bodyMd('—', color: AppColors.textSecondary),
                ),
                _TimeBox(time: _fmt(to), primary: primary),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ─── Time Box ─────────────────────────────────────────────────────────────────

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
        borderRadius: 10.circular,
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
