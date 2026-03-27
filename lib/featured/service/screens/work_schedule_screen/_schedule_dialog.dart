part of 'work_schedule_screen.dart';

// ─── Schedule Dialog ──────────────────────────────────────────
class _ScheduleDialog extends StatefulWidget {
  final String dayName;
  final TimeOfDay initialFrom;
  final TimeOfDay initialTo;

  const _ScheduleDialog({
    required this.dayName,
    required this.initialFrom,
    required this.initialTo,
  });

  @override
  State<_ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<_ScheduleDialog> {
  late int _fromHour;
  late int _fromMinute;
  late int _toHour;
  late int _toMinute;

  @override
  void initState() {
    super.initState();
    _fromHour = widget.initialFrom.hour;
    _fromMinute = widget.initialFrom.minute;
    _toHour = widget.initialTo.hour;
    _toMinute = widget.initialTo.minute;
  }

  @override
  Widget build(BuildContext context) {
    // Read primary from context theme (works with AppTheme.of(role))
    final primary = Theme.of(context).colorScheme.primary;

    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: 40.paddingH,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.h3('Schedule ${widget.dayName}'),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.grey500,
                    size: 20,
                  ),
                ),
              ],
            ),
            24.verticalSpace,

            // From / Until labels
            Row(
              children: [
                Expanded(
                  child: AppText.labelMd(
                    'From',

                    color: AppColors.textSecondary,
                  ),
                ),
                16.horizontalSpace,
                Expanded(
                  child: AppText.labelMd(
                    'Until',

                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            12.verticalSpace,

            // Spinners
            Row(
              children: [
                // From
                Expanded(
                  child: _TimeSpinner(
                    hour: _fromHour,
                    minute: _fromMinute,
                    primary: primary,
                    onHourUp: () =>
                        setState(() => _fromHour = (_fromHour + 1) % 24),
                    onHourDown: () =>
                        setState(() => _fromHour = (_fromHour - 1 + 24) % 24),
                    onMinuteUp: () =>
                        setState(() => _fromMinute = (_fromMinute + 15) % 60),
                    onMinuteDown: () => setState(
                      () => _fromMinute = (_fromMinute - 15 + 60) % 60,
                    ),
                  ),
                ),
                16.horizontalSpace,
                // To
                Expanded(
                  child: _TimeSpinner(
                    hour: _toHour,
                    minute: _toMinute,
                    primary: primary,
                    onHourUp: () =>
                        setState(() => _toHour = (_toHour + 1) % 24),
                    onHourDown: () =>
                        setState(() => _toHour = (_toHour - 1 + 24) % 24),
                    onMinuteUp: () =>
                        setState(() => _toMinute = (_toMinute + 15) % 60),
                    onMinuteDown: () =>
                        setState(() => _toMinute = (_toMinute - 15 + 60) % 60),
                  ),
                ),
              ],
            ),
            24.verticalSpace,

            // Confirm
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => context.pop(
                  _TimeRange(
                    TimeOfDay(hour: _fromHour, minute: _fromMinute),
                    TimeOfDay(hour: _toHour, minute: _toMinute),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: AppText('Confirm', style: AppTextStyles.buttonMd),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Time Spinner ─────────────────────────────────────────────
class _TimeSpinner extends StatelessWidget {
  final int hour;
  final int minute;
  final Color primary;
  final VoidCallback onHourUp;
  final VoidCallback onHourDown;
  final VoidCallback onMinuteUp;
  final VoidCallback onMinuteDown;

  const _TimeSpinner({
    required this.hour,
    required this.minute,
    required this.primary,
    required this.onHourUp,
    required this.onHourDown,
    required this.onMinuteUp,
    required this.onMinuteDown,
  });

  String _fmt(int v) => v.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hour column
        _SpinColumn(
          value: _fmt(hour),
          onUp: onHourUp,
          onDown: onHourDown,
          primary: primary,
        ),
        Padding(
          padding:  6.paddingH,
          child: AppText.h2(':', color: AppColors.textPrimary),
        ),
        // Minute column
        _SpinColumn(
          value: _fmt(minute),
          onUp: onMinuteUp,
          onDown: onMinuteDown,
          primary: primary,
        ),
      ],
    );
  }
}

// ─── Spin Column (up / value / down) ─────────────────────────
class _SpinColumn extends StatelessWidget {
  final String value;
  final VoidCallback onUp;
  final VoidCallback onDown;
  final Color primary;

  const _SpinColumn({
    required this.value,
    required this.onUp,
    required this.onDown,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Up arrow
        GestureDetector(
          onTap: onUp,
          child: Icon(
            Icons.keyboard_arrow_up_rounded,
            color: AppColors.grey500,
            size: 26,
          ),
        ),
        // Value box
        Container(
          width: 52,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.grey200, width: 1.5),
          ),
          alignment: Alignment.center,
          child: AppText.h3(
            value,

            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        // Down arrow
        GestureDetector(
          onTap: onDown,
          child: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.grey500,
            size: 26,
          ),
        ),
      ],
    );
  }
}
