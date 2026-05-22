part of 'welcome_screen.dart';

void showAuthUI(WidgetRef ref, {required bool isLogin, AppRole? role}) {
  if (kIsWeb) {
    showWebOverlay(
      ref,
      _signinSignupSelectionWidget(ref, isLogin: isLogin, role: role),
    );
  } else {
    showModalBottomSheet(
      context: ref.context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return _signinSignupSelectionWidget(ref, isLogin: isLogin, role: role);
      },
    );
  }
}

Widget _signinSignupSelectionWidget(
  WidgetRef ref, {
  required bool isLogin,
  AppRole? role,
}) {
  return Padding(
    padding: 24.paddingAll,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText.h2(isLogin ? "Login" : "Create Account"),
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
          label: isLogin ? "Login with email" : "Create with email",
          borderColor: AppColors.black,

          onPressed: () async {
            await _close(ref);
            if (isLogin) {
              _showLoginAccountDialog(ref);
            } else if (role != null) {
              _showCreateAccountDialog(ref, role: role);
            }
          },
        ),
        16.verticalSpace,
        if (!isLogin)
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
}
