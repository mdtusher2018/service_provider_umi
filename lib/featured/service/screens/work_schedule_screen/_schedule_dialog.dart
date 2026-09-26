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
      shape: RoundedRectangleBorder(borderRadius: 20.circular),
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
                  child: SizedBox(
                    height: 120,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      initialDateTime: DateTime(2026, 1, 1, _fromHour, _fromMinute),
                      onDateTimeChanged: (time) {
                        setState(() {
                          _fromHour = time.hour;
                          _fromMinute = time.minute;
                        });
                      },
                    ),
                  ),
                ),
                16.horizontalSpace,
                // To
                Expanded(
                  child: SizedBox(
                    height: 120,
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.time,
                      use24hFormat: true,
                      initialDateTime: DateTime(2026, 1, 1, _toHour, _toMinute),
                      onDateTimeChanged: (time) {
                        setState(() {
                          _toHour = time.hour;
                          _toMinute = time.minute;
                        });
                      },
                    ),
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
                onPressed: () {
                  final fromMin = _fromHour * 60 + _fromMinute;
                  final toMin = _toHour * 60 + _toMinute;
                  if (fromMin >= toMin) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Start time must be before end time')),
                    );
                    return;
                  }
                  context.pop(
                    _TimeRange(
                      TimeOfDay(hour: _fromHour, minute: _fromMinute),
                      TimeOfDay(hour: _toHour, minute: _toMinute),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: 10.circular),
                ),
                child: AppText(AppLocalizations.of(context)!.confirm, style: AppTextStyles.buttonMd),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


