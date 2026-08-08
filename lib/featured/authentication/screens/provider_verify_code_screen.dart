import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/config/app_constants.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import '../../../../../core/di/app_role_provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/enums/app_enums.dart';
import '../riverpod/auth_provider.dart';

class VerifyOTPScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  const VerifyOTPScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<VerifyOTPScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends ConsumerState<VerifyOTPScreen> {
  // Use AppConstants.otpLength instead of hardcoded 4
  final List<TextEditingController> _controllers = List.generate(
    AppConstants.otpLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    AppConstants.otpLength,
    (_) => FocusNode(),
  );

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  bool get _isComplete => _code.length == AppConstants.otpLength;

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < AppConstants.otpLength - 1) {
      // Auto-advance to next box
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      // On delete, go back
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _done() async {
    if (!_isComplete) return;

    ref.read(otpVerifyProvider.notifier).verifyOtp(_code);
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(appRoleProvider);
    final primary = AppColors.primaryFor(role);
    final otpState = ref.watch(otpVerifyProvider);
    final isLoading = otpState is AuthLoading;

    ref.listen<AuthState>(otpVerifyProvider, (previous, next) {
      next.when(
        initial: () {},
        loading: () {},
        success: () {
          context.showSnackBar(AppLocalizations.of(context)!.otpVerifiedSuccessfully);
          if (role == AppRole.provider) {
            ref.read(appRoleProvider.notifier).loginAsProvider();
            context.go(AppRoutes.providerHome);
          } else {
            ref.read(appRoleProvider.notifier).loginAsUser();
            context.go(AppRoutes.userHome);
          }
        },
        failure: (failure) {
          context.showErrorSnackBar(failure.message);
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: 24.paddingAll,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // ─── Title ──────────────────────────────
              AppText(
                'Enter ${AppConstants.otpLength} digits code',
                style: AppTextStyles.h1,
              ),
              10.verticalSpace,
              AppText.bodyMd(
                'Enter the ${AppConstants.otpLength} digits code that you received on you\nphone number',
                textAlign: TextAlign.center,
              ),
              40.verticalSpace,

              // ─── Digit boxes ───────────────────────
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(AppConstants.otpLength, (i) {
                    return Padding(
                      padding: 4.paddingH,
                      child: _DigitBox(
                        controller: _controllers[i],
                        focusNode: _focusNodes[i],
                        primary: primary,
                        onChanged: (v) => _onDigitChanged(i, v),
                      ),
                    );
                  }),
                ),
              ),

              const Spacer(),

              // ─── Done button ─────────────────────────
              AppButton.primary(
                label: "Done",
                onPressed: isLoading ? null : _done,
                isLoading: isLoading,
              ),

              16.verticalSpace,

              // ─── Resend ─────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    "Didn't receive the code? ",
                    style: AppTextStyles.bodySm,
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: resend OTP
                    },
                    child: AppText.labelLg('Resend'),
                  ),
                ],
              ),

              context.bottomPadding.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Single digit box ─────────────────────────────────────────
class _DigitBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Color primary;
  final ValueChanged<String> onChanged;

  const _DigitBox({
    required this.controller,
    required this.focusNode,
    required this.primary,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: 12.circular,
      ),
      child: Center(
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onChanged,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: primary,
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

