import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/featured/authentication/welcome_screen.dart';
import 'package:service_provider_umi/featured/authentication/widgets/showLoginAccountDialog.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_link_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';

void showCreateAccountDialog(WidgetRef ref) {
  showDialog(
    context: ref.context,
    builder: (_) {
      return Dialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppText.h2("Create account"),
                  InkWell(
                    onTap: () {
                      ref.context.pop();
                    },
                    child: Icon(Icons.close),
                  ),
                ],
              ),

              24.verticalSpace,

              AppTextField(hint: "Enter your name"),

              16.verticalSpace,

              AppTextField(hint: "Enter email"),

              16.verticalSpace,

              AppTextField(
                hint: "Password",
                obscureText: true,
                showPasswordToggle: true,
              ),

              24.verticalSpace,
              AppButton.primary(
                label: "Create Account",
                onPressed: () {
                  ref.context.pop();
                  showPrivacyPolicyBottomSheet(ref.context);
                },
              ),

              10.verticalSpace,
              AppLinkText(
                "Do you have an account?  Log in",
                textColor: AppColors.textPrimary,
                links: [
                  AppTextLink(
                    label: "Log in",
                    onTap: () {
                      ref.context.pop();
                      showLoginAccountDialog(ref);
                    },
                  ),
                ],
              ),
              16.verticalSpace,
              AppLinkText(
                "By creating an account, I accept the Terms and Condition and confirm that I have read the Privacy Policy",
                textSize: 12,
                links: [
                  AppTextLink(
                    label: "Terms and Condition",
                    onTap: () {
                      print("Open Terms");
                    },
                  ),
                  AppTextLink(label: "Privacy Policy", onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
