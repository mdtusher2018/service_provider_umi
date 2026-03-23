part of 'profile_picture_screen.dart';

// ─── Go Back Dialog ───────────────────────────────────────────
class _GoBackDialog extends StatelessWidget {
  final VoidCallback onStay;
  final VoidCallback onGoBack;
  const _GoBackDialog({required this.onStay, required this.onGoBack});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.h3('Do you want to go back?'),
                    GestureDetector(
                      onTap: onStay,
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.grey400,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                8.verticalSpace,
                AppText.bodySm(
                  'If you go back, any information completed in this '
                  'section will be lost',
                ),
                24.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onStay,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.grey300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: AppText.bodyMd(
                          'Stay',

                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onGoBack,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: AppText(
                          'Go back',
                          style: AppTextStyles.buttonMd,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
