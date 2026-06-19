part of 'welcome_screen.dart';

void showAuthUI(WidgetRef parentRef, {required bool isLogin, AppRole? role}) {
  if (kIsWeb) {
    showWebOverlay(
      parentRef,
      _signinSignupSelectionWidget(parentRef, isLogin: isLogin, role: role),
    );
  } else {
    showModalBottomSheet(
      context: parentRef.context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            ref.listen<AuthState>(loginProvider, (_, state) {
              state.when(
                initial: () {},
                loading: () {},
                success: () async {
                  // Capture notifier before any await — parentRef is WelcomeScreen's stable ref
                  final roleNotifier = parentRef.read(appRoleProvider.notifier);
                  final role = await getMyRoleId(ref);
                  if (!context.mounted) return;
                  await _close(parentRef);
                  if (role == 'user') {
                    roleNotifier.loginAsUser();
                  } else {
                    roleNotifier.loginAsProvider();
                  }
                  final navContext = rootNavigatorKey.currentContext;
                  if (navContext != null && navContext.mounted) {
                    navContext.go(
                      role == 'user'
                          ? AppRoutes.userHome
                          : AppRoutes.providerHome,
                    );
                  }
                },
                failure: (error) {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                  AppLogger.error("FAILURE: ${error.message}");
                  if (parentRef.context.mounted) {
                    parentRef.context.showErrorSnackBar(error.message);
                  }
                },
              );
            });
            // Pass parentRef (stable) so child dialogs don't use the Consumer's transient ref
            return _signinSignupSelectionWidget(
              ref,
              isLogin: isLogin,
              role: role,
              stableRef: parentRef,
            );
          },
        );
      },
    );
  }
}

Widget _signinSignupSelectionWidget(
  WidgetRef ref, {
  required bool isLogin,
  AppRole? role,
  WidgetRef? stableRef,
}) {
  final isLoading = ref.watch(loginProvider) is AuthLoading;
  return Padding(
    padding: 24.paddingAll,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText.h2(isLogin ? "Login" : "Create Account"),
        12.verticalSpace,
        AppButton.outline(
          label: "Continue with Google",
          isLoading: isLoading,
          borderColor: AppColors.black,
          prefixIcon: Icon(Icons.g_mobiledata),
          onPressed: () {
            ref.read(loginProvider.notifier).withGoogle();
          },
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
              _showLoginAccountDialog(stableRef ?? ref);
            } else if (role != null) {
              _showCreateAccountDialog(stableRef ?? ref, role: role);
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
