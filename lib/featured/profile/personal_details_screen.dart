import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';

class PersonalDetailsScreen extends ConsumerStatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  ConsumerState<PersonalDetailsScreen> createState() =>
      _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends ConsumerState<PersonalDetailsScreen> {
  final _nameController = TextEditingController(text: 'Mr. Raju');
  final _phoneController = TextEditingController(text: '+880 1840-560614');
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: AppText('Profile updated successfully')),
    );
  }

  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => _DeleteDialog(
        title: 'Are you sure you want to delete ?',
        onYes: () {
          context.pop();
          context.pop(); // go back
        },
        onNo: () => context.pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: "Personal details"),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar with camera
            Center(
              child: Stack(
                children: [
                  AppAvatar(name: _nameController.text, customSize: 88),
                  Positioned(
                    bottom: 0,
                    right: 0,
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
                ],
              ),
            ),
            28.verticalSpace,

            // Name
            AppTextField(hint: "Full name"),
            12.verticalSpace,
            if (ref.watch(appRoleProvider) == AppRole.provider) ...[
              // About me
              AppTextField(hint: "About me", maxLines: 3),
              12.verticalSpace,
              // Address
              AppTextField(hint: "Address"),
              12.verticalSpace,
            ],

            // Phone
            AppTextField(hint: "Phone number"),
            80.verticalSpace,

            AppButton.primary(
              label: 'Save',
              isLoading: _isSaving,
              onPressed: _isSaving ? null : _save,
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

// ─── Reusable Delete Confirm Dialog ───────────────────────────
class _DeleteDialog extends StatelessWidget {
  final String title;
  final VoidCallback onYes;
  final VoidCallback onNo;
  const _DeleteDialog({
    required this.title,
    required this.onYes,
    required this.onNo,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.h3(title, textAlign: TextAlign.center),
            24.verticalSpace,
            AppButton.primary(label: 'YES, DELETE', onPressed: onYes),
            10.verticalSpace,
            AppButton.outline(label: "NO, DON'T DELETE", onPressed: onNo),
          ],
        ),
      ),
    );
  }
}
