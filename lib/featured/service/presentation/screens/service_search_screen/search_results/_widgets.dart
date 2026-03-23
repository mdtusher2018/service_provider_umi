part of "service_search_results_screen.dart";

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey800),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.textPrimary),
            6.horizontalSpace,
            AppText.labelLg(label),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
    child: Row(
      children: [
        10.horizontalSpace,
        Expanded(
          child: AppTextField(
            prefixIcon: Icon(Icons.arrow_back),
            fillColor: AppColors.white,
          ),
        ),

        10.horizontalSpace,
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.black),
          ),
          child: const Icon(
            Icons.favorite_border_rounded,
            color: AppColors.black,
            size: 20,
          ),
        ),
      ],
    ),
  );
}

Widget _buildFilterRow(WidgetRef ref) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(
      children: [
        _FilterChip(
          icon: Icons.calendar_today_outlined,
          label: 'When?',
          onTap: () {},
        ),
        8.horizontalSpace,
        _FilterChip(
          icon: Icons.tune_rounded,
          label: 'Filters',
          onTap: () {
            ref.context.push(AppRoutes.filter);
          },
        ),
      ],
    ),
  );
}
