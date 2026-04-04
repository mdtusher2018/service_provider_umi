part of '../welcome_screen.dart';

void _showOTPVerifyDialog(
  WidgetRef ref, {
  required String email,
  required bool isSignup,
  AppRole? role,
}) {
  showGeneralDialog(
    context: ref.context,
    transitionDuration: dialogSlidingFadeTransitionDuration,
    transitionBuilder: dialogSlideFadeTransition,
    pageBuilder: (_, _, _) =>
        _OTPVerifyDialog(email: email, isSignup: isSignup, role: role),
  );
}

class _OTPVerifyDialog extends ConsumerStatefulWidget {
  final String email;
  final bool isSignup;
  final AppRole? role;
  const _OTPVerifyDialog({
    required this.email,
    required this.isSignup,
    required this.role,
  });

  @override
  ConsumerState<_OTPVerifyDialog> createState() => _OTPVerifyDialogState();
}

class _OTPVerifyDialogState extends ConsumerState<_OTPVerifyDialog> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _seconds = AppConstants.otpResendableAfter;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _seconds = AppConstants.otpResendableAfter;
    _canResend = false;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        _seconds--;
        if (_seconds <= 0) _canResend = true;
      });
      return _seconds > 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(otpVerifyProvider, (_, state) {
      state.when(
        initial: () {},
        loading: () {},
        success: () {
          if (widget.isSignup) {
            if (widget.role == AppRole.user) {
              ref.read(appRoleProvider.notifier).loginAsUser();
              context.go(AppRoutes.root);
            } else if (widget.role == AppRole.provider) {
              ref.read(appRoleProvider.notifier).loginAsProvider();
              context.go(AppRoutes.providerOnboarding);
            } else {
              context.showSnackBar("Please select your role");
            }
          } else {
            _showResetPasswordDialog(ref, email: widget.email);
          }
        },
        failure: (error) => context.showErrorSnackBar(error.message),
      );
    });

    ref.listen<AuthState>(resendOtpProvider, (_, state) {
      state.when(
        initial: () {},
        loading: () {},
        success: () {
          context.showSnackBar('OTP resent successfully');
          _startCountdown();
        },
        failure: (e) => context.showErrorSnackBar(e.message),
      );
    });

    final isLoading =
        ref.watch(otpVerifyProvider) is AuthLoading ||
        ref.watch(resendOtpProvider) is AuthLoading;

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
                  const AppText.h2('Verify OTP'),
                  InkWell(
                    onTap: isLoading ? null : () => context.pop(),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              12.verticalSpace,
              if (widget.email.isNotEmpty)
                AppText.bodyMd(
                  'Enter the OTP sent to ${widget.email}',
                  color: AppColors.textSecondary,
                ),
              24.verticalSpace,

              AppTextField(
                controller: _otpController,
                hint: 'Enter the OTP',
                keyboardType: TextInputType.number,
                validator: (v) => Validators.otp(v),
              ),
              24.verticalSpace,

              AppButton.primary(
                label: 'Verify',
                isLoading: isLoading,
                onPressed: isLoading ? null : _onOTPVerify,
              ),
              16.verticalSpace,

              // Resend countdown / button
              _canResend
                  ? AppLinkText(
                      'Didn\'t receive OTP?  Resend',
                      links: [
                        AppTextLink(
                          label: 'Resend',
                          onTap: () {
                            if (isLoading) return;
                            if (widget.email.isNotEmpty) {
                              ref
                                  .read(resendOtpProvider.notifier)
                                  .resendOtp(widget.email);
                            }
                          },
                        ),
                      ],
                    )
                  : AppText.bodyMd(
                      'Resend OTP in ${_seconds}s',
                      color: AppColors.textSecondary,
                    ),
              10.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  void _onOTPVerify() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(otpVerifyProvider.notifier).verifyOtp(_otpController.text.trim());
  }
}
