import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/featured/authentication/riverpod/auth_provider.dart';
import 'package:service_provider_umi/featured/service/riverpod/verification_provider.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_checkbox.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

class ServiceProviderVerification extends ConsumerStatefulWidget {
  const ServiceProviderVerification({super.key});

  @override
  ConsumerState<ServiceProviderVerification> createState() =>
      _ServiceProviderVerificationState();
}

class _ServiceProviderVerificationState
    extends ConsumerState<ServiceProviderVerification> {
  // ─── Toggle state ─────────────────────────────────────────────────────────
  bool _palliativeCare = true;
  bool _drivingLicence = true;
  bool _businessProfile = true;
  bool _qualifiedCarer = true;

  // ─── Image state ──────────────────────────────────────────────────────────
  File? _palliativeImage;
  File? _drivingImage;
  File? _businessImage;
  File? _qualifiedImage;

  Future<void> _pickImage(Function(File) onPicked) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      onPicked(File(picked.path));
      setState(() {});
    }
  }

  // ─── Validation ───────────────────────────────────────────────────────────
  bool get _isValid {
    if (_palliativeCare && _palliativeImage == null) return false;
    if (_drivingLicence && _drivingImage == null) return false;
    if (_businessProfile && _businessImage == null) return false;
    if (_qualifiedCarer && _qualifiedImage == null) return false;
    return true;
  }

  void _submit() async {
    if (!_isValid) {
      context.showErrorSnackBar(
        'Please upload an image for each selected option.',
      );
      return;
    }

    await ref
        .read(verificationProvider.notifier)
        .create(
          VerificationRequest(
            palliativeCare: _palliativeCare ? _palliativeImage : null,
            drivingLicense: _drivingLicence ? _drivingImage : null,
            businessProfilesOnly: _businessProfile ? _businessImage : null,
            qualifiedOnly: _qualifiedCarer ? _qualifiedImage : null,
          ),
        );
  }

  void _showSuccessDialog() {
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: AppText('Verification Submitted'),
          content: AppText(
            'Your request has been submitted successfully.\n\nPlease login again with another account.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(logoutProvider.notifier).logout();
                context.go(AppRoutes.login);
              },
              child: AppText('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // ─── Listen for success / error ───────────────────────────────────────
    ref.listen<AsyncValue<bool?>>(verificationProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) => context.showErrorSnackBar(e.toString()),
        data: (success) {
          if (success == true) {
            _showSuccessDialog();
          }
        },
      );
    });
    final isLoading = ref.watch(verificationProvider).isLoading;
    final role = ref.watch(appRoleProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // if (!kIsWeb)
                  //   GestureDetector(
                  //     onTap: () => context.pop(),
                  //     child: Row(
                  //       children: [
                  //         Icon(
                  //           Icons.arrow_back_ios_rounded,
                  //           color: AppColors.primaryFor(role),
                  //           size: 18,
                  //         ),
                  //         8.horizontalSpace,
                  //         AppText.h1(
                  //           'Back',
                  //           color: AppColors.primaryFor(role),
                  //           fontWeight: FontWeight.w700,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  InkWell(
                    onTap: () {
                      ref.read(logoutProvider.notifier).logout();
                      context.go(AppRoutes.login);
                    },
                    child: Icon(Icons.logout),
                  ),
                ],
              ),
            ),

            // ─── Body ─────────────────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Toggles ──────────────────────────────────────────
                    AppText.h4(
                      "If you already submit a request please login with another account",
                    ),
                    const AppDivider(height: 40, color: AppColors.grey400),
                    AppToggleTile(
                      label: 'Palliative care',
                      subtitle:
                          'Only show professionals specialising in palliative care.',
                      value: _palliativeCare,
                      onChanged: (v) => setState(() {
                        _palliativeCare = v;
                        if (!v) _palliativeImage = null;
                      }),
                    ),
                    const AppDivider(height: 40, color: AppColors.grey400),
                    AppToggleTile(
                      label: 'Driving licence',
                      subtitle:
                          'Only show professionals with a driving licence',
                      value: _drivingLicence,
                      onChanged: (v) => setState(() {
                        _drivingLicence = v;
                        if (!v) _drivingImage = null;
                      }),
                    ),
                    const AppDivider(height: 40, color: AppColors.grey400),
                    AppToggleTile(
                      label: 'Business profiles',
                      subtitle:
                          'Only profiles that correspond to a validated business or self employed professional.',
                      value: _businessProfile,
                      onChanged: (v) => setState(() {
                        _businessProfile = v;
                        if (!v) _businessImage = null;
                      }),
                    ),
                    const AppDivider(height: 40, color: AppColors.grey400),
                    AppToggleTile(
                      label: 'Qualified carer',
                      subtitle:
                          'Only show caregivers with a qualification, diploma or degree as health personal',
                      value: _qualifiedCarer,
                      onChanged: (v) => setState(() {
                        _qualifiedCarer = v;
                        if (!v) _qualifiedImage = null;
                      }),
                    ),
                    32.verticalSpace,

                    // ─── Image pickers (shown only when toggled on) ────────
                    if (_palliativeCare)
                      _buildImageTile(
                        title: 'Palliative Care Image',
                        imageFile: _palliativeImage,
                        onTap: () => _pickImage((f) => _palliativeImage = f),
                      ),
                    if (_drivingLicence)
                      _buildImageTile(
                        title: 'Driving Licence Image',
                        imageFile: _drivingImage,
                        onTap: () => _pickImage((f) => _drivingImage = f),
                      ),
                    if (_businessProfile)
                      _buildImageTile(
                        title: 'Business Profile Image',
                        imageFile: _businessImage,
                        onTap: () => _pickImage((f) => _businessImage = f),
                      ),
                    if (_qualifiedCarer)
                      _buildImageTile(
                        title: 'Qualification Certificate',
                        imageFile: _qualifiedImage,
                        onTap: () => _pickImage((f) => _qualifiedImage = f),
                      ),

                    // ─── Submit ───────────────────────────────────────────
                    AppButton.primary(
                      label: 'Submit',
                      isLoading: isLoading,
                      // Only providers can submit; button disabled for other roles
                      onPressed: role == AppRole.provider && !isLoading
                          ? _submit
                          : null,
                    ),
                    32.verticalSpace,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageTile({
    required String title,
    required File? imageFile,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.labelLg(title),
        8.verticalSpace,
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.grey200,
              image: imageFile != null
                  ? DecorationImage(
                      image: FileImage(imageFile),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: imageFile == null ? const Icon(Icons.add_a_photo) : null,
          ),
        ),
        16.verticalSpace,
      ],
    );
  }
}
