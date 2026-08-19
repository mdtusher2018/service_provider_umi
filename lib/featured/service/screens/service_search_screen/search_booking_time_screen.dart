import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/gen/assets.gen.dart';
import 'package:service_provider_umi/shared/enums/booking_status.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_chip.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_slider.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'package:service_provider_umi/shared/widgets/horizontal_calendar.dart';
import 'package:service_provider_umi/l10n/app_localizations.dart';

import '../../../../core/utils/extensions/context_ext.dart';

class SearchBookingTimeScreen extends ConsumerStatefulWidget {
  final String serviceId;
  final String? subcategoryIds;
  const SearchBookingTimeScreen({super.key, required this.serviceId, this.subcategoryIds});

  @override
  ConsumerState<SearchBookingTimeScreen> createState() =>
      _BookingTimeScreenState();
}

class _BookingTimeScreenState extends ConsumerState<SearchBookingTimeScreen> {
  BookingFrequency _frequency = BookingFrequency.once;
  StartTimeType _startTimeType = StartTimeType.flexible;
  double _duration = 2;
  String? _selectedTimeSlot;

  final Set<String> _selectedWeekDays = {};

  DateTime _selectedDate = DateTime.now();

  final _morningSlots = [
    ('☀️', '6 - 9'),
    ('☀️', '9 - 12'),
    ('☀️', '12 - 15'),
  ];
  final _eveningSlots = [
    ('🌙', '15 - 18'),
    ('🌙', '18 - 21'),
    ('🌙', '21 - 00'),
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
                  Row(
                    children: [
                      if (!kIsWeb)
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
                      8.horizontalSpace,
                      AppText.h2(
                        AppLocalizations.of(context)!.whenDoYouNeedIt,
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
        AppText.h3(AppLocalizations.of(context)!.frequency),
        12.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: 12.circular,
          ),
          child: Row(
            children: [
              Expanded(
                child: _FrequencyCard(
                  title: AppLocalizations.of(context)!.justOnce,
                  subtitle: AppLocalizations.of(context)!.oneTime,
                  isSelected: _frequency == BookingFrequency.once,
                  onTap: () =>
                      setState(() => _frequency = BookingFrequency.once),
                ),
              ),

              Expanded(
                child: _FrequencyCard(
                  title: AppLocalizations.of(context)!.weekly,
                  subtitle: AppLocalizations.of(context)!.recurring,
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
        AppText.h3(AppLocalizations.of(context)!.daysOfTheWeek),
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
        AppText.h3(AppLocalizations.of(context)!.startTime),
        12.verticalSpace,
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: 24.circular,
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _startTimeType = StartTimeType.flexible),
                  child: _StartTypeCard(
                    label: AppLocalizations.of(context)!.flexibleStart,
                    isSelected: _startTimeType == StartTimeType.flexible,
                  ),
                ),
              ),

              Expanded(
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _startTimeType = StartTimeType.exact),
                  child: _StartTypeCard(
                    label: AppLocalizations.of(context)!.exactStart,
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
        AppText.labelLg(AppLocalizations.of(context)!.morning, color: AppColors.textSecondary),
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
        AppText.labelLg(AppLocalizations.of(context)!.evening, color: AppColors.textSecondary),
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
        AppText.labelLg(AppLocalizations.of(context)!.selectExactTime),
        12.verticalSpace,
        Container(
          padding: 16.paddingAll,
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: 16.circular,
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

  // Widget _buildActions() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: AppButton.outline(
  //           label: 'Skip',
  //           onPressed: () {
  //             context.go(
  //               AppRoutes.searchResultPath(
  //                 widget.serviceId,
  //                 bookingType: _frequency == BookingFrequency.once
  //                     ? "one_time"
  //                     : "weekly",
  //                 date: _frequency == BookingFrequency.once
  //                     ? _selectedDate.toIso8601String().split('T').first
  //                     : null,
  //                 days: _frequency == BookingFrequency.weekly
  //                     ? _selectedWeekDays.join(',')
  //                     : null,
  //                 startTimeType: _startTimeType == StartTimeType.flexible
  //                     ? "flexible"
  //                     : "exact",
  //                 flexibleSlot: _startTimeType == StartTimeType.flexible
  //                     ? _selectedTimeSlot ?? ""
  //                     : null,
  //                 duration: (_duration * 60).toInt().toString(),
  //               ),
  //             );
  //           },
  //         ),
  //       ),
  //       14.horizontalSpace,
  //       Expanded(
  //         child: AppButton.primary(
  //           label: 'Search',
  //           onPressed: () {
  //             context.go(AppRoutes.searchResultPath(widget.serviceId));
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // ── Only the _buildActions method changes; drop this in to replace the old one.

  Widget _buildActions() {
    // Helper: converts duration in fractional hours → minutes string
    final durationMinutes = (_duration * 60).toInt().toString();

    // Helper: converts _startTimeType + _selectedTimeSlot → startTime/endTime
    // For exact time, _TimeSpinner values would be read; here we use flexible slot.
    String? resolvedFlexibleSlot;
    if (_startTimeType == StartTimeType.flexible && _selectedTimeSlot != null) {
      // Normalise e.g. "9 - 12" → "9-12"  (strip spaces)
      resolvedFlexibleSlot = _selectedTimeSlot!.replaceAll(' ', '');
    }

    void _navigate({required bool skip}) {
      if (skip) {
        context.go(
          AppRoutes.searchResultPath(
            widget.serviceId,
            page: '1',
            limit: '10',
            categoryId: widget.serviceId,
            subcategoryIds: widget.subcategoryIds,
          ),
        );
        return;
      }

      // If user hasn't selected a time slot for flexible search, show a snackbar
      // if (_startTimeType == StartTimeType.flexible && resolvedFlexibleSlot == null) {
      //   context.showErrorSnackBar("Please select a flexible start time slot or use 'Skip'.");
      //   return;
      // }

      final daysNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      final String oneTimeDay = daysNames[_selectedDate.weekday - 1];

      context.go(
        AppRoutes.searchResultPath(
          widget.serviceId,
          // ── Scheduling ──────────────────────────────
          bookingType: _frequency == BookingFrequency.once
              ? 'one_time'
              : 'weekly',
          days: _frequency == BookingFrequency.once
              ? oneTimeDay
              : (_selectedWeekDays.isNotEmpty ? _selectedWeekDays.join(',') : null),
          startTimeType: _startTimeType == StartTimeType.flexible
              ? 'flexible'
              : 'exact',
          flexibleSlot: _startTimeType == StartTimeType.flexible
              ? resolvedFlexibleSlot
              : null,
          // For exact time you would read the _TimeSpinner state;
          // wire those controllers and pass here:
          // startTime: _startTimeType == StartTimeType.exact ? _exactStartTime : null,
          duration: durationMinutes,
          // ── Pagination defaults ──────────────────────
          page: '1',
          limit: '10',
          categoryId: widget.serviceId,
          subcategoryIds: widget.subcategoryIds,
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: AppButton.outline(
            label: AppLocalizations.of(context)!.skip,
            textColor: AppColors.textPrimary,
            borderColor: AppColors.border,
            backgroundColor: AppColors.white,
            onPressed: () => _navigate(skip: true),
          ),
        ),
        14.horizontalSpace,
        Expanded(
          child: AppButton.primary(
            label: AppLocalizations.of(context)!.search,
            onPressed: () => _navigate(skip: false),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.white,
          borderRadius: 12.circular,
          border: isSelected
              ? Border.all(width: 1, color: AppColors.primary)
              : Border.all(color: Colors.transparent),
        ),
        child: Column(
          children: [
            AppText.labelLg(
              title,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            AppText.bodySm(
              subtitle,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
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
      padding: 8.paddingV,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.white,
        borderRadius: 24.circular,
        border: isSelected
            ? Border.all(width: 1, color: AppColors.primary)
            : Border.all(color: Colors.transparent),
      ),
      child: Center(
        child: AppText.labelLg(
          label, 
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
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
          color: AppColors.white,
          borderRadius: 12.circular,
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            4.verticalSpace,
            AppText.labelMd(
              range,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
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
            borderRadius: 10.circular,
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
