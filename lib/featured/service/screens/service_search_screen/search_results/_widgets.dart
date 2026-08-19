part of "service_search_results_screen.dart";

class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;
  const _FilterChip({
    required this.icon,
    required this.label,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primary.withOpacity(0.1) : AppColors.white,
          borderRadius: 24.circular,
          border: Border.all(color: isPrimary ? AppColors.primary : AppColors.grey300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isPrimary ? AppColors.primary : AppColors.grey600),
            6.horizontalSpace,
            AppText.labelMd(label, color: isPrimary ? AppColors.primary : AppColors.grey600, fontWeight: FontWeight.w600),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context, TextEditingController controller, ValueChanged<String> onChanged) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
    child: Row(
      children: [
        10.horizontalSpace,
        Expanded(
          child: AppTextField(
            controller: controller,
            onChanged: onChanged,
            hint: AppLocalizations.of(context)!.findTheServiceYouNeed,
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
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (_) => const FavouritesScreen(),
              ),
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

Widget _buildFilterRow(WidgetRef ref, String id, VoidCallback onFaqTap) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        _FilterChip(
          icon: Icons.check_circle_outline,
          label: AppLocalizations.of(ref.context)!.whenQuestion,
          isPrimary: true,
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
          label: AppLocalizations.of(ref.context)!.filters,
          onTap: () {
            if (kIsWeb) {
              ref.context.go(AppRoutes.filterPath(id));
            } else {
              ref.context.push(AppRoutes.filterPath(id)).then((value) {});
            }
          },
        ),
        const Spacer(),
        GestureDetector(
          onTap: onFaqTap,
          child: Row(
            children: [
              AppText.labelSm(
                AppLocalizations.of(ref.context)!.howDoesTheServiceWork,
                color: AppColors.primary,
              ),
              4.horizontalSpace,
              const Icon(Icons.arrow_forward, color: AppColors.primary, size: 16),
            ],
          ),
        ),
      ],
    ),
  );
}
