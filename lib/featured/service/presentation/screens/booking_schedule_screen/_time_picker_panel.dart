part of 'booking_schedule_screen.dart';

// ─── Inline time picker panel ─────────────────────────────────
class _TimePickerPanel extends StatefulWidget {
  final String day;
  final Color bgColor;
  final void Function(String from, String to) onSaved;

  const _TimePickerPanel({
    required this.day,
    required this.onSaved,
    required this.bgColor,
  });

  @override
  State<_TimePickerPanel> createState() => _TimePickerPanelState();
}

class _TimePickerPanelState extends State<_TimePickerPanel> {
  double _duration = 2;
  String? _selectedTime;

  static const _timeSlots = [
    ['06:00', '12:00', '18:00'],
    ['07:00', '13:00', '19:00'],
    ['08:00', '14:00', '20:00'],
    ['09:00', '15:00', '21:00'],
    ['10:00', '16:30', '22:00'],
    ['11:00', '17:00', '23:00'],
  ];

  String _addDuration(String time, double hours) {
    final parts = time.split(':');
    final totalMin =
        int.parse(parts[0]) * 60 + int.parse(parts[1]) + (hours * 60).toInt();
    final h = (totalMin ~/ 60) % 24;
    final m = totalMin % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(13)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppDivider(),
          14.verticalSpace,
          // Duration
          AppDurationSlider(
            value: _duration,
            onChanged: (v) => setState(() => _duration = v),
          ),
          16.verticalSpace,
          AppText.h4('Start time'),
          12.verticalSpace,

          // Time grid
          ..._timeSlots.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: row
                    .map(
                      (t) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: AppTimeChip(
                            time: t,
                            isSelected: _selectedTime == t,
                            onTap: () => setState(() => _selectedTime = t),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),

          16.verticalSpace,
          AppButton.primary(
            label: _selectedTime == null
                ? 'Select a time'
                : 'Save $_selectedTime - ${_addDuration(_selectedTime!, _duration)} for \$${(_duration * 10).toStringAsFixed(0)}',
            onPressed: _selectedTime == null
                ? null
                : () => widget.onSaved(
                    _selectedTime!,
                    _addDuration(_selectedTime!, _duration),
                  ),
          ),
        ],
      ),
    );
  }
}
