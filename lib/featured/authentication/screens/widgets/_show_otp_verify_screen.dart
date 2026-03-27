part of '../welcome_screen.dart';

void _showOTPVerifyDialog(WidgetRef ref) {
  showDialog(context: ref.context, builder: (_) => _OTPVerifyDialog());
}

class _OTPVerifyDialog extends ConsumerStatefulWidget {
  const _OTPVerifyDialog();

  @override
  ConsumerState<_OTPVerifyDialog> createState() => _OTPVerifyDialogState();
}

class _OTPVerifyDialogState extends ConsumerState<_OTPVerifyDialog> {
  final _otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Listen to auth state (same as login)
    ref.listen<AuthState>(otpVerifyProvider, (_, state) {
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

    final isLoading = ref.watch(otpVerifyProvider) is AuthLoading;

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
                  const AppText.h2("Verify OTP"),
                  InkWell(
                    onTap: isLoading ? null : () => context.pop(),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),

              24.verticalSpace,

              /// OTP
              AppTextField(
                controller: _otpController,
                hint: "Enter the OTP",
                keyboardType: TextInputType.phone,
                validator: (value) => Validators.otp(value),
              ),

              24.verticalSpace,

              /// Signup Button
              AppButton.primary(
                label: "Verify",
                isLoading: isLoading,
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  _onOTPVerify();
                },
              ),

              10.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  // 🔥 Signup action
  void _onOTPVerify() {
    ref
        .read(otpVerifyProvider.notifier)
        .verifyOtp(otp: _otpController.text.trim());
  }
}
