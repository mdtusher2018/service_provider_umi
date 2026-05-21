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
          borderRadius: 8.circular,
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

Widget _buildHeader(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
    child: Row(
      children: [
        10.horizontalSpace,
        Expanded(
          child: AppTextField(
            hint: "Find the service you need",
            prefixIcon: kIsWeb
                ? null
                : InkWell(
                    onTap: () => context.go(AppRoutes.userHome),
                    child: Icon(Icons.arrow_back),
                  ),
            fillColor: AppColors.white,
          ),
        ),

        10.horizontalSpace,
        InkWell(
          onTap: () {
            // context.go(AppRoutes.favourites);
            context.push(
              AppRoutes.providerProfilePath("69ca1d079d5373b1fc1189d3"),
            );
          },
          child: Container(
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
        ),
      ],
    ),
  );
}

Widget _buildFilterRow(WidgetRef ref, String id) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    child: Row(
      children: [
        _FilterChip(
          icon: Icons.calendar_today_outlined,
          label: 'When?',
          onTap: () {
            if (kIsWeb) {
              ref.context.go(AppRoutes.searchTimePath("2"));
            }
            ref.context.push(
              AppRoutes.searchTimePath(id),
            ); //replace with actual id or params if needed
          },
        ),
        8.horizontalSpace,
        _FilterChip(
          icon: Icons.tune_rounded,
          label: 'Filters',
          onTap: () {
            if (kIsWeb) {
              ref.context.go(AppRoutes.filterPath(id));
            } else {
              ref.context.push(AppRoutes.filterPath(id)).then((value) {});
            }
          },
        ),
      ],
    ),
  );
}
