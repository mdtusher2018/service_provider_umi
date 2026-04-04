part of 'profile_screen.dart';

// ─── Logout dialog ────────────────────────────────────────────
class _LogoutDialog extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onLogout;
  const _LogoutDialog({required this.onCancel, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: 20.circular),
      insetPadding: 32.paddingH,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: onCancel,
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ),
            ),
            8.verticalSpace,
            const AppText.h3('Are you sure you want to log out?'),
            20.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: 10.circular),
                      padding: 12.paddingV,
                    ),
                    child: const AppText.labelLg('Cancel'),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: ElevatedButton(
                    onPressed: onLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: 10.circular),
                      padding: 12.paddingV,
                    ),
                    child: const AppText.labelLg(
                      'Log out',
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
