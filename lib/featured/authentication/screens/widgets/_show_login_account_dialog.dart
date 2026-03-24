part of '../welcome_screen.dart';

void _showLoginAccountDialog(WidgetRef ref) {
  showDialog(context: ref.context, builder: (_) => const _LoginDialog());
}

class _LoginDialog extends ConsumerStatefulWidget {
  const _LoginDialog();

  @override
  ConsumerState<_LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends ConsumerState<_LoginDialog> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for state changes → navigate or show error
    ref.listen<AuthState>(authProvider, (_, state) {
      state.when(
        initial: () {},
        loading: () {},
        success: (_) {
          ref.read(appRoleProvider.notifier).loginAsUser();

          context.go(AppRoutes.userHome);
        },
        failure: (error) {
          context.showErrorSnackBar(error.message);
        },
      );
    });

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
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText.h2("Login"),
                  InkWell(
                    onTap: ref.watch(authProvider) is AuthLoading
                        ? null
                        : () => context.pop(),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),

              24.verticalSpace,

              AppTextField(
                controller: _emailController,
                hint: "Enter email",
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validators.email(value),
              ),

              16.verticalSpace,

              AppTextField(
                controller: _passwordController,
                hint: "Password",
                obscureText: true,
                showPasswordToggle: true,
                validator: (value) => Validators.password(value),
              ),

              24.verticalSpace,

              AppButton.primary(
                label: "Log in",
                isLoading: ref.watch(authProvider) is AuthLoading,
                onPressed: _onLogin,
              ),

              16.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  void _onLogin() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(authProvider.notifier)
        .loginWithEmail(_emailController.text.trim(), _passwordController.text);
  }
}
