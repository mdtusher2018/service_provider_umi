part of 'provider_profile_screen.dart';

Widget _buildProfileHeader({
  required WidgetRef ref,
  required UserProfile data,
  required String chatId,
}) {
  return Column(
    children: [
      AppAvatar(
        name: data.name,
        imageUrl: data.profileImage,
        size: AvatarSize.xl,
      ),
      8.verticalSpace,
      AppText.h2(data.name),
      4.verticalSpace,
      AppText.labelLg(
        data.serviceProviderInfo?.specialists.isNotEmpty == true
            ? data.serviceProviderInfo!.specialists.first.name
            : "N/A",
        color: AppColors.primaryFor(ref.watch(appRoleProvider)),
      ),
      16.verticalSpace,
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 0),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StatItem(
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chat_bubble_outline, color: AppColors.primary, size: 22),
              ),
              value: '${data.avgRating?.toStringAsFixed(1) ?? '0.0'} ⭐',
              label: '${data.totalReview ?? 0} reviews',
              onTap: () {
                ref.context.showSnackBar(
                  showAtTop: true,
                  "You can't chat with provider before booking a job",
                );
              },
            ),
            _StatDivider(),
            _StatItem(
              icon: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.grid_view_outlined, color: AppColors.primary, size: 24),
              ),
              value: '1',
              label: 'Services',
            ),
            _StatDivider(),
            _StatItem(
              icon: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.check_circle_outline, color: AppColors.primary, size: 24),
              ),
              value: 'Verified',
              label: 'Profile',
            ),
          ],
        ),
      ),
    ],
  );
}

class _StatItem extends StatelessWidget {
  final String value;
  final String? label;
  final Widget icon;
  final VoidCallback? onTap;

  const _StatItem({
    required this.value,
    this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          icon,
          4.verticalSpace,
          if (value.contains('⭐'))
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText.bodyLg(value.replaceAll(' ⭐', ''), fontWeight: FontWeight.w700),
                4.horizontalSpace,
                const Icon(Icons.star, color: AppColors.star, size: 16),
              ],
            )
          else
            AppText.bodyLg(value, fontWeight: FontWeight.w700),
          if (label != null) ...[
            AppText.bodySm(label!, color: AppColors.textSecondary),
          ],
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 50,
      color: AppColors.border,
    );
  }
}
