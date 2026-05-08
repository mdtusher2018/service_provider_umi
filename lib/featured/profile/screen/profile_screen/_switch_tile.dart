part of "profile_screen.dart";

Widget _buildSwitchTile(WidgetRef ref) {
  final currentRole = ref.watch(appRoleProvider);
  final isProvider = currentRole == AppRole.provider;

  return GestureDetector(
    onTap: () async {
      ref.read(appRoleProvider.notifier).switchRole();
      if (ref.read(appRoleProvider) == AppRole.provider) {
        final token =
            await ref.read(localStorageProvider).read(StorageKey.accessToken)
                as String? ??
            "";
        if (token.decodeJwt['role'] == 'service_provider') {
          AppLogger.debug("===========>>>>>>>>> 1");
          ref.context.go(AppRoutes.providerHome);
        } else {
          AppLogger.debug("===========>>>>>>>>> 2");
          ref.context.go(AppRoutes.providerOnboarding);
        }

        return;
      }
      AppLogger.debug("===========>>>>>>>>> 3");
      ref.context.go(AppRoutes.userHome);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: 16.circular,
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
