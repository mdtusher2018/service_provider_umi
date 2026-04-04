import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

class VerifyOTPScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  const VerifyOTPScreen({super.key, required this.phoneNumber});

  @override
  ConsumerState<VerifyOTPScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends ConsumerState<VerifyOTPScreen> {
  // 4 separate controllers, one per digit box
  final List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  bool _isLoading = false;

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

  bool get _isComplete => _code.length == 4;

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 3) {
      // Auto-advance to next box
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      // On delete, go back
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  Future<void> _done() async {
    if (!_isComplete) return;
    setState(() => _isLoading = true);

    // Simulate verification
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isLoading = false);

    context.go(AppRoutes.root);
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(appRoleProvider);
    final primary = AppColors.primaryFor(role);

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
              AppText('Enter 4 digits code', style: AppTextStyles.h1),
              10.verticalSpace,
              AppText.bodyMd(
                'Enter the 4 digits code that you received on you\nphone number',

                textAlign: TextAlign.center,
              ),
              40.verticalSpace,

              // ─── 4 digit boxes ───────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  return Padding(
                    padding: 8.paddingH,
                    child: _DigitBox(
                      controller: _controllers[i],
                      focusNode: _focusNodes[i],
                      primary: primary,
                      onChanged: (v) => _onDigitChanged(i, v),
                    ),
                  );
                }),
              ),

              const Spacer(),

              // ─── Done button ─────────────────────────
              AppButton(
                label: "Done",
                isLoading: _isLoading,
                onPressed: (!_isComplete || _isLoading) ? null : _done,
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
