import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/featured/authentication/widgets/showCreateAccountDialog.dart';
import 'package:service_provider_umi/featured/authentication/widgets/showLoginAccountDialog.dart';
import 'package:service_provider_umi/featured/guest/guest_onboarding.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_link_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
part 'widgets/show_privacy_policy_bottom_sheet.dart';
part 'widgets/_show_role_selection_dialog.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                showLoginAccountDialog(ref);
              },
            ),

            16.verticalSpace,

            InkWell(
              onTap: () {
                log(ref.watch(appRoleProvider).name);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return GuestOnboardingScreen();
                    },
                  ),
                );
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
