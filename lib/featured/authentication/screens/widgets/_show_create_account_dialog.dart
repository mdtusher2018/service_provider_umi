part of '../welcome_screen.dart';

void _showCreateAccountDialog(WidgetRef ref, {required AppRole role}) {
  showDialog(
    context: ref.context,
    builder: (_) => _SignupDialog(role: role),
  );
}

class _SignupDialog extends ConsumerStatefulWidget {
  final AppRole role;

  const _SignupDialog({required this.role});

  @override
  ConsumerState<_SignupDialog> createState() => _SignupDialogState();
}

class _SignupDialogState extends ConsumerState<_SignupDialog> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Listen to auth state (same as login)
    ref.listen<AuthState>(signupProvider, (_, state) {
      state.when(
        initial: () {},
        loading: () {},
        success: () {
          // ref.read(appRoleProvider.notifier).loginAsUser();
          // context.go(AppRoutes.userHome);
          Navigator.pop(context);
          _showOTPVerifyDialog(
            ref,
            email: _emailController.text.trim(),
            isSignup: true,
          );
        },
        failure: (error) {
          context.showErrorSnackBar(error.message);
        },
      );
    });

    final isLoading = ref.watch(signupProvider) is AuthLoading;

    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
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
                    onTap: isLoading ? null : () => context.pop(),
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
                    _onSignup();
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
                    onTap: () {
                      context.pop();
                      _showLoginAccountDialog(ref);
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
      ),
    );
  }

  // 🔥 Signup action
  void _onSignup() {
    ref
        .read(signupProvider.notifier)
        .signup(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }
}
