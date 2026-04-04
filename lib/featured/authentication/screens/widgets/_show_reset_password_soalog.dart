part of '../welcome_screen.dart';

void _showResetPasswordDialog(WidgetRef ref, {required String email}) {
  showGeneralDialog(
    context: ref.context,
    transitionDuration: dialogSlidingFadeTransitionDuration,
    transitionBuilder: dialogSlideFadeTransition,
    pageBuilder: (_, _, _) => _ResetPasswordDialog(email: email),
  );
}

class _ResetPasswordDialog extends ConsumerStatefulWidget {
  final String email;
  const _ResetPasswordDialog({required this.email});

  @override
  ConsumerState<_ResetPasswordDialog> createState() =>
      _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends ConsumerState<_ResetPasswordDialog> {
  final _otpCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Step 1: verify the OTP
    ref.listen<AuthState>(otpVerifyProvider, (_, state) {
      state.when(
        initial: () {},
        loading: () {},
        success: () {
          // OTP verified → now actually reset the password
          ref
              .read(resetPasswordProvider.notifier)
              .resetPassword(
                newPassword: _newPassCtrl.text,
                confirmPassword: _confirmPassCtrl.text,
              );
        },
        failure: (e) => context.showErrorSnackBar(e.message),
      );
    });

    // Step 2: actual password reset
    ref.listen<AuthState>(resetPasswordProvider, (_, state) {
      state.when(
        initial: () {},
        loading: () {},
        success: () {
          context.pop();
          context.showSnackBar('Password reset successfully. Please log in.');
          _showLoginAccountDialog(ref);
        },
        failure: (e) => context.showErrorSnackBar(e.message),
      );
    });

    final isOtpLoading = ref.watch(otpVerifyProvider) is AuthLoading;
    final isResetLoading = ref.watch(resetPasswordProvider) is AuthLoading;
    final isLoading = isOtpLoading || isResetLoading;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText.h2('Reset Password'),
                  InkWell(
                    onTap: isLoading ? null : () => context.pop(),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),

              24.verticalSpace,

              // New Password
              AppTextField(
                controller: _newPassCtrl,
                hint: 'New password',
                obscureText: true,
                showPasswordToggle: true,
                validator: (v) => Validators.password(v),
              ),
              16.verticalSpace,

              // Confirm Password
              AppTextField(
                controller: _confirmPassCtrl,
                hint: 'Confirm new password',
                obscureText: true,
                showPasswordToggle: true,
                validator: (v) =>
                    Validators.confirmPassword(v, _newPassCtrl.text),
              ),
              24.verticalSpace,

              AppButton.primary(
                label: 'Reset Password',
                isLoading: isLoading,
                onPressed: isLoading ? null : _submit,
              ),
              12.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // First verify OTP, then reset (chained via listeners above)
    ref.read(otpVerifyProvider.notifier).verifyOtp(_otpCtrl.text.trim());
  }
}
