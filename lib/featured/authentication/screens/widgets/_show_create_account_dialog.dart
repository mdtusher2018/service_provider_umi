part of '../welcome_screen.dart';

void _showCreateAccountDialog(WidgetRef ref, {required AppRole role}) {
  showDialog(
    context: ref.context,
    builder: (_) {
      return Dialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Padding(
          padding: 24.paddingAll,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText.h2("Create account"),
                  InkWell(
                    onTap: () {
                      ref.context.pop();
                    },
                    child: Icon(Icons.close),
                  ),
                ],
              ),

              24.verticalSpace,

              AppTextField(hint: "Enter your name"),

              16.verticalSpace,

              AppTextField(hint: "Enter email"),

              16.verticalSpace,

              AppTextField(
                hint: "Password",
                obscureText: true,
                showPasswordToggle: true,
              ),

              24.verticalSpace,
              AppButton.primary(
                label: "Create Account",
                onPressed: () {
                  ref.context.pop();
                  _showPrivacyPolicyBottomSheet(ref);
                },
              ),

              10.verticalSpace,
              AppLinkText(
                "Do you have an account?  Log in",
                textColor: AppColors.textPrimary,
                links: [
                  AppTextLink(
                    label: "Log in",
                    onTap: () {
                      ref.context.pop();
                      _showLoginAccountDialog(ref);
                    },
                  ),
                ],
              ),
              16.verticalSpace,
              AppLinkText(
                "By creating an account, I accept the Terms and Condition and confirm that I have read the Privacy Policy",
                textSize: 12,
                links: [
                  AppTextLink(
                    label: "Terms and Condition",
                    onTap: () {
                      print("Open Terms");
                    },
                  ),
                  AppTextLink(label: "Privacy Policy", onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
