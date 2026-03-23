part of 'provider_profile_screen.dart';

// ─────────────────────────────────────────────────────────────
//  GuestLoginDialog
//
//  Shows when a guest tries to tap a protected action.
//  Two CTAs: Log In → goes to login screen
//            Create Account → goes to register screen
// ─────────────────────────────────────────────────────────────

class GuestLoginDialog extends StatelessWidget {
  final VoidCallback? onLogin;
  final VoidCallback? onRegister;

  const GuestLoginDialog({super.key, this.onLogin, this.onRegister});

  /// Convenience: show from anywhere
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onLogin,
    VoidCallback? onRegister,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) =>
          GuestLoginDialog(onLogin: onLogin, onRegister: onRegister),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Close ────────────────────────────────
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.close_rounded,
                  color: AppColors.grey400,
                  size: 20,
                ),
              ),
            ),
            4.verticalSpace,

            // ─── Icon ─────────────────────────────────
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            16.verticalSpace,

            // ─── Title ────────────────────────────────
            AppText(
              'Login Required',
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,

            // ─── Subtitle ─────────────────────────────
            AppText(
              'You need to be logged in to view availability '
              'and book a service. Please log in or create a '
              'free account.',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,

            // ─── Log In button ────────────────────────
            AppButton.primary(label: "Log In"),
            10.verticalSpace,

            // ─── Create Account button ────────────────
            AppButton.outline(label: "Create Account"),
          ],
        ),
      ),
    );
  }
}
