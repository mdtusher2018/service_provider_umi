import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/data/models/user_models.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'package:service_provider_umi/featured/profile/riverpod/user_provider.dart';

class PersonalDetailsScreen extends ConsumerStatefulWidget {
  const PersonalDetailsScreen({super.key, required this.user});
  final UserProfile user;

  @override
  ConsumerState<PersonalDetailsScreen> createState() =>
      _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends ConsumerState<PersonalDetailsScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  final _addressController = TextEditingController();

  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _phoneController.text = widget.user.phoneNumber ?? "";
    _bioController.text = widget.user.bio ?? "";
    _addressController.text = widget.user.address ?? "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _pickedImage = File(picked.path));
  }

  Future<void> _save() async {
    await ref
        .read(updateProfileProvider.notifier)
        .update(
          UpdateProfileRequest(
            name: _nameController.text,
            phoneNumber: _phoneController.text,
            bio: _bioController.text,
            address: _addressController.text,
            profileImage: _pickedImage,
          ),
        );
  }

  void _confirmDeleteAccount() {
    showGeneralDialog(
      context: context,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      barrierColor: Colors.black.withOpacity(0.4),
      pageBuilder: (_, _, _) => _DeleteDialog(
        title: 'Are you sure you want to delete ?',
        onYes: () async {
          await ref.read(deleteAccountProvider.notifier).deleteAccount();
        },
        onNo: () => context.pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Derive loading state directly from provider — no separate bool needed
    final updateState = ref.watch(updateProfileProvider);
    final isLoading = updateState is UserStateLoading;

    // ✅ ref.listen fires once per state transition — correct place for
    // side effects like snackbars. Never call showSnackBar inside build directly.
    ref.listen<UserState>(updateProfileProvider, (previous, next) {
      next.when(
        initial: () {},
        loading: () {},
        success: (_) {
          context.showSnackBar('Profile updated successfully');
        },
        failure: (failure) {
          context.showSnackBar('Failed to update profile: ${failure.message}');
        },
      );
    });
    ref.listen<ActionState>(deleteAccountProvider, (previous, next) {
      next.when(
        initial: () {},
        loading: () {},
        success: () {
          context.go(AppRoutes.login);
        },
        failure: (failure) {
          context.showSnackBar('Failed to delete account: ${failure.message}');
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: "Personal details"),
      body: SingleChildScrollView(
        padding: 20.paddingAll,
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  AppAvatar(
                    name: _nameController.text,
                    imageUrl:
                        _pickedImage?.path ?? widget.user.profileImage ?? "",
                    customSize: 88,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: AppColors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            28.verticalSpace,

            AppTextField(hint: "Full name", controller: _nameController),
            12.verticalSpace,

            if (ref.watch(appRoleProvider) == AppRole.provider) ...[
              AppTextField(
                hint: "About me",
                maxLines: 3,
                controller: _bioController,
              ),
              12.verticalSpace,
              AppTextField(hint: "Address", controller: _addressController),
              12.verticalSpace,
            ],

            AppTextField(hint: "Phone number", controller: _phoneController),
            80.verticalSpace,

            // ✅ isLoading drives the button — no _isSaving bool anywhere
            AppButton.primary(
              label: 'Save',
              isLoading: isLoading,
              onPressed: isLoading ? null : _save,
            ),
            40.verticalSpace,

            GestureDetector(
              onTap: _confirmDeleteAccount,
              child: const AppText.bodyMd(
                'Delete account permanently',
                color: AppColors.textSecondary,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Delete Dialog ───────────────────────────
class _DeleteDialog extends ConsumerWidget {
  final String title;
  final VoidCallback onYes;
  final VoidCallback onNo;

  const _DeleteDialog({
    required this.title,
    required this.onYes,
    required this.onNo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteState = ref.watch(deleteAccountProvider);
    final isDeleting = deleteState is ActionStateLoading;
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: 20.circular),
      insetPadding: 32.paddingH,
      child: Padding(
        padding: 24.paddingAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.h3(title, textAlign: TextAlign.center),
            24.verticalSpace,
            AppButton.primary(
              label: 'YES, DELETE',
              onPressed: onYes,
              isLoading: isDeleting,
            ),
            10.verticalSpace,
            AppButton.outline(label: "NO, DON'T DELETE", onPressed: onNo),
          ],
        ),
      ),
    );
  }
}
