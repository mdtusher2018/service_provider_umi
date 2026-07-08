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
      12.verticalSpace,
      AppText.h2(data.name),
      4.verticalSpace,
      AppText.labelLg(
        data.serviceProviderInfo?.specialists.isNotEmpty == true
            ? data.serviceProviderInfo!.specialists.first.name
            : "N/A",
        color: AppColors.primaryFor(ref.watch(appRoleProvider)),
      ),
      16.verticalSpace,

      16.verticalSpace,
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: 16.circular,
          border: Border.all(color: AppColors.borderFocus),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            AppAvatar(
              imageUrl: Assets.icons.chatIcon.keyName,
              size: AvatarSize.md,
              onTap: () {
                ref.context.showSnackBar(
                  showAtTop: true,
                  "You can't chat with provider before booking a job",
                );
                // final myUserId = await getMyUserId(ref);
                //
                // ref.context.push(
                //   AppRoutes.chatPath((chatId.isEmpty) ? data.id : chatId),
                //   extra: {
                //     'otherUserId': data.id,
                //     'name': data.name,
                //     'myId': myUserId,
                //     'imageUrl': data.profileImage ?? "",
                //   },
                // );
              },
              backgroundColor: AppColors.primaryFor(ref.watch(appRoleProvider)),
            ),
            _StatDivider(),
            _StatItem(
              value: '${data.avgRating?.toStringAsFixed(2)} ⭐',
              label: '${data.totalReview} reviews',
            ),
            _StatDivider(),
            _StatItem(value: '${1}', label: 'Service'),
            _StatDivider(),
            _StatItem(
              value: '',
              icon: Icon(Icons.verified, color: AppColors.info, size: 40),

              valueColor: AppColors.primaryFor(ref.watch(appRoleProvider)),
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
  final Color? valueColor;
  final Widget? icon;
  const _StatItem({
    required this.value,
    this.label,
    this.valueColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (value.isNotEmpty)
          AppText.h3(value, color: valueColor ?? AppColors.textPrimary),
        ?icon,
        2.verticalSpace,
        if (label != null) AppText.bodySm(label!),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 50, color: AppColors.borderFocus);
  }
}
