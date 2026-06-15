part of 'welcome_screen.dart';

void _showOTPVerifyDialog(
  WidgetRef ref, {
  required String email,
  required bool isSignup,
  AppRole? role,
}) {
  if (kIsWeb) {
    showWebOverlay(
      ref,
      _OTPVerifyDialog(
        email: email,
        isSignup: isSignup,
        role: role,
        parentRef: ref,
      ),
    );
  } else {
    showGeneralDialog(
      context: rootNavigatorKey.currentContext!,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      pageBuilder: (_, _, _) => Dialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: 20.circular),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),

        child: _OTPVerifyDialog(
          email: email,
          isSignup: isSignup,
          role: role,
          parentRef: ref,
        ),
      ),
    );
  }
}

class _OTPVerifyDialog extends ConsumerStatefulWidget {
  final String email;
  final bool isSignup;
  final AppRole? role;
  final WidgetRef parentRef;
  const _OTPVerifyDialog({
    required this.email,
    required this.isSignup,
    required this.role,
    required this.parentRef,
  });

  @override
  ConsumerState<_OTPVerifyDialog> createState() => _OTPVerifyDialogState();
}

class _OTPVerifyDialogState extends ConsumerState<_OTPVerifyDialog> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _otpSecondsProvider = StateProvider.autoDispose<int>(
    (ref) => AppConstants.otpResendableAfter,
  );
  final _otpCanResendProvider = StateProvider.autoDispose<bool>((ref) => false);

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
    ref.read(_otpSecondsProvider.notifier).state =
        AppConstants.otpResendableAfter;

    ref.read(_otpCanResendProvider.notifier).state = false;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      final seconds = ref.read(_otpSecondsProvider);

      if (seconds <= 1) {
        ref.read(_otpSecondsProvider.notifier).state = 0;
        ref.read(_otpCanResendProvider.notifier).state = true;
        return false;
      }

      ref.read(_otpSecondsProvider.notifier).state = seconds - 1;

      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final seconds = ref.watch(_otpSecondsProvider);
    final canResend = ref.watch(_otpCanResendProvider);
    ref.listen<AuthState>(otpVerifyProvider, (_, state) {
      state.when(
        initial: () {},
        loading: () {},
        success: () async {
          context.showSnackBar('OTP Verified Successfully');
          if (!kIsWeb && mounted) {
            Navigator.of(context).pop();
          }

          if (widget.isSignup) {
            if (widget.role == AppRole.user) {
              AppLogger.debug("Going to user home page");
              if (widget.parentRef.context.mounted) {
                widget.parentRef.read(appRoleProvider.notifier).loginAsUser();
                widget.parentRef.context.go(AppRoutes.userHome);
              }
            } else if (widget.role == AppRole.provider) {
              AppLogger.debug("Going to provider onboarding");
              if (widget.parentRef.context.mounted) {
                widget.parentRef.read(appRoleProvider.notifier).loginAsProvider();
                widget.parentRef.context.go(AppRoutes.providerHome);
              }
            } else {
              if (widget.parentRef.context.mounted) {
                widget.parentRef.context.showSnackBar("Please select your role");
              }
            }
          } else {
            AppLogger.debug(
              "OTP verified for forgot password flow, showing reset password dialog",
            );
            if (widget.parentRef.context.mounted) {
              _showResetPasswordDialog(widget.parentRef, email: widget.email);
            }
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

    return Padding(
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
                  onTap: isLoading ? null : () => Navigator.of(context).pop(),
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
            canResend
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
                    'Resend OTP in ${seconds}s',
                    color: AppColors.textSecondary,
                  ),
            10.verticalSpace,
          ],
        ),
      ),
    );
  }

  void _onOTPVerify() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(otpVerifyProvider.notifier).verifyOtp(_otpController.text.trim());
  }
}
