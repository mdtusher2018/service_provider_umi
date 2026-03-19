part of '../../screens/communication_and_notification_screen.dart';

// ─── History Tile ─────────────────────────────────────────────
class _HistoryTile extends ConsumerWidget {
  final CallHistory history;
  final VoidCallback onTap;
  const _HistoryTile({required this.history, required this.onTap});

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
                name: history.name,
                imageUrl: history.imageUrl,
                size: AvatarSize.md,
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.labelLg(history.name),
                    2.verticalSpace,
                    AppText.bodySm(
                      history.lastTime.toRelativeTime,
                      maxLines: 1,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              (history.type == CallType.audio)
                  ? Icon(Icons.call)
                  : Icon(Icons.videocam_outlined),
            ],
          ),
        ),
      ),
    );
  }
}
