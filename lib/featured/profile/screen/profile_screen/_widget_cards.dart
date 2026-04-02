part of "profile_screen.dart";

Widget _buildSwitchTile(WidgetRef ref) {
  final currentRole = ref.watch(appRoleProvider);
  final isProvider = currentRole == AppRole.provider;

  return GestureDetector(
    onTap: () {
      ref.read(appRoleProvider.notifier).switchRole();
      if (ref.read(appRoleProvider) == AppRole.provider) {
        ref.context.go(AppRoutes.providerOnboarding);

        return;
      }
      ref.context.go(AppRoutes.root);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(Icons.sync),
          12.horizontalSpace,
          Expanded(
            child: AppText(
              isProvider
                  ? 'Switch to user version'
                  : 'Switch to professional version',
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildUserCard(
  WidgetRef ref, {
  required String name,
  required String phone,
  required String avaterUrl,
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
              links: [AppTextLink(label: "Not verified", onTap: () {})],
              "Verification : Not verified",
              linkColor: AppColors.primaryFor(ref.watch(appRoleProvider)),
            ),
        ],
      ),
    ],
  );
}
