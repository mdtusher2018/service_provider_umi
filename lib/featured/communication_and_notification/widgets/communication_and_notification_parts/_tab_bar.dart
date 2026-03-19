part of '../../screens/communication_and_notification_screen.dart';

// ─── Tab Bar ──────────────────────────────────────────────────
class _TabBar extends ConsumerWidget {
  final TabController controller;
  final bool isNotification;

  const _TabBar({required this.controller, required this.isNotification});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TabBar(
      controller: controller,
      dividerColor: AppColors.grey500,
      indicatorColor: AppColors.primaryFor(ref.watch(appRoleProvider)),
      indicatorWeight: 2,

      indicatorSize: TabBarIndicatorSize.label,
      tabs: [
        if (!isNotification || ref.watch(appRoleProvider) == AppRole.user)
          Tab(child: AppText.labelLg("Chat", fontWeight: FontWeight.w600)),
        if (isNotification || ref.watch(appRoleProvider) == AppRole.user)
          Tab(child: AppText.labelLg("Alerts", fontWeight: FontWeight.w600)),
        if (!isNotification && ref.watch(appRoleProvider) != AppRole.user)
          Tab(child: AppText.labelLg("History", fontWeight: FontWeight.w600)),
        if (isNotification)
          Tab(
            child: AppText.labelLg("Last Alerts", fontWeight: FontWeight.w600),
          ),
      ],
    );
  }
}
