part of '../../screens/communication_and_notification_screen.dart';

// ─── Contact Tile ─────────────────────────────────────────────
class _ContactTile extends ConsumerWidget {
  final InboxContact contact;
  final VoidCallback onTap;
  const _ContactTile({required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 6),
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 5,
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              AppAvatar(
                name: contact.name,
                imageUrl: contact.imageUrl,
                size: AvatarSize.md,
                isOnline: contact.isOnline,
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.labelLg(contact.name),
                    2.verticalSpace,
                    AppText.bodySm(
                      contact.lastMessage,
                      maxLines: 1,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText.bodyXs(contact.lastTime.toRelativeTime),
                  4.verticalSpace,
                  if (contact.unreadCount > 0)
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.primaryFor(ref.watch(appRoleProvider)),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: AppText.bodySm(
                          '${contact.unreadCount}',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
