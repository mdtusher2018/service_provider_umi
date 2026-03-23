import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import '../../../../../core/di/app_role_provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
part '_example_avatar.dart';
part '_go_back_dialog.dart';
part '_show_image_picker_pptions.dart';

class ProfilePictureScreen extends ConsumerStatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  ConsumerState<ProfilePictureScreen> createState() =>
      _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends ConsumerState<ProfilePictureScreen> {
  bool _showGoBackDialog = false;

  void _onBackPressed() {
    setState(() => _showGoBackDialog = true);
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(appRoleProvider);
    final primary = AppColors.primaryFor(role);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Back ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: GestureDetector(
                    onTap: _onBackPressed,
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: primary,
                      size: 22,
                    ),
                  ),
                ),
                16.verticalSpace,

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ─── Title ──────────────────────
                        AppText('Profile picture', style: AppTextStyles.h1),
                        6.verticalSpace,
                        AppText.bodySm(
                          'This will be the picture that clients will see of you. '
                          'Try to make it as trustworthy as possible.',
                        ),
                        32.verticalSpace,

                        // ─── Avatar picker ──────────────
                        Consumer(
                          builder: (context, ref, child) {
                            final image = ref.watch(profileImageProvider);
                            return Center(
                              child: GestureDetector(
                                onTap: () => _showPickerOptions(ref),
                                child: Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.white,
                                    border: Border.all(
                                      color: AppColors.grey200,
                                      width: 2,
                                    ),
                                  ),
                                  child: image != null
                                      ? ClipOval(
                                          child: Image.file(
                                            image,
                                            fit: BoxFit.cover,
                                            width: 120,
                                            height: 120,
                                          ),
                                        )
                                      : Icon(
                                          Icons.add_rounded,
                                          color: AppColors.secondary,
                                          size: 36,
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                        28.verticalSpace,

                        // ─── Tips card ──────────────────
                        _TipsCard(primary: primary),
                        32.verticalSpace,
                      ],
                    ),
                  ),
                ),

                // ─── Confirm button ──────────────────
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    20,
                    12,
                    20,
                    context.bottomPadding + 20,
                  ),
                  child: AppButton.primary(
                    label: "Confirm",
                    onPressed: () {
                      context.push(AppRoutes.verifyOtp);
                    },
                  ),
                ),
              ],
            ),
          ),

          // ─── Go back dialog ───────────────────────
          if (_showGoBackDialog)
            _GoBackDialog(
              onStay: () => setState(() => _showGoBackDialog = false),
              onGoBack: () {
                setState(() => _showGoBackDialog = false);
                context.pop();
              },
            ),
        ],
      ),
    );
  }
}
