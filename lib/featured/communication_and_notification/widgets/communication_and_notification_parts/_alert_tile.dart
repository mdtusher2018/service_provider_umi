part of '../../screens/communication_and_notification_screen.dart';

// ─── Alert Tile ───────────────────────────────────────────────
class _AlertTile extends StatelessWidget {
  final AlertItem alert;
  const _AlertTile({required this.alert});

  @override
  Widget build(BuildContext context) {
    Color iconBg;
    Color iconColor;
    IconData icon;

    switch (alert.type) {
      case AlertType.orderAccepted:
        iconBg = AppColors.star;
        iconColor = AppColors.white;
        icon = Icons.check_circle_outline_rounded;
        break;
      case AlertType.orderComplete:
        iconBg = AppColors.success;
        iconColor = AppColors.white;
        icon = Icons.task_alt_rounded;
        break;
      case AlertType.cancelOrder:
        iconBg = AppColors.error;
        iconColor = AppColors.white;
        icon = Icons.cancel_outlined;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.labelLg(alert.title),
                  2.verticalSpace,
                  AppText.bodySm(
                    alert.description,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Icon(Icons.watch_later_outlined, size: 16),
                AppText.bodySm(
                  alert.time.toRelativeTime,
                  color: AppColors.textgrey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
