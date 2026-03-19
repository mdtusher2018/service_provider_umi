part of '../../screens/chat_screen.dart';

// ─── Block User Dialog ────────────────────────────────────────
class _BlockUserDialog extends StatelessWidget {
  final String userName;
  final VoidCallback onBlock;
  final VoidCallback onCancel;

  const _BlockUserDialog({
    required this.userName,
    required this.onBlock,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            14.verticalSpace,

            // Title
            AppText.h3(
              'Are you sure you want to\nBlock this User?',
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,

            // Yes, Block
            AppButton.primary(label: 'Yes, Block', onPressed: onBlock),
            10.verticalSpace,

            // No, Don't Block
            AppButton.ghost(
              label: "No, Don't Block",
              onPressed: onCancel,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
