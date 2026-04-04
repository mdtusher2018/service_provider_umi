part of '../welcome_screen.dart';

void _showLoginAccountDialog(WidgetRef ref) {
  showGeneralDialog(
    context: ref.context,
    transitionDuration: dialogSlidingFadeTransitionDuration,
    transitionBuilder: dialogSlideFadeTransition,
    pageBuilder: (_, _, _) => const _LoginDialog(),
  );
}

class _LoginDialog extends ConsumerStatefulWidget {
  const _LoginDialog();

  @override
  ConsumerState<_LoginDialog> createState() => _LoginDialogState();
}

class _LoginDialogState extends ConsumerState<_LoginDialog> {
  final _emailController = TextEditingController(
    text: kDebugMode ? "jolelal861@agoalz.com" : null,
  );
  final _passwordController = TextEditingController(
    text: kDebugMode ? "jolelal861@agoalz.com" : null,
  );
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(loginProvider, (_, state) {
      state.when(
        initial: () {},
        loading: () {},
        success: () {
          ref.read(appRoleProvider.notifier).loginAsUser();
          context.go(AppRoutes.root);
        },
        failure: (error) => context.showErrorSnackBar(error.message),
      );
    });

    final isLoading = ref.watch(loginProvider) is AuthLoading;

    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: 20.circular),
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
                  const AppText.h2('Login'),
                  InkWell(
                    onTap: isLoading ? null : () => context.pop(),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),

              24.verticalSpace,

              AppTextField(
                controller: _emailController,
                hint: 'Enter email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) => Validators.email(value),
              ),

              16.verticalSpace,

              AppTextField(
                controller: _passwordController,
                hint: 'Password',
                obscureText: true,
                showPasswordToggle: true,
                validator: (value) => Validators.password(value),
              ),

              8.verticalSpace,

              // Forgot password link
              Align(
                alignment: Alignment.centerRight,
                child: AppLinkText(
                  'Forgot password?',
                  links: [
                    AppTextLink(
                      label: 'Forgot password?',
                      onTap: () {
                        context.pop();
                        _showForgotPasswordDialog(ref);
                      },
                    ),
                  ],
                ),
              ),

              16.verticalSpace,

              AppButton.primary(
                label: 'Log in',
                isLoading: isLoading,
                onPressed: isLoading ? null : _onLogin,
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
        .read(loginProvider.notifier)
        .withEmail(_emailController.text.trim(), _passwordController.text);
  }
}
