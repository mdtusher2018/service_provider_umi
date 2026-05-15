import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';

import 'package:service_provider_umi/core/utils/extensions/datetime_ext.dart';
import 'package:service_provider_umi/data/models/booking_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
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

// ─── Day abbreviation map ─────────────────────────────────────
const _kDayAbbr = {
  'Monday': 'Mon',
  'Tuesday': 'Tue',
  'Wednesday': 'Wed',
  'Thursday': 'Thu',
  'Friday': 'Fri',
  'Saturday': 'Sat',
  'Sunday': 'Sun',
};

class BookingScheduleScreen extends ConsumerStatefulWidget {
  final double pricePerHour;
  final BookingFrequency bookingMode;
  final String providerId;

  const BookingScheduleScreen({
    super.key,
    this.pricePerHour = 10.0,
    required this.bookingMode,
    required this.providerId,
  });

  @override
  ConsumerState<BookingScheduleScreen> createState() =>
      _BookingScheduleScreenState();
}

class _BookingScheduleScreenState extends ConsumerState<BookingScheduleScreen> {
  // ─── Weekly state ─────────────────────────────────────────
  final Map<String, _DaySchedule?> _schedule = {
    'Monday': null,
    'Tuesday': null,
    'Wednesday': null,
    'Thursday': null,
    'Friday': null,
    'Saturday': null,
  };

  static const _unavailableDays = ['Sunday'];

  String? _expandedDay;

  // ─── Mode / single-booking state ─────────────────────────
  late BookingFrequency _mode;
  DateTime _selectedDate = DateTime.now();

  String? _singleFrom;
  String? _singleTo;
  bool _showSingleTimePicker = true;

