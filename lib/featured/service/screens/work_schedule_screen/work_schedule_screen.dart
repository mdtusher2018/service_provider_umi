import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

import '../../../../../../../core/di/app_role_provider.dart';
import '../../../../../../../core/theme/app_colors.dart';
import '../../../../../../../core/theme/app_text_styles.dart';
part '_schedule_dialog.dart';
part '_widgets.dart';

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

class _TimeRange {
  final TimeOfDay from;
  final TimeOfDay to;
  const _TimeRange(this.from, this.to);
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
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Title ──────────────────────────────────
            AppText.h1('Work schedule', color: AppColors.textPrimary),
            4.verticalSpace,
            AppText.bodySm('When are you available to offer your services?'),
            24.verticalSpace,

            // ─── Day list ────────────────────────────────
            Expanded(
              child: ListView.separated(
                itemCount: _days.length,
                separatorBuilder: (_, __) => 16.verticalSpace,
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
                context.push(AppRoutes.filter);
              },
            ),
            24.verticalSpace,
          ],
        ),
      ),
    );
  }
}
