part of 'booking_schedule_screen.dart';


// ─── Day schedule data ────────────────────────────────────────
class _DaySchedule {
  final String from;
  final String to;
  const _DaySchedule(this.from, this.to);
}

// ─── Individual day row ───────────────────────────────────────
class _DayRow extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
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
                  12.horizontalSpace,
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
                      color: AppColors.primaryFor(ref.watch(appRoleProvider)),
                      size: 22,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isExpanded)
            _TimePickerPanel(
              day: day,
              onSaved: onTimeSaved,
              bgColor: AppColors.white,
            ),
        ],
      ),
    );
  }
}
