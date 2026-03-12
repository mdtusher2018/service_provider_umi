import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_chip.dart';
import 'package:service_provider_umi/shared/widgets/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_slider.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

enum BookingFrequency { once, weekly }

enum StartTimeType { flexible, exact }

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
  int _selectedDayIndex = 0;
  double _duration = 2;
  String? _selectedTimeSlot;

  final List<_DayItem> _days = [
    _DayItem('Mon', '13'),
    _DayItem('Tue', '14'),
    _DayItem('Wed', '15'),
    _DayItem('Thu', '16'),
    _DayItem('Fri', '17'),
    _DayItem('Sat', '18'),
  ];

  final _morningSlots = [('☀️', '9 - 6'), ('☀️', '9 - 12'), ('🌤', '12 - 15')];
  final _eveningSlots = [
    ('🌙', '15 - 18'),
    ('🌙', '18 - 21'),
    ('🌙', '21 - 00'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          // ─── Teal Header ─────────────────────────────
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppColors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  AppText.h2('When do you need it?', color: AppColors.white),
                ],
              ),
            ),
          ),

          // ─── White body ──────────────────────────────
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
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
                      const SizedBox(height: 24),
                      _buildCalendar(),
                      const SizedBox(height: 24),
                      AppDurationSlider(
                        value: _duration,
                        onChanged: (v) => setState(() => _duration = v),
                      ),
                      const SizedBox(height: 24),
                      _buildStartTime(),
                      const SizedBox(height: 24),
                      _buildTimeSlots(),
                      const SizedBox(height: 32),
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
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _FrequencyCard(
                title: 'Just once',
                subtitle: 'One-Time',
                isSelected: _frequency == BookingFrequency.once,
                onTap: () => setState(() => _frequency = BookingFrequency.once),
              ),
            ),
            const SizedBox(width: 12),
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
        if (_frequency == BookingFrequency.weekly) ...[
          const SizedBox(height: 16),
          AppText.h3("Day(s) of the week"),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._days.map(
                (d) => AppDayChip(day: d.day, isSelected: false, onTap: () {}),
              ),
              ...[
                'Fri',
                'Sat',
                'Sun',
              ].map((d) => AppDayChip(day: d, isSelected: false, onTap: () {})),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCalendar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AppText.h3('January'),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: AppText.labelMd(
                  'Show month',
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 62,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _days.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) => AppDayChip(
              day: _days[i].day,
              date: _days[i].date,
              isSelected: _selectedDayIndex == i,
              onTap: () => setState(() => _selectedDayIndex = i),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStartTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.h3('Start time'),
        const SizedBox(height: 12),
        Row(
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
            const SizedBox(width: 12),
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
      ],
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_startTimeType == StartTimeType.flexible) ...[
          AppText.labelLg('Morning', color: AppColors.textSecondary),
          const SizedBox(height: 10),
          Row(
            children: _morningSlots
                .map(
                  (s) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
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
          const SizedBox(height: 16),
          AppText.labelLg('Evening', color: AppColors.textSecondary),
          const SizedBox(height: 10),
          Row(
            children: _eveningSlots
                .map(
                  (s) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
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
        ] else ...[
          // Exact time picker
          _buildExactTimePicker(),
        ],
      ],
    );
  }

  Widget _buildExactTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.labelLg('Select exact time'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
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
              const SizedBox(width: 16),
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
        const SizedBox(width: 14),
        Expanded(
          flex: 2,
          child: AppButton.primary(
            label: 'Search',
            onPressed: () {
              // Navigate to results
            },
          ),
        ),
      ],
    );
  }
}

class _DayItem {
  final String day;
  final String date;
  const _DayItem(this.day, this.date);
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
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.secondary : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.secondary : AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.secondary : AppColors.border,
          width: 1.5,
        ),
      ),
      child: Center(
        child: AppText.labelLg(
          label,
          color: isSelected ? AppColors.white : AppColors.textPrimary,
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            AppText.labelSm(
              range,
              color: isSelected ? AppColors.white : AppColors.textPrimary,
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
