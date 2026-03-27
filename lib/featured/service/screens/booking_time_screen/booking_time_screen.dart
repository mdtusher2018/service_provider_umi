import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_chip.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_slider.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'package:service_provider_umi/shared/widgets/horizontal_calendar.dart';

class BookingTimeScreen extends ConsumerStatefulWidget {
  final String? serviceId;
  final String? providerId;
  const BookingTimeScreen({super.key, this.serviceId, this.providerId});

  @override
  ConsumerState<BookingTimeScreen> createState() => _BookingTimeScreenState();
}

class _BookingTimeScreenState extends ConsumerState<BookingTimeScreen> {
  BookingFrequency _frequency = BookingFrequency.once;
  StartTimeType _startTimeType = StartTimeType.flexible;
  double _duration = 2;
  String? _selectedTimeSlot;

  final Set<String> _selectedWeekDays = {};

  DateTime _selectedDate = DateTime.now();

  final _morningSlots = [
    ('assets/icons/sunrise.png', '6 - 9'),
    ('assets/icons/day.png', '9 - 12'),
    ('assets/icons/day.png', '12 - 15'),
  ];
  final _eveningSlots = [
    ('assets/icons/day.png', '15 - 18'),
    ('assets/icons/sunset.png', '18 - 21'),
    ('assets/icons/night.png', '21 - 00'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryFor(ref.watch(appRoleProvider)),
      body: Column(
        children: [
          // ─── Teal Header ─────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: AppColors.black,
                        size: 24,
                      ),
                    ),
                  ),
                  8.verticalSpace,
                  Row(
                    children: [
                      AppText.h2(
                        'When do you need it?',
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ─── White body ──────────────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFrequency(),

                      24.verticalSpace,
                      AppDurationSlider(
                        value: _duration,
                        onChanged: (v) => setState(() => _duration = v),
                      ),
                      24.verticalSpace,
                      _buildStartTime(),
                      24.verticalSpace,
                      _buildTimeSlots(),
                      32.verticalSpace,
                      _buildActions(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequency() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.h3('Frequency'),
        12.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: _FrequencyCard(
                  title: 'Just once',
                  subtitle: 'One-Time',
                  isSelected: _frequency == BookingFrequency.once,
                  onTap: () =>
                      setState(() => _frequency = BookingFrequency.once),
                ),
              ),

              Expanded(
                child: _FrequencyCard(
                  title: 'Weekly',
                  subtitle: 'Recurring',
                  isSelected: _frequency == BookingFrequency.weekly,
                  onTap: () =>
                      setState(() => _frequency = BookingFrequency.weekly),
                ),
              ),
            ],
          ),
        ),
        AppDivider(height: 40),
        if (_frequency == BookingFrequency.weekly) ...[_buildWeekDaySelector()],
        if (_frequency == BookingFrequency.once) ...[
          HorizontalCalendar(
            selectedDate: _selectedDate,
            onDateSelected: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
          ),
        ],
      ],
    );
  }

  Widget _buildWeekDaySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.h3("Day(s) of the week"),
        12.verticalSpace,
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
              .map(
                (day) => AppDayChip(
                  day: day,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  isSelected: _selectedWeekDays.contains(day),
                  onTap: () {
                    setState(() {
                      if (_selectedWeekDays.contains(day)) {
                        _selectedWeekDays.remove(day);
                      } else {
                        _selectedWeekDays.add(day);
                      }
                    });
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildStartTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.h3('Start time'),
        12.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _startTimeType = StartTimeType.flexible),
                  child: _StartTypeCard(
                    label: 'Flexible start',
                    isSelected: _startTimeType == StartTimeType.flexible,
                  ),
                ),
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _startTimeType = StartTimeType.exact),
                  child: _StartTypeCard(
                    label: 'Exact start',
                    isSelected: _startTimeType == StartTimeType.exact,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_startTimeType == StartTimeType.flexible) ...[
          _flexibleTimeSlot(),
        ] else ...[
          _buildExactTimePicker(),
        ],
      ],
    );
  }

  Widget _flexibleTimeSlot() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.labelLg('Morning', color: AppColors.textSecondary),
        10.verticalSpace,
        Row(
          children: _morningSlots
              .map(
                (s) => Expanded(
                  child: Padding(
                    padding: 8.paddingRight,
                    child: _TimeRangeCard(
                      emoji: s.$1,
                      range: s.$2,
                      isSelected: _selectedTimeSlot == s.$2,
                      onTap: () => setState(() => _selectedTimeSlot = s.$2),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        16.verticalSpace,
        AppText.labelLg('Evening', color: AppColors.textSecondary),
        10.verticalSpace,
        Row(
          children: _eveningSlots
              .map(
                (s) => Expanded(
                  child: Padding(
                    padding: 8.paddingRight,
                    child: _TimeRangeCard(
                      emoji: s.$1,
                      range: s.$2,
                      isSelected: _selectedTimeSlot == s.$2,
                      onTap: () => setState(() => _selectedTimeSlot = s.$2),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildExactTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.labelLg('Select exact time'),
        12.verticalSpace,
        Container(
          padding: 16.paddingAll,
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TimeSpinner(
                values: List.generate(12, (i) => '${i + 1}'.padLeft(2, '0')),
              ),
              AppText.h1(' : '),
              _TimeSpinner(values: ['00', '15', '30', '45']),

              16.horizontalSpace,
              _TimeSpinner(values: ['am', 'pm']),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: AppButton.outline(
            label: 'Skip',
            onPressed: () {
              // context.go(AppRoutes.bookingConfirmation);
            },
          ),
        ),

        14.horizontalSpace,
        Expanded(
          child: AppButton.primary(
            label: 'Search',
            onPressed: () {
              context.push(AppRoutes.searchResults);
            },
          ),
        ),
      ],
    );
  }
}

class _FrequencyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  const _FrequencyCard({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : AppColors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            AppText.labelLg(
              title,
              color: isSelected ? AppColors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            AppText.bodySm(
              subtitle,
              color: isSelected
                  ? AppColors.white.withOpacity(0.7)
                  : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _StartTypeCard extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _StartTypeCard({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: 12.paddingV,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Center(child: AppText.labelLg(label, fontWeight: FontWeight.w600)),
    );
  }
}

class _TimeRangeCard extends StatelessWidget {
  final String emoji;
  final String range;
  final bool isSelected;
  final VoidCallback onTap;
  const _TimeRangeCard({
    required this.emoji,
    required this.range,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: 12.paddingV,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Image.asset(emoji, width: 24, height: 24),
            4.verticalSpace,
            AppText.labelMd(
              range,
              color: isSelected ? AppColors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeSpinner extends StatefulWidget {
  final List<String> values;
  const _TimeSpinner({required this.values});

  @override
  State<_TimeSpinner> createState() => _TimeSpinnerState();
}

class _TimeSpinnerState extends State<_TimeSpinner> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(
            () => _current =
                (_current - 1 + widget.values.length) % widget.values.length,
          ),
          child: const Icon(
            Icons.keyboard_arrow_up_rounded,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
        Container(
          width: 52,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: Center(child: AppText.h3(widget.values[_current])),
        ),
        GestureDetector(
          onTap: () =>
              setState(() => _current = (_current + 1) % widget.values.length),
          child: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondary,
            size: 20,
          ),
        ),
      ],
    );
  }
}
