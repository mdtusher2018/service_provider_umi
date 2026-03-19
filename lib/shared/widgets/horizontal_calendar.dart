import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/datetime_ext.dart';
import '../../core/theme/app_colors.dart';
import 'app_text.dart';

class HorizontalCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime? startDate;
  final int daysCount;

  const HorizontalCalendar({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.startDate,
    this.daysCount = 30,
  });

  @override
  State<HorizontalCalendar> createState() => _HorizontalCalendarState();
}

class _HorizontalCalendarState extends State<HorizontalCalendar> {
  late List<DateTime> _dates;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _selectedDate = widget.selectedDate;

    final start = widget.startDate ?? DateTime.now();

    _dates = List.generate(
      widget.daysCount,
      (index) => start.add(Duration(days: index)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Month Row
        Row(
          children: [
            AppText.h3(_selectedDate.getMonth),
            const Spacer(),

            /// Show month button
            GestureDetector(
              onTap: _openDatePicker,
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
                  "Show month",
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),

        12.verticalSpace,

        /// Horizontal dates
        SizedBox(
          height: 70,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _dates.length,
            separatorBuilder: (_, __) => 8.horizontalSpace,
            itemBuilder: (context, index) {
              final date = _dates[index];
              final isSelected = date.isSameDay(_selectedDate);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                  });

                  widget.onDateSelected(date);
                },
                child: Container(
                  width: 58,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText.labelSm(
                        date.getDayOfWeek,
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textSecondary,
                      ),
                      4.verticalSpace,
                      AppText.h3(
                        date.day.toString(),
                        color: isSelected
                            ? AppColors.white
                            : AppColors.textPrimary,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _openDatePicker() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;

        _dates = List.generate(
          widget.daysCount,
          (index) => picked.add(Duration(days: index)),
        );
      });

      widget.onDateSelected(picked);
    }
  }
}
