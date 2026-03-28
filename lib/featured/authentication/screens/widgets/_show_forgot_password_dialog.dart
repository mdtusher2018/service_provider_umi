part of '../welcome_screen.dart';

void _showForgotPasswordDialog(WidgetRef ref) {
  showDialog(
    context: ref.context,
    builder: (_) => const _ForgotPasswordDialog(),
  );
}

class _ForgotPasswordDialog extends ConsumerStatefulWidget {
  const _ForgotPasswordDialog();

  @override
  ConsumerState<_ForgotPasswordDialog> createState() =>
      _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends ConsumerState<_ForgotPasswordDialog> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(forgotPasswordProvider, (_, state) {
      state.when(
        initial: () {},
        loading: () {},
        success: () {
          // Dismiss this dialog then open Reset Password dialog
          context.pop();
          _showOTPVerifyDialog(
            ref,
            email: _emailCtrl.text.trim(),
            isSignup: false,
          );
        },
        failure: (e) => context.showErrorSnackBar(e.message),
      );
    });

    final isLoading = ref.watch(forgotPasswordProvider) is AuthLoading;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText.h2('Forgot Password'),
                  InkWell(
                    onTap: isLoading ? null : () => context.pop(),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              12.verticalSpace,
              const AppText.bodyMd(
                'Enter your email and we\'ll send you a reset OTP.',
                color: AppColors.textSecondary,
              ),
              24.verticalSpace,
              AppTextField(
                controller: _emailCtrl,
                hint: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                validator: (v) => Validators.email(v),
              ),
              24.verticalSpace,
              AppButton.primary(
                label: 'Send OTP',
                isLoading: isLoading,
                onPressed: isLoading ? null : _submit,
              ),
              12.verticalSpace,
              Center(
                child: AppLinkText(
                  'Back to  Login',
                  links: [
                    AppTextLink(
                      label: 'Login',
                      onTap: () {
                        context.pop();
                        _showLoginAccountDialog(ref);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(forgotPasswordProvider.notifier)
        .forgotPassword(_emailCtrl.text.trim());
  }
}
