import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/config/app_constants.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/utils/validators.dart';
import 'package:service_provider_umi/featured/authentication/riverpod/auth_provider.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_link_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
part 'widgets/_show_privacy_policy_bottom_sheet.dart';
part 'widgets/_show_role_selection_dialog.dart';
part 'widgets/_showAuthBottomSheet.dart';
part 'widgets/_show_create_account_dialog.dart';
part 'widgets/_show_login_account_dialog.dart';
part 'widgets/_show_otp_verify_screen.dart';
part 'widgets/_show_forgot_password_dialog.dart';
part 'widgets/_show_reset_password_soalog.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: 24.paddingH,
          child: Center(
            child: Column(
              children: [
                Spacer(flex: 3),
                Image.asset('assets/logo.png', height: 60),

                30.verticalSpace,

                Image.asset('assets/doctor.png', height: 200),
                Spacer(flex: 8),
              ],
            ),
          ),
        ),
      ),

      bottomSheet: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            30.verticalSpace,
            AppButton.primary(
              label: "Create Account",
              onPressed: () {
                _showRoleSelectionDialog(ref);
              },
            ),

            12.verticalSpace,

            AppButton.secondary(
              label: "Log in",
              onPressed: () {
                _showAuthBottomSheet(ref, isLogin: true);
              },
            ),

            16.verticalSpace,

            InkWell(
              onTap: () {
                log(ref.watch(appRoleProvider).name);
                context.go(AppRoutes.guestOnboarding);
              },
              child: const AppText.bodySm(
                "Continue as a guest",
                color: AppColors.textSecondary,
              ),
            ),

            30.verticalSpace,
          ],
        ),
      ),
    );
  }
}
