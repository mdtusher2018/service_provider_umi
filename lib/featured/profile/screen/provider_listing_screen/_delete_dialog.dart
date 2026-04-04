part of 'provider_listing_screen.dart';

// ─── Delete Dialog ────────────────────────────────────────────
class _DeleteDialog extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;
  const _DeleteDialog({required this.onYes, required this.onNo});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: 20.circular),
      insetPadding: 40.paddingH,
      child: Padding(
        padding: 24.paddingAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.h3(
              'Are you sure you want to delete ?',

              textAlign: TextAlign.center,
            ),
            20.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onYes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryProvider,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: 10.circular),
                ),
                child: AppText(
                  'YES, DELETE',
                  style: AppTextStyles.buttonMd.copyWith(letterSpacing: 0.5),
                ),
              ),
            ),
            10.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: onNo,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.grey300),
                  shape: RoundedRectangleBorder(borderRadius: 10.circular),
                ),
                child: AppText(
                  "NO, DON'T DELETE",
                  style: AppTextStyles.buttonMd.copyWith(
                    color: AppColors.textPrimary,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
