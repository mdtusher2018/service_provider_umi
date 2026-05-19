part of 'user_service_screen.dart';

// ─── Segmented Tab Bar ────────────────────────────────────────
class _SegmentedTabBar extends StatelessWidget {
  final TabController controller;
  final VoidCallback? onChanged;
  const _SegmentedTabBar({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: 10.circular,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: ['Requested', 'Upcoming', 'Cancelled'].asMap().entries.map((
              e,
            ) {
              final isSelected = controller.index == e.key;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.animateTo(e.key);
                    onChanged?.call(); // ✅ notify parent
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: 3.paddingAll,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.grey200
                          : Colors.transparent,
                      borderRadius: 7.circular,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: AppText.labelMd(
                        e.value,
                        color: AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
