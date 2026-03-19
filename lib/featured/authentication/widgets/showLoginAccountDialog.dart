import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/featured/RootScreen.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';

void showLoginAccountDialog(WidgetRef ref) {
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
                  const AppText.h2("Login"),
                  InkWell(
                    onTap: () {
                      ref.context.pop();
                    },
                    child: Icon(Icons.close),
                  ),
                ],
              ),

              24.verticalSpace,

              AppTextField(hint: "Enter email"),

              16.verticalSpace,

              AppTextField(
                hint: "Password",
                obscureText: true,
                showPasswordToggle: true,
              ),

              24.verticalSpace,

              AppButton.primary(
                label: "Log in",
                onPressed: () {
                  ref.read(appRoleProvider.notifier).loginAsUser();
                  Navigator.pushAndRemoveUntil(
                    ref.context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RootScreen();
                      },
                    ),
                    (route) => false,
                  );
                },
              ),

              16.verticalSpace,
            ],
          ),
        ),
      );
    },
  );
}
