part of 'booking_schedule_screen.dart';

class _TimePickerPanel extends ConsumerStatefulWidget {
  final String day;
  final Color bgColor;
  final String providerId;
  final DateTime date;
  final void Function(String from, String to) onSaved;

  const _TimePickerPanel({
    required this.day,
    required this.bgColor,
    required this.providerId,
    required this.date,
    required this.onSaved,
  });

  @override
  ConsumerState<_TimePickerPanel> createState() => _TimePickerPanelState();
}

class _TimePickerPanelState extends ConsumerState<_TimePickerPanel> {
  double _duration = 1;
  String? _selectedTime;
  AvailabilityArgs? _lastArgs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchSlots());
  }

  @override
  void didUpdateWidget(covariant _TimePickerPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Fires when calendar date changes in single mode
    if (oldWidget.date != widget.date ||
        oldWidget.providerId != widget.providerId) {
      setState(() => _selectedTime = null);
      WidgetsBinding.instance.addPostFrameCallback((_) => _fetchSlots());
    }
  }

  int get _durationMinutes => (_duration * 60).toInt();

  AvailabilityArgs get _currentArgs => (
    providerId: widget.providerId,
    date: widget.date,
    slotDurationMinutes: _durationMinutes,
  );

  void _fetchSlots() {
    if (!mounted) return;
    final args = _currentArgs;
    _lastArgs = args;
    ref.read(availabilityProvider(args).notifier).fetch();
  }

  void _onDurationChanged(double v) {
    setState(() {
      _duration = v;
      _selectedTime = null;
    });
    final newArgs = _currentArgs;
    if (_lastArgs != newArgs) _fetchSlots();
  }

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
    final availState = ref.watch(availabilityProvider(_currentArgs));
    final slotsAsync = availState.slots;

    final availableStartTimes = slotsAsync.maybeWhen(
      data: (slots) => slots.map((s) => s.startTime).toSet(),
      orElse: () => <String>{},
    );
    final isLoading = slotsAsync is AsyncLoading;

    return Container(
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(13)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppDivider(),
          14.verticalSpace,
          AppDurationSlider(
            value: _duration,
            min: 1,
            max: 8,
            onChanged: _onDurationChanged,
          ),
          16.verticalSpace,
          Row(
            children: [
              AppText.h4('Start time'),
              const Spacer(),
              if (isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              if (slotsAsync is AsyncError)
                GestureDetector(
                  onTap: _fetchSlots,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.refresh,
                        size: 16,
                        color: AppColors.error,
                      ),
                      4.horizontalSpace,
                      AppText.labelSm('Retry', color: AppColors.error),
                    ],
                  ),
                ),
            ],
          ),
          12.verticalSpace,
          slotsAsync.when(
            loading: () => _buildSkeletonGrid(),
            error: (e, _) => Padding(
              padding: 8.paddingV,
              child: AppText.labelSm(
                'Could not load available slots. Tap retry above.',
                color: AppColors.textSecondary,
              ),
            ),
            data: (slots) {
              if (slots.isEmpty) {
                return Padding(
                  padding: 8.paddingV,
                  child: AppText.labelMd(
                    'No available slots for this duration.',
                    color: AppColors.textSecondary,
                  ),
                );
              }
              return _buildSlotGrid(slots, availableStartTimes);
            },
          ),
          16.verticalSpace,
          AppButton.primary(
            label: _selectedTime == null
                ? 'Select a time'
                : 'Save $_selectedTime – ${_addDuration(_selectedTime!, _duration)} · ${_duration.toInt()}h',
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

  Widget _buildSlotGrid(
    List<AvailabilitySlot> slots,
    Set<String> availableStartTimes,
  ) {
    final times = slots.map((s) => s.startTime).toList();
    final rows = <List<String>>[];
    for (var i = 0; i < times.length; i += 3) {
      rows.add(times.sublist(i, (i + 3).clamp(0, times.length)));
    }
    return Column(
      children: rows.map((row) {
        return Padding(
          padding: 8.paddingBottom,
          child: Row(
            children: row.map((t) {
              final isAvailable = availableStartTimes.contains(t);
              final isSelected = _selectedTime == t;
              return Expanded(
                child: Padding(
                  padding: 6.paddingRight,
                  child: _SlotChip(
                    time: t,
                    isSelected: isSelected,
                    isAvailable: isAvailable,
                    onTap: isAvailable
                        ? () => setState(() => _selectedTime = t)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkeletonGrid() {
    return Column(
      children: List.generate(3, (_) {
        return Padding(
          padding: 8.paddingBottom,
          child: Row(
            children: List.generate(3, (_) {
              return Expanded(
                child: Padding(
                  padding: 6.paddingRight,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.grey100,
                      borderRadius: 8.circular,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

// ── Slot chip ──────────────────────────────────────────────────
class _SlotChip extends StatelessWidget {
  final String time;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback? onTap;

  const _SlotChip({
    required this.time,
    required this.isSelected,
    required this.isAvailable,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isAvailable
              ? AppColors.white
              : AppColors.grey100,
          borderRadius: 8.circular,
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isAvailable
                ? AppColors.border
                : AppColors.grey100,
          ),
        ),
        child: AppText.labelSm(
          time,
          color: isSelected
              ? AppColors.white
              : isAvailable
              ? AppColors.textPrimary
              : AppColors.grey400,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          decoration: !isAvailable ? TextDecoration.lineThrough : null,
        ),
      ),
    );
  }
}
