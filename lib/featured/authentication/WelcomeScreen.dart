import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/featured/RootScreen.dart';
import 'package:service_provider_umi/featured/guest/guest_onboarding.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_link_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

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

                const SizedBox(height: 30),

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
            const SizedBox(height: 30),
            AppButton.primary(
              label: "Create Account",
              onPressed: () {
                showRoleSelectionDialog(context);
              },
            ),

            const SizedBox(height: 12),

            AppButton.secondary(
              label: "Log in",
              onPressed: () {
                showLoginAccountDialog(context);
              },
            ),

            const SizedBox(height: 16),

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

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(String title, String subtitle, String image) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(image, width: 60, height: 60),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.bodyLg(
                  title,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
                AppText.bodyMd(subtitle),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showRoleSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: AlignmentGeometry.topLeft,
                  child: InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: Icon(Icons.arrow_back),
                  ),
                ),
                const AppText.h2(
                  "What will you do on iumi?",
                  color: AppColors.textSecondary,
                ),

                const SizedBox(height: 10),

                const AppText.bodySm(
                  "This decision is not final. You can later be both a client\nand a professional from the account if you wish.",
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                InkWell(
                  onTap: () {
                    context.pop();
                    showAuthBottomSheet(context);
                  },
                  child: _categoryCard(
                    "Book a service",
                    "I am a Client",
                    "assets/book_service.png",
                  ),
                ),

                const SizedBox(height: 12),

                _categoryCard(
                  "Offer services",
                  "I am a Professional",
                  "assets/offer_service.png",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAuthBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppText.h2("Log in"),
              const SizedBox(height: 24),
              AppButton(
                label: "Continue with Apple",
                variant: AppButtonVariant.social,
                backgroundColor: AppColors.black,
                textColor: AppColors.white,

                prefixIcon: Icon(Icons.apple, color: AppColors.white),
              ),
              const SizedBox(height: 12),
              AppButton.outline(
                label: "Continue with Facebook",
                backgroundColor: Color(0xFF1877F2),
                textColor: AppColors.white,
                prefixIcon: Icon(Icons.facebook, color: AppColors.white),
              ),
              const SizedBox(height: 12),
              AppButton.outline(
                label: "Continue with Google",
                borderColor: AppColors.black,
                prefixIcon: Icon(Icons.g_mobiledata),
                onPressed: () {},
              ),
              const SizedBox(height: 16),
              Row(
                spacing: 16,
                children: [
                  Expanded(child: AppDivider()),
                  AppText.bodyLg("or"),
                  Expanded(child: AppDivider()),
                ],
              ),

              AppButton.outline(
                label: "Log in with email",
                borderColor: AppColors.black,

                onPressed: () {
                  context.pop();
                  showCreateAccountDialog(context);
                },
              ),
              const SizedBox(height: 16),
              AppLinkText(
                "By creating an account, I accept the Terms and Condition and confirm that I have read the Privacy Policy",

                links: [
                  AppTextLink(
                    label: "Terms and Condition",
                    onTap: () {
                      print("Open Terms");
                    },
                  ),
                  AppTextLink(
                    label: "Privacy Policy",
                    onTap: () {
                      print("Open Privacy Policy");
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void showCreateAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
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
                        context.pop();
                      },
                      child: Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                AppTextField(hint: "Enter your name"),

                const SizedBox(height: 16),

                AppTextField(hint: "Enter email"),

                const SizedBox(height: 16),

                AppTextField(
                  hint: "Password",
                  obscureText: true,
                  showPasswordToggle: true,
                ),

                const SizedBox(height: 24),
                AppButton.primary(
                  label: "Create Account",
                  onPressed: () {
                    context.pop();
                    showPrivacyPolicyBottomSheet(context);
                  },
                ),

                const SizedBox(height: 10),
                AppLinkText(
                  "Do you have an account?  Log in",
                  textColor: AppColors.textPrimary,
                  links: [
                    AppTextLink(
                      label: "Log in",
                      onTap: () {
                        context.pop();
                        showLoginAccountDialog(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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

  void showLoginAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
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
                        context.pop();
                      },
                      child: Icon(Icons.close),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                AppTextField(hint: "Enter email"),

                const SizedBox(height: 16),

                AppTextField(
                  hint: "Password",
                  obscureText: true,
                  showPasswordToggle: true,
                ),

                const SizedBox(height: 24),

                AppButton.primary(
                  label: "Log in",
                  onPressed: () {
                    ref.read(appRoleProvider.notifier).loginAsUser();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return RootScreen();
                        },
                      ),
                      (route) => false,
                    );
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  void showPrivacyPolicyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: const Icon(
                  Icons.privacy_tip,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 16),

              const AppText.h3("We value your privacy"),

              const SizedBox(height: 8),

              const AppText.bodySm(
                "Webel uses cookies to analyse advertising campaign performance, improve app ads, and personalize the experience based on user preference.",
              ),

              const SizedBox(height: 20),

              Container(
                height: 45,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: AppText.labelLg("Accept", color: AppColors.white),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