  // ─── Submission state ─────────────────────────────────────
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _mode = widget.bookingMode;
  }

  // ─────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _mode == BookingFrequency.weekly
                  ? _buildWeeklySchedule()
                  : _buildSingleBooking(),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Weekly schedule
  // ─────────────────────────────────────────────────────────

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
          ..._unavailableDays.map(
            (d) => Container(
              margin: 10.paddingBottom,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: 14.circular,
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

  // ─────────────────────────────────────────────────────────
  // Single booking
  // ─────────────────────────────────────────────────────────

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
                // Reset previously picked time when date changes
                _singleFrom = null;
                _singleTo = null;
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
              borderRadius: 12.circular,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule, size: 18),
                8.horizontalSpace,
                AppText.labelMd("$_singleFrom - $_singleTo"),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() {
                    _showSingleTimePicker = true;
                    _singleFrom = null;
                    _singleTo = null;
                  }),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // Header
  // ─────────────────────────────────────────────────────────

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
              borderRadius: 24.circular,
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
                    setState(() => _mode = value);
                  }
                },
              ),
            ),
          ),
          if (!kIsWeb) ...[
            GestureDetector(
              onTap: () => context.pop(),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.textSecondary,
              ),
            ),
          ] else ...[
            40.horizontalSpace,
          ],
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Bottom bar
  // ─────────────────────────────────────────────────────────

  Widget _buildBottomBar() {
    final canProceed = _mode == BookingFrequency.weekly
        ? _schedule.values.any((v) => v != null)
        : _singleFrom != null;

    final totalCost = _mode == BookingFrequency.weekly
        ? _schedule.values
              .where((v) => v != null)
              .fold<double>(0, (sum, _) => sum + widget.pricePerHour)
        : _singleFrom != null && _singleTo != null
        ? () {
            final from = _parseTime(_singleFrom!, _selectedDate);
            final to = _parseTime(_singleTo!, _selectedDate);
            final hours = to.difference(from).inMinutes / 60.0;
            return widget.pricePerHour * hours;
          }()
        : 0.0;

    String label;
    if (!canProceed) {
      label = _mode == BookingFrequency.weekly
          ? 'Set up at least one day'
          : 'Select a time slot';
    } else if (_isSubmitting) {
      label = 'Booking…';
    } else {
      label = _mode == BookingFrequency.weekly
          ? 'Continue for \$${totalCost.toStringAsFixed(2)}/week'
          : 'Book for \$${totalCost.toStringAsFixed(2)}';
    }

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
        label: label,
        onPressed: canProceed && !_isSubmitting ? _submit : null,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // Submit
  // ─────────────────────────────────────────────────────────

  Future<void> _submit() async {
    final request = _buildPayload();
    if (request == null) return;

    setState(() => _isSubmitting = true);

    final message = await ref
        .read(bookingsProvider(BookingStatus.requested).notifier)
        .createBooking(request: request);

    if (!mounted) return;
    setState(() => _isSubmitting = false);
    if (message != null && !message.contains("Successfully Booked")) {
      context.showErrorSnackBar(message);
    } else if (message != null) {
      context.go(AppRoutes.services);
      context.showSuccessSnackBar(message);
    }
  }

  // ─────────────────────────────────────────────────────────
  // Payload builder
  // ─────────────────────────────────────────────────────────

  CreateBookingRequest? _buildPayload() {
    if (_mode == BookingFrequency.weekly) {
      final activeDays = _schedule.entries
          .where((e) => e.value != null)
          .toList();

      if (activeDays.isEmpty) return null;

      final now = DateTime.now();

      final bookingDays = activeDays.map((entry) {
        final sched = entry.value!;
        final date = _nextWeekday(now, _weekdayIndex(entry.key));
        final from = _parseTime(sched.from, date);
        final to = _parseTime(sched.to, date);
        final durationHours = to.difference(from).inMinutes / 60.0;

        return BookingDayRequest(
          day: _kDayAbbr[entry.key]!,
          startTime: from,
          endTime: to,
          durationHours: durationHours,
        );
      }).toList();

      final totalHours = bookingDays.fold<double>(
        0,
        (sum, d) => sum + d.durationHours,
      );

      return CreateBookingRequest(
        providerId: widget.providerId,
        price: widget.pricePerHour * totalHours,
        startDate: bookingDays.first.startTime,
        totalHours: totalHours,
        bookingType: 'weekly',
        bookingDays: bookingDays,
      );
    } else {
      // ── Once ────────────────────────────────────────────
      if (_singleFrom == null || _singleTo == null) return null;

      final from = _parseTime(_singleFrom!, _selectedDate);
      final to = _parseTime(_singleTo!, _selectedDate);
      final durationHours = to.difference(from).inMinutes / 60.0;

      // Derive 3-letter abbreviation from the selected date's weekday
      final dayAbbr =
          _kDayAbbr[_selectedDate.getDayOfWeek] ??
          _selectedDate.getDayOfWeek.substring(0, 3);

      return CreateBookingRequest(
        providerId: widget.providerId,
        price: widget.pricePerHour * durationHours,
        startDate: from,
        totalHours: durationHours,
        bookingType: '',
        bookingDays: [
          BookingDayRequest(
            day: dayAbbr,
            startTime: from,
            endTime: to,
            durationHours: durationHours,
          ),
        ],
      );
    }
  }

  // ─────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────

  /// Parses "HH:mm" into a full [DateTime] anchored to [date].
  DateTime _parseTime(String hhmm, DateTime date) {
    final parts = hhmm.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  /// Returns the next date whose weekday matches [weekday] (1 = Mon … 7 = Sun).
  DateTime _nextWeekday(DateTime from, int weekday) {
    var d = from;
    while (d.weekday != weekday) {
      d = d.add(const Duration(days: 1));
    }
    return d;
  }

  int _weekdayIndex(String day) => const {
    'Monday': 1,
    'Tuesday': 2,
    'Wednesday': 3,
    'Thursday': 4,
    'Friday': 5,
    'Saturday': 6,
    'Sunday': 7,
  }[day]!;
}
