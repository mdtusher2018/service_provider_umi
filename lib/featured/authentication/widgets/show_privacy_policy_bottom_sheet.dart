part of '../welcome_screen.dart';

void showPrivacyPolicyBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Icon(
                Icons.privacy_tip,
                size: 60,
                color: AppColors.primary,
              ),
            ),

            16.verticalSpace,

            const AppText.h3("We value your privacy"),

            8.verticalSpace,

            const AppText.bodySm(
              "Webel uses cookies to analyse advertising campaign performance, improve app ads, and personalize the experience based on user preference.",
            ),

            20.verticalSpace,

            Container(
              height: 45,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: AppText.labelLg("Accept", color: AppColors.white),
              ),
            ),

            10.verticalSpace,
          ],
        ),
      );
    },
  );
}
