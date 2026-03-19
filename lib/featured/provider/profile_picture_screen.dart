import 'dart:io';
import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import '../../../../core/di/app_role_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import 'phone_number_screen.dart';

class ProfilePictureScreen extends ConsumerStatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  ConsumerState<ProfilePictureScreen> createState() =>
      _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends ConsumerState<ProfilePictureScreen> {
  File? _image;
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  Future<void> _pickFromCamera() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            8.verticalSpace,
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            16.verticalSpace,
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),
            8.verticalSpace,
          ],
        ),
      ),
    );
  }

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
                        Text(
                          'This will be the picture that clients will see of you. '
                          'Try to make it as trustworthy as possible.',
                          style: AppTextStyles.bodySm,
                        ),
                        32.verticalSpace,

                        // ─── Avatar picker ──────────────
                        Center(
                          child: GestureDetector(
                            onTap: _showPickerOptions,
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
                              child: _image != null
                                  ? ClipOval(
                                      child: Image.file(
                                        _image!,
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
                    MediaQuery.of(context).padding.bottom + 20,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _image == null
                          ? null
                          : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const PhoneNumberScreen(),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        disabledBackgroundColor: primary.withOpacity(0.4),
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text('Confirm', style: AppTextStyles.buttonLg),
                    ),
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
                Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}

// ─── Tips card ────────────────────────────────────────────────
class _TipsCard extends StatelessWidget {
  final Color primary;
  const _TipsCard({required this.primary});

  @override
  Widget build(BuildContext context) {
    const tips = ['Good lighting', 'Good resolution', 'Visible face', 'Smile'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What makes a good profile picture?',
            style: AppTextStyles.labelLg.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          24.verticalSpace,

          // Example avatars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ExampleAvatar(
                assetOrEmoji: 'assets/service_provider_images/right_image.png',
                isGood: true,
                primary: primary,
              ),
              12.horizontalSpace,
              _ExampleAvatar(
                assetOrEmoji: 'assets/service_provider_images/wrong_image.png',
                isGood: false,
                primary: primary,
              ),
            ],
          ),
          24.verticalSpace,

          // Checklist
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.check_rounded, color: primary, size: 18),
                  8.horizontalSpace,
                  Text(tip, style: AppTextStyles.bodyMd),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleAvatar extends StatelessWidget {
  final String assetOrEmoji;
  final bool isGood;
  final Color primary;

  const _ExampleAvatar({
    required this.assetOrEmoji,
    required this.isGood,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.grey100,
          ),
          child: Center(child: Image.asset(assetOrEmoji)),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isGood ? primary : AppColors.error,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.white, width: 2),
            ),
            child: Icon(
              isGood ? Icons.check_rounded : Icons.close_rounded,
              color: AppColors.white,
              size: 10,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Go Back Dialog ───────────────────────────────────────────
class _GoBackDialog extends StatelessWidget {
  final VoidCallback onStay;
  final VoidCallback onGoBack;
  const _GoBackDialog({required this.onStay, required this.onGoBack});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Do you want to go back?', style: AppTextStyles.h3),
                    GestureDetector(
                      onTap: onStay,
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.grey400,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                8.verticalSpace,
                Text(
                  'If you go back, any information completed in this '
                  'section will be lost',
                  style: AppTextStyles.bodySm,
                ),
                24.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onStay,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.grey300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'Stay',
                          style: AppTextStyles.buttonMd.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onGoBack,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: AppColors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text('Go back', style: AppTextStyles.buttonMd),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
