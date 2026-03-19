part of '../welcome_screen.dart';

void _showRoleSelectionDialog(WidgetRef ref) {
  showDialog(
    context: ref.context,
    builder: (_) {
      return Dialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: AlignmentGeometry.topLeft,
                child: InkWell(
                  onTap: () {
                    ref.context.pop();
                  },
                  child: Icon(Icons.arrow_back),
                ),
              ),
              const AppText.h2(
                "What will you do on iumi?",
                color: AppColors.textSecondary,
              ),

              10.verticalSpace,

              const AppText.bodySm(
                "This decision is not final. You can later be both a client\nand a professional from the account if you wish.",
                textAlign: TextAlign.center,
              ),

              20.verticalSpace,

              InkWell(
                onTap: () {
                  ref.context.pop();
                  _showAuthBottomSheet(ref);
                },
                child: _categoryCard(
                  "Book a service",
                  "I am a Client",
                  "assets/book_service.png",
                ),
              ),

              12.verticalSpace,

              _categoryCard(
                "Offer services",
                "I am a Professional",
                "assets/offer_service.png",
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _categoryCard(String title, String subtitle, String image) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.white,
      border: Border.all(color: AppColors.border),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(image, width: 60, height: 60),
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.bodyLg(
                title,
                fontWeight: FontWeight.bold,
                color: AppColors.secondary,
              ),
              AppText.bodyMd(subtitle),
            ],
          ),
        ),
      ],
    ),
  );
}

void _showAuthBottomSheet(WidgetRef ref) {
  showModalBottomSheet(
    context: ref.context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppText.h2("Log in"),
            24.verticalSpace,
            AppButton(
              label: "Continue with Apple",
              variant: AppButtonVariant.social,
              backgroundColor: AppColors.black,
              textColor: AppColors.white,

              prefixIcon: Icon(Icons.apple, color: AppColors.white),
            ),
            12.verticalSpace,
            AppButton.outline(
              label: "Continue with Facebook",
              backgroundColor: Color(0xFF1877F2),
              textColor: AppColors.white,
              prefixIcon: Icon(Icons.facebook, color: AppColors.white),
            ),
            12.verticalSpace,
            AppButton.outline(
              label: "Continue with Google",
              borderColor: AppColors.black,
              prefixIcon: Icon(Icons.g_mobiledata),
              onPressed: () {},
            ),
            16.verticalSpace,
            Row(
              spacing: 16,
              children: [
                Expanded(child: AppDivider()),
                AppText.bodyLg("or"),
                Expanded(child: AppDivider()),
              ],
            ),

            AppButton.outline(
              label: "Log in with email",
              borderColor: AppColors.black,

              onPressed: () {
                ref.context.pop();
                showCreateAccountDialog(ref);
              },
            ),
            16.verticalSpace,
            AppLinkText(
              "By creating an account, I accept the Terms and Condition and confirm that I have read the Privacy Policy",

              links: [
                AppTextLink(
                  label: "Terms and Condition",
                  onTap: () {
                    print("Open Terms");
                  },
                ),
                AppTextLink(
                  label: "Privacy Policy",
                  onTap: () {
                    print("Open Privacy Policy");
                  },
                ),
              ],
            ),
            16.verticalSpace,
          ],
        ),
      );
    },
  );
}
