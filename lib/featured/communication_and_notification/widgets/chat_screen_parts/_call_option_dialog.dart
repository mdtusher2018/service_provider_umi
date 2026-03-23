part of '../../screens/chat_screen.dart';

// ─── Call Option Dialog ───────────────────────────────────────
class _CallOptionDialog extends StatelessWidget {
  final String contactName;
  final String? contactImageUrl;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  const _CallOptionDialog({
    required this.contactName,
    this.contactImageUrl,
    required this.onCall,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.h3('Choose option'),
                GestureDetector(
                  onTap: () => context.pop(),
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: AppAvatar(
                  name: contactName,
                  imageUrl: contactImageUrl,
                  size: AvatarSize.lg,
                ),
              ),
            ),
            16.verticalSpace,
            AppButton.primary(label: '📞  Call', onPressed: onCall),
            10.verticalSpace,
            AppButton.outline(label: '💬  Message', onPressed: onMessage),
          ],
        ),
      ),
    );
  }
}
