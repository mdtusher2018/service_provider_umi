import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';

import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_chip.dart';
import 'package:service_provider_umi/shared/widgets/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_slider.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

import 'package:service_provider_umi/shared/widgets/app_utils.dart';

class WeeklyScheduleScreen extends ConsumerStatefulWidget {
  final double pricePerHour;

  const WeeklyScheduleScreen({super.key, this.pricePerHour = 10.0});

  @override
  ConsumerState<WeeklyScheduleScreen> createState() =>
      _WeeklyScheduleScreenState();
}

class _WeeklyScheduleScreenState extends ConsumerState<WeeklyScheduleScreen> {
  final Map<String, _DaySchedule?> _schedule = {
    'Monday': const _DaySchedule('14:15', '15:15'),
    'Tuesday': null,
    'Wednesday': null,
    'Thursday': null,
    'Friday': null,
    'Saturday': null,
  };

  static const _unavailableDays = ['Sunday'];

  String? _expandedDay;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ────────────────────────────────
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  children: [
                    ..._schedule.keys.map(
                      (day) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _DayRow(
                          day: day,
                          schedule: _schedule[day],
                          isExpanded: _expandedDay == day,
                          onAdd: () => setState(
                            () =>
                                _expandedDay = _expandedDay == day ? null : day,
                          ),
                          onDelete: () => setState(() => _schedule[day] = null),
                          onTimeSaved: (from, to) {
                            setState(() {
                              _schedule[day] = _DaySchedule(from, to);
                              _expandedDay = null;
                            });
                          },
                        ),
                      ),
                    ),
                    // Unavailable days
                    ..._unavailableDays.map(
                      (d) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            AppText.labelLg(d, color: AppColors.textSecondary),
                            const Spacer(),
                            AppText.labelSm(
                              'Not available',
                              color: AppColors.grey400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── Bottom CTA ────────────────────────────
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          // Frequency toggle chip
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.refresh_rounded,
                    color: AppColors.primary,
                    size: 16,
                  ),
                  const SizedBox(width: 6),
                  AppText.labelMd(
                    'Weekly',
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: const Icon(
              Icons.close_rounded,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final hasAnyDay = _schedule.values.any((v) => v != null);
    final totalCost = _schedule.values
        .where((v) => v != null)
        .fold<double>(0, (sum, _) => sum + widget.pricePerHour);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: AppButton.primary(
        label: hasAnyDay
            ? 'Continue for \$${totalCost.toStringAsFixed(2)}/week'
            : 'Set up at least one day',
        onPressed: hasAnyDay
            ? () {
                // context.go(AppRoutes.bookingConfirmation);
              }
            : null,
      ),
    );
  }
}

// ─── Day schedule data ────────────────────────────────────────
class _DaySchedule {
  final String from;
  final String to;
  const _DaySchedule(this.from, this.to);
}

// ─── Individual day row ───────────────────────────────────────
class _DayRow extends StatelessWidget {
  final String day;
  final _DaySchedule? schedule;
  final bool isExpanded;
  final VoidCallback onAdd;
  final VoidCallback onDelete;
  final void Function(String from, String to) onTimeSaved;

  const _DayRow({
    required this.day,
    required this.schedule,
    required this.isExpanded,
    required this.onAdd,
    required this.onDelete,
    required this.onTimeSaved,
  });

  @override
  Widget build(BuildContext context) {
    final hasSchedule = schedule != null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: hasSchedule ? AppColors.secondary : AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasSchedule ? AppColors.secondary : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                AppText.labelLg(
                  day,
                  color: hasSchedule ? AppColors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
                const Spacer(),
                if (hasSchedule) ...[
                  AppText.labelMd(
                    '${schedule!.from} - ${schedule!.to}',
                    color: AppColors.white.withOpacity(0.9),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: onDelete,
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white60,
                      size: 20,
                    ),
                  ),
                ] else ...[
                  GestureDetector(
                    onTap: onAdd,
                    child: Icon(
                      isExpanded ? Icons.remove_rounded : Icons.add_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isExpanded) _TimePickerPanel(day: day, onSaved: onTimeSaved),
        ],
      ),
    );
  }
}

// ─── Inline time picker panel ─────────────────────────────────
class _TimePickerPanel extends StatefulWidget {
  final String day;
  final void Function(String from, String to) onSaved;

  const _TimePickerPanel({required this.day, required this.onSaved});

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
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(13)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppDivider(),
          const SizedBox(height: 14),
          // Duration
          AppDurationSlider(
            value: _duration,
            onChanged: (v) => setState(() => _duration = v),
          ),
          const SizedBox(height: 16),
          AppText.h4('Start time'),
          const SizedBox(height: 12),

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

          const SizedBox(height: 16),
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
