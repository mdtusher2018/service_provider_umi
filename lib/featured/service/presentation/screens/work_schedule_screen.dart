import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/featured/filter_screen.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import '../../../../../../core/di/app_role_provider.dart';
import '../../../../../../core/theme/app_colors.dart';
import '../../../../../../core/theme/app_text_styles.dart';

// ─── Model ────────────────────────────────────────────────────
class DaySchedule {
  final String day;
  final bool isAvailable;
  final TimeOfDay from;
  final TimeOfDay to;

  const DaySchedule({
    required this.day,
    this.isAvailable = false,
    this.from = const TimeOfDay(hour: 9, minute: 0),
    this.to = const TimeOfDay(hour: 18, minute: 0),
  });

  DaySchedule copyWith({bool? isAvailable, TimeOfDay? from, TimeOfDay? to}) =>
      DaySchedule(
        day: day,
        isAvailable: isAvailable ?? this.isAvailable,
        from: from ?? this.from,
        to: to ?? this.to,
      );
}

// ─── Screen ───────────────────────────────────────────────────
class WorkScheduleScreen extends ConsumerStatefulWidget {
  const WorkScheduleScreen({super.key});

  @override
  ConsumerState<WorkScheduleScreen> createState() => _WorkScheduleScreenState();
}

class _WorkScheduleScreenState extends ConsumerState<WorkScheduleScreen> {
  final List<DaySchedule> _days = [
    const DaySchedule(day: 'Monday', isAvailable: true),
    const DaySchedule(day: 'Tuesday', isAvailable: true),
    const DaySchedule(day: 'Wednesday', isAvailable: true),
    const DaySchedule(day: 'Thursday', isAvailable: true),
    const DaySchedule(day: 'Friday', isAvailable: true),
    const DaySchedule(day: 'Saturday', isAvailable: false),
    const DaySchedule(day: 'Sunday', isAvailable: false),
  ];

  // ─── Toggle availability ──────────────────────────────────
  void _toggleDay(int index, bool value) {
    setState(() {
      _days[index] = _days[index].copyWith(isAvailable: value);
    });
  }

  // ─── Open schedule picker dialog ─────────────────────────
  Future<void> _openSchedulePicker(int index) async {
    final day = _days[index];
    final result = await showDialog<_TimeRange>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => _ScheduleDialog(
        dayName: day.day,
        initialFrom: day.from,
        initialTo: day.to,
      ),
    );

    if (result != null) {
      setState(() {
        _days[index] = _days[index].copyWith(from: result.from, to: result.to);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(appRoleProvider);
    final primary = AppColors.primaryFor(role);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: primary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Title ──────────────────────────────────
            Text(
              'Work schedule',
              style: AppTextStyles.h1.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              'When are you available to offer your services?',
              style: AppTextStyles.bodySm,
            ),
            const SizedBox(height: 24),

            // ─── Day list ────────────────────────────────
            Expanded(
              child: ListView.separated(
                itemCount: _days.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (_, i) => _DayRow(
                  schedule: _days[i],
                  primary: primary,
                  onToggle: (v) => _toggleDay(i, v),
                  onTapTime: _days[i].isAvailable
                      ? () => _openSchedulePicker(i)
                      : null,
                ),
              ),
            ),

            // ─── Confirm button ──────────────────────────
            AppButton(
              label: "Confirm",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return FilterScreen();
                    },
                  ),
                );
              },
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

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
              activeColor: primary,
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
          const SizedBox(height: 6),
          GestureDetector(
            onTap: onTapTime,
            child: Row(
              children: [
                // From box
                _TimeBox(time: _fmt(schedule.from), primary: primary),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    '—',
                    style: AppTextStyles.bodyMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
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

// ─── Time Range Model ─────────────────────────────────────────
class _TimeRange {
  final TimeOfDay from;
  final TimeOfDay to;
  const _TimeRange(this.from, this.to);
}

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
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
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
                Text('Schedule ${widget.dayName}', style: AppTextStyles.h3),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.grey500,
                    size: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // From / Until labels
            Row(
              children: [
                Expanded(
                  child: Text(
                    'From',
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Until',
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

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
                const SizedBox(width: 16),
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
            const SizedBox(height: 24),

            // Confirm
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(
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
                child: Text('Confirm', style: AppTextStyles.buttonMd),
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
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            ':',
            style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary),
          ),
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
          child: Text(
            value,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
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
