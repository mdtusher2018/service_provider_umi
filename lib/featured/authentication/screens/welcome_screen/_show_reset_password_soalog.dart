part of 'welcome_screen.dart';

void _showResetPasswordDialog(WidgetRef ref, {required String email}) {
  if (kIsWeb) {
    showWebOverlay(ref, _ResetPasswordDialog(email: email, parentRef: ref));
  } else {
    showGeneralDialog(
      context: rootNavigatorKey.currentContext!,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      pageBuilder: (_, _, _) => Dialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: 20.circular),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: _ResetPasswordDialog(email: email, parentRef: ref),
      ),
    );
  }
}

class _ResetPasswordDialog extends ConsumerStatefulWidget {
  final String email;
  final WidgetRef parentRef;
  const _ResetPasswordDialog({required this.email, required this.parentRef});

  @override
  ConsumerState<_ResetPasswordDialog> createState() =>
      _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends ConsumerState<_ResetPasswordDialog> {
  final _newPassCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Step 2: actual password reset
    ref.listen<AuthState>(resetPasswordProvider, (_, state) {
      state.when(
        initial: () {},
        loading: () {},
        success: () async {
          if (!context.mounted) return;
          Navigator.of(context).pop();
          rootNavigatorKey.currentContext?.showSnackBar(
            AppLocalizations.of(context)!.passwordResetSuccessfully,
          );
          _showLoginAccountDialog(widget.parentRef);
        },
        failure: (e) {
          if (!context.mounted) return;
          context.showErrorSnackBar(e.message);
        },
      );
    });

    final isOtpLoading = ref.watch(otpVerifyProvider) is AuthLoading;
    final isResetLoading = ref.watch(resetPasswordProvider) is AuthLoading;
    final isLoading = isOtpLoading || isResetLoading;

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
                AppText.h2(AppLocalizations.of(context)!.resetPassword),
                InkWell(
                  onTap: isLoading ? null : () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close),
                ),
              ],
            ),

            24.verticalSpace,

            // New Password
            AppTextField(
              controller: _newPassCtrl,
              hint: AppLocalizations.of(context)!.newPassword,
              obscureText: true,
              showPasswordToggle: true,
              validator: (v) => Validators.password(v),
            ),
            16.verticalSpace,

            // Confirm Password
            AppTextField(
              controller: _confirmPassCtrl,
              hint: AppLocalizations.of(context)!.confirmNewPassword,
              obscureText: true,
              showPasswordToggle: true,
              validator: (v) =>
                  Validators.confirmPassword(v, _newPassCtrl.text),
            ),
            24.verticalSpace,

            AppButton.primary(
              label: AppLocalizations.of(context)!.resetPassword,
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
    // First verify OTP, then reset (chained via listeners above)
    ref
        .read(resetPasswordProvider.notifier)
        .resetPassword(
          newPassword: _newPassCtrl.text.trim(),
          confirmPassword: _confirmPassCtrl.text.trim(),
        );
  }
}
