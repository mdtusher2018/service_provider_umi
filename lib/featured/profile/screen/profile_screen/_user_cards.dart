part of "profile_screen.dart";

Widget _buildUserCard(
  BuildContext context,
  WidgetRef ref, {
  required String name,
  required String phone,
  required String avaterUrl,
  bool isStripeConnected = false,
}) {
  return Row(
    children: [
      AppAvatar(name: name, imageUrl: avaterUrl, size: AvatarSize.md),
      14.horizontalSpace,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.h3(name),
          if (ref.watch(appRoleProvider) == AppRole.user)
            AppText.bodySm(phone, color: AppColors.textSecondary),
          if (ref.watch(appRoleProvider) == AppRole.provider)
            AppLinkText(
              links: [
                AppTextLink(
                  label: AppLocalizations.of(context)!.notConnected,
                  onTap: () {
                    ref.read(stripeConnectProvider.notifier).getStripeUrl();
                  },
                ),
              ],
              AppLocalizations.of(context)!.stripe(
                isStripeConnected ? AppLocalizations.of(context)!.connected : AppLocalizations.of(context)!.notConnected,
              ),
            ),
        ],
      ),
    ],
  );
}
