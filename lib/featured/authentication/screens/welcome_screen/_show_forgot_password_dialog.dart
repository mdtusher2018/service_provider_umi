part of 'welcome_screen.dart';

void _showForgotPasswordDialog(WidgetRef ref) {
  if (kIsWeb) {
    showWebOverlay(ref, _ForgotPasswordDialog(parentRef: ref));
  } else {
    showGeneralDialog(
      context: ref.context,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      pageBuilder: (_, _, _) => Dialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: 20.circular),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: _ForgotPasswordDialog(parentRef: ref),
      ),
    );
  }
}

class _ForgotPasswordDialog extends ConsumerStatefulWidget {
  const _ForgotPasswordDialog({required this.parentRef});
  final WidgetRef parentRef;

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
          if (!kIsWeb) {
            context.pop();
          }
          _showOTPVerifyDialog(
            widget.parentRef,
            email: _emailCtrl.text.trim(),
            isSignup: false,
          );
        },
        failure: (e) => context.showErrorSnackBar(e.message),
      );
    });

    final isLoading = ref.watch(forgotPasswordProvider) is AuthLoading;

    return Padding(
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
                  onTap: isLoading
                      ? null
                      : () async {
                          await _close(ref);
                        },
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
          ],
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
