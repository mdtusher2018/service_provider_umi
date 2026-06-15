part of 'welcome_screen.dart';

void _showCreateAccountDialog(WidgetRef ref, {required AppRole role}) {
  if (kIsWeb) {
    showWebOverlay(ref, _SignupDialog(role: role, parentRef: ref));
  } else {
    showGeneralDialog(
      context: rootNavigatorKey.currentContext!,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      pageBuilder: (_, _, _) => Dialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: 20.circular),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: _SignupDialog(role: role, parentRef: ref),
      ),
    );
  }
}

class _SignupDialog extends ConsumerWidget {
  final AppRole role;
  final WidgetRef parentRef;
  _SignupDialog({required this.role, required this.parentRef});

  final _nameController = TextEditingController();

  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Listen to auth state (same as login)
    ref.listen<AuthState>(signupProvider, (_, state) {
      state.when(
        initial: () {},
        loading: () {},
        success: () async {
          // ref.read(appRoleProvider.notifier).loginAsUser();
          // context.go(AppRoutes.userHome);

          if (!kIsWeb) {
            Navigator.of(context).pop();
          }

          _showOTPVerifyDialog(
            parentRef,
            email: _emailController.text.trim(),
            isSignup: true,
            role: role,
          );
        },
        failure: (error) {
          context.showErrorSnackBar(error.message);
        },
      );
    });

    final isLoading = ref.watch(signupProvider) is AuthLoading;

    return Padding(
      padding: 24.paddingAll,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const AppText.h2("Create account"),
                InkWell(
                  onTap: isLoading
                      ? null
                      : () async {
                          await _close(ref);
                        },
                  child: const Icon(Icons.close),
                ),
              ],
            ),

            24.verticalSpace,

            /// Name
            AppTextField(
              controller: _nameController,
              hint: "Enter your name",
              validator: (value) => Validators.required(value),
            ),

            16.verticalSpace,

            /// Email
            AppTextField(
              controller: _emailController,
              hint: "Enter email",
              keyboardType: TextInputType.emailAddress,
              validator: (value) => Validators.email(value),
            ),

            16.verticalSpace,

            /// Password
            AppTextField(
              controller: _passwordController,
              hint: "Password",
              obscureText: true,
              showPasswordToggle: true,
              validator: (value) => Validators.password(value),
            ),

            24.verticalSpace,

            /// Signup Button
            AppButton.primary(
              label: "Create Account",
              isLoading: isLoading,
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                final result = await _showPrivacyPolicyBottomSheet(ref);
                if (result == true) {
                  ref
                      .read(signupProvider.notifier)
                      .signup(
                        name: _nameController.text.trim(),
                        email: _emailController.text.trim(),
                        password: _passwordController.text,
                        role: role,
                      );
                }
              },
            ),

            10.verticalSpace,

            /// Login redirect
            AppLinkText(
              "Do you have an account?  Log in",
              textColor: AppColors.textPrimary,
              links: [
                AppTextLink(
                  label: "Log in",
                  onTap: () async {
                    await _close(ref);
                    _showLoginAccountDialog(parentRef);
                  },
                ),
              ],
            ),

            16.verticalSpace,

            /// Terms
            AppLinkText(
              "By creating an account, I accept the Terms and Condition and confirm that I have read the Privacy Policy",
              textSize: 12,
              links: [
                AppTextLink(label: "Terms and Condition", onTap: () {}),
                AppTextLink(label: "Privacy Policy", onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
