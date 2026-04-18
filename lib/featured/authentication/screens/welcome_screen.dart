import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/config/app_constants.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
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

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // LOGO
  late Animation<double> _logoMoveUp;
  late Animation<double> _logoScale;

  // IMAGE
  late Animation<double> _imageFade;
  late Animation<double> _imageMoveUp;

  // BOTTOM SHEET
  late Animation<double> _bottomSheetFade;
  late Animation<Offset> _bottomSheetSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // LOGO: center → top
    _logoMoveUp = Tween<double>(
      begin: 0,
      end: -300,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _logoScale = Tween<double>(
      begin: 2.0,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // IMAGE: fade + rise
    _imageFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );

    _imageMoveUp = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    // BOTTOM SHEET: fade + slide
    _bottomSheetFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );

    _bottomSheetSlide = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Stack(
          children: [
            // ================= IMAGE =================
            Center(
              child: FadeTransition(
                opacity: _imageFade,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Center(
                      child: FadeTransition(
                        opacity: _imageFade,
                        child: Transform.translate(
                          offset: Offset(0, _imageMoveUp.value),
                          child: Padding(
                            padding: 80.paddingBottom,
                            child: child,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Image.asset('assets/doctor.png', height: 300),
                ),
              ),
            ),

            // ================= LOGO =================
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Center(
                  child: Transform.translate(
                    offset: Offset(0, _logoMoveUp.value),
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: Image.asset('assets/logo.png', height: 180),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // ================= BOTTOM SHEET =================
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: AppColors.background, // glass effect
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: FadeTransition(
          opacity: _bottomSheetFade,

          child: SlideTransition(
            position: _bottomSheetSlide,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white, // glass effect
                borderRadius: const BorderRadius.only(
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
                      context.go(AppRoutes.guestOnboarding);
                    },
                    child: const AppText.bodyMd(
                      "Continue as a guest",
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  30.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
