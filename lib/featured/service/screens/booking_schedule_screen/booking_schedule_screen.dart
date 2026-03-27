import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';

import 'package:service_provider_umi/core/utils/extensions/datetime_ext.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_chip.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_slider.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'package:service_provider_umi/shared/widgets/horizontal_calendar.dart';
part '_day_schedule.dart';
part '_time_picker_panel.dart';

class BookingScheduleScreen extends ConsumerStatefulWidget {
  final double pricePerHour;
  final BookingFrequency bookingMode;

  const BookingScheduleScreen({
    super.key,
    this.pricePerHour = 10.0,
    required this.bookingMode,
  });

  @override
  ConsumerState<BookingScheduleScreen> createState() =>
      _WeeklyBookingScheduleScreenState();
}

class _WeeklyBookingScheduleScreenState
    extends ConsumerState<BookingScheduleScreen> {
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

  late BookingFrequency _mode;
  DateTime _selectedDate = DateTime.now();

  String? _singleFrom;
  String? _singleTo;
  bool _showSingleTimePicker = true;

  @override
  void initState() {
    super.initState();
    _mode = widget.bookingMode;
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
              child: _mode == BookingFrequency.weekly
                  ? _buildWeeklySchedule()
                  : _buildSingleBooking(),
            ),

            // ─── Bottom CTA ────────────────────────────
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklySchedule() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        children: [
          ..._schedule.keys.map(
            (day) => Padding(
              padding: 10.paddingBottom,
              child: _DayRow(
                day: day,
                schedule: _schedule[day],
                isExpanded: _expandedDay == day,
                onAdd: () => setState(
                  () => _expandedDay = _expandedDay == day ? null : day,
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
              margin: 10.paddingBottom,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  AppText.labelLg(d, color: AppColors.textSecondary),
                  const Spacer(),
                  AppText.labelSm('Not available', color: AppColors.grey400),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleBooking() {
    return Column(
      children: [
        10.verticalSpace,
        Padding(
          padding: 16.paddingH,
          child: HorizontalCalendar(
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
                _showSingleTimePicker = true;
              });
            },
          ),
        ),

        16.verticalSpace,

        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _showSingleTimePicker
              ? Padding(
                  padding: 20.paddingH,
                  child: _TimePickerPanel(
                    day: _selectedDate.getDayOfWeek,
                    bgColor: Colors.transparent,
                    onSaved: (from, to) {
                      setState(() {
                        _singleFrom = from;
                        _singleTo = to;
                        _showSingleTimePicker = false;
                      });
                    },
                  ),
                )
              : const SizedBox(),
        ),

        if (_singleFrom != null) ...[
          20.verticalSpace,
          Container(
            margin: 20.paddingH,
            padding: 12.paddingAll,
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule, size: 18),
                8.horizontalSpace,
                AppText.labelMd("$_singleFrom - $_singleTo"),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          40.horizontalSpace,
          Container(
            width: 120,
            height: 35,
            padding: 16.paddingH,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<BookingFrequency>(
                value: _mode,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                items: const [
                  DropdownMenuItem(
                    value: BookingFrequency.weekly,
                    child: AppText.labelMd("Weekly"),
                  ),
                  DropdownMenuItem(
                    value: BookingFrequency.once,
                    child: AppText.labelMd("Just once"),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _mode = value;
                    });
                  }
                },
              ),
            ),
          ),

          GestureDetector(
            onTap: () => context.pop(),
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
        bottom: context.bottomPadding + 12,
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
