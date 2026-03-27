part of '../welcome_screen.dart';

Future<bool?> _showPrivacyPolicyBottomSheet(WidgetRef ref) {
  return showModalBottomSheet(
    context: ref.context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return Padding(
        padding: 24.paddingAll,
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

            AppButton.primary(
              label: "Accept",
              onPressed: () {
                Navigator.pop(ref.context, true);
              },
            ),

            10.verticalSpace,
          ],
        ),
      );
    },
  );
}
