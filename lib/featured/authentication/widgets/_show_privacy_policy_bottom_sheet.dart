part of '../welcome_screen.dart';

void _showPrivacyPolicyBottomSheet(WidgetRef ref) {
  showModalBottomSheet(
    context: ref.context,
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

            AppButton.primary(
              label: "Accept",
              onPressed: () {
                ref.read(appRoleProvider.notifier).loginAsUser();
                Navigator.push(
                  ref.context,
                  MaterialPageRoute(
                    builder: (context) {
                      return RootScreen();
                    },
                  ),
                );
              },
            ),

            10.verticalSpace,
          ],
        ),
      );
    },
  );
}
