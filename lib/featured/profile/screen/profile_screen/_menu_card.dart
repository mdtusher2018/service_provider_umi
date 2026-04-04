part of 'profile_screen.dart';

// ─── Menu data ────────────────────────────────────────────────
class _Item {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  final bool showArrow;
  const _Item(this.icon, this.label, this.onTap, {this.showArrow = true});
}

class _MenuCard extends ConsumerWidget {
  final List<_Item> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: items.asMap().entries.map((e) {
        final isLast = e.key == items.length - 1;
        final item = e.value;
        return Column(
          children: [
            InkWell(
              onTap: item.onTap,
              borderRadius: BorderRadius.vertical(
                top: e.key == 0 ? const Radius.circular(16) : Radius.zero,
                bottom: isLast ? const Radius.circular(16) : Radius.zero,
              ),
              child: Padding(
                padding: 14.paddingV,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryFor(
                          ref.watch(appRoleProvider),
                        ).withOpacity(0.2),
                        borderRadius: 4.circular,
                      ),
                      child: Icon(
                        item.icon,
                        color: AppColors.primaryFor(ref.watch(appRoleProvider)),
                        size: 28,
                      ),
                    ),
                    14.horizontalSpace,
                    Expanded(
                      child: AppText.bodyMd(
                        item.label,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (item.showArrow)
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.grey400,
                        size: 14,
                      ),
                  ],
                ),
              ),
            ),
            AppDivider(),
          ],
        );
      }).toList(),
    );
  }
}
