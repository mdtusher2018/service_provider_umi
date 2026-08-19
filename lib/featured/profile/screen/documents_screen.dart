import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/featured/profile/riverpod/user_provider.dart';
import 'package:service_provider_umi/featured/service/riverpod/verification_provider.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_checkbox.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'package:service_provider_umi/l10n/app_localizations.dart';

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  // ─── Toggle state ─────────────────────────────────────────────────────────
  bool _palliativeCare = false;
  bool _drivingLicence = false;
  bool _businessProfile = false;
  bool _qualifiedCarer = false;

  // ─── Image state (picked) ──────────────────────────────────────────────────
  File? _palliativeImage;
  File? _drivingImage;
  File? _businessImage;
  File? _qualifiedImage;

  // ─── Image state (existing URLs) ───────────────────────────────────────────
  String? _existingPalliativeImage;
  String? _existingDrivingImage;
  String? _existingBusinessImage;
  String? _existingQualifiedImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFromProfile();
    });
  }

  void _initFromProfile() {
    final userState = ref.read(myProfileProvider);
    userState.whenOrNull(
      success: (user) {
        final provider = user.serviceProviderInfo;
        if (provider != null) {
          _existingPalliativeImage = provider.palliativeCare;
          _existingDrivingImage = provider.drivingLicense;
          _existingBusinessImage = provider.businessProfiles;
          _existingQualifiedImage = provider.qualifiedCarer;

          _palliativeCare = _existingPalliativeImage != null && _existingPalliativeImage!.isNotEmpty;
          _drivingLicence = _existingDrivingImage != null && _existingDrivingImage!.isNotEmpty;
          _businessProfile = _existingBusinessImage != null && _existingBusinessImage!.isNotEmpty;
          _qualifiedCarer = _existingQualifiedImage != null && _existingQualifiedImage!.isNotEmpty;

          setState(() {});
        }
      },
    );
  }

  Future<void> _pickImage(Function(File) onPicked) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      onPicked(File(picked.path));
      setState(() {});
    }
  }

  bool get _isValid {
    if (_palliativeCare && _palliativeImage == null && (_existingPalliativeImage == null || _existingPalliativeImage!.isEmpty)) return false;
    if (_drivingLicence && _drivingImage == null && (_existingDrivingImage == null || _existingDrivingImage!.isEmpty)) return false;
    if (_businessProfile && _businessImage == null && (_existingBusinessImage == null || _existingBusinessImage!.isEmpty)) return false;
    if (_qualifiedCarer && _qualifiedImage == null && (_existingQualifiedImage == null || _existingQualifiedImage!.isEmpty)) return false;
    return true;
  }

  void _onUpdate() {
    if (!_palliativeCare && !_drivingLicence && !_businessProfile && !_qualifiedCarer) {
      context.showErrorSnackBar('Please select at least one document to proceed.');
      return;
    }

    if (!_isValid) {
      context.showErrorSnackBar(
        AppLocalizations.of(context)!.pleaseUploadAnImage,
      );
      return;
    }

    final request = VerificationRequest(
      palliativeCare: _palliativeCare ? _palliativeImage : null,
      drivingLicense: _drivingLicence ? _drivingImage : null,
      businessProfilesOnly: _businessProfile ? _businessImage : null,
      qualifiedOnly: _qualifiedCarer ? _qualifiedImage : null,
    );

    ref.read(verificationProvider.notifier).create(request);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(verificationProvider, (previous, next) {
      if (next is AsyncError) {
        context.showErrorSnackBar(next.error.toString());
      } else if (next is AsyncData && next.value == true) {
        context.showSuccessSnackBar('Documents updated successfully');
        ref.read(myProfileProvider.notifier).fetch();
        if (context.canPop()) {
          context.pop();
        }
      }
    });

    final verificationState = ref.watch(verificationProvider);
    final isUpdating = verificationState is AsyncLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: 'Documents'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppToggleTile(
                label: AppLocalizations.of(context)!.palliativeCare,
                subtitle: AppLocalizations.of(context)!.palliativeCareDesc,
                value: _palliativeCare,
                onChanged: (v) => setState(() {
                  _palliativeCare = v;
                  if (!v) {
                    _palliativeImage = null;
                    _existingPalliativeImage = null;
                  }
                }),
              ),
              if (_palliativeCare) ...[
                16.verticalSpace,
                _buildImageTile(
                  title: AppLocalizations.of(context)!.palliativeCareImage,
                  imageFile: _palliativeImage,
                  existingUrl: _existingPalliativeImage,
                  onTap: () => _pickImage((f) => _palliativeImage = f),
                ),
              ],
              const AppDivider(height: 40, color: AppColors.grey400),
              AppToggleTile(
                label: AppLocalizations.of(context)!.drivingLicence,
                subtitle: AppLocalizations.of(context)!.drivingLicenceDesc,
                value: _drivingLicence,
                onChanged: (v) => setState(() {
                  _drivingLicence = v;
                  if (!v) {
                    _drivingImage = null;
                    _existingDrivingImage = null;
                  }
                }),
              ),
              if (_drivingLicence) ...[
                16.verticalSpace,
                _buildImageTile(
                  title: AppLocalizations.of(context)!.drivingLicenceImage,
                  imageFile: _drivingImage,
                  existingUrl: _existingDrivingImage,
                  onTap: () => _pickImage((f) => _drivingImage = f),
                ),
              ],
              const AppDivider(height: 40, color: AppColors.grey400),
              AppToggleTile(
                label: AppLocalizations.of(context)!.businessProfiles,
                subtitle: AppLocalizations.of(context)!.businessProfilesDesc,
                value: _businessProfile,
                onChanged: (v) => setState(() {
                  _businessProfile = v;
                  if (!v) {
                    _businessImage = null;
                    _existingBusinessImage = null;
                  }
                }),
              ),
              if (_businessProfile) ...[
                16.verticalSpace,
                _buildImageTile(
                  title: AppLocalizations.of(context)!.businessProfileImage,
                  imageFile: _businessImage,
                  existingUrl: _existingBusinessImage,
                  onTap: () => _pickImage((f) => _businessImage = f),
                ),
              ],
              const AppDivider(height: 40, color: AppColors.grey400),
              AppToggleTile(
                label: AppLocalizations.of(context)!.qualifiedCarer,
                subtitle: AppLocalizations.of(context)!.qualifiedCarerDesc,
                value: _qualifiedCarer,
                onChanged: (v) => setState(() {
                  _qualifiedCarer = v;
                  if (!v) {
                    _qualifiedImage = null;
                    _existingQualifiedImage = null;
                  }
                }),
              ),
              if (_qualifiedCarer) ...[
                16.verticalSpace,
                _buildImageTile(
                  title: AppLocalizations.of(context)!.qualificationCertificate,
                  imageFile: _qualifiedImage,
                  existingUrl: _existingQualifiedImage,
                  onTap: () => _pickImage((f) => _qualifiedImage = f),
                ),
              ],
              32.verticalSpace,

              SizedBox(
                width: double.infinity,
                child: AppButton.primary(
                  label: AppLocalizations.of(context)!.update,
                  isLoading: isUpdating,
                  onPressed: _onUpdate,
                ),
              ),
              32.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageTile({
    required String title,
    required File? imageFile,
    required String? existingUrl,
    required VoidCallback onTap,
  }) {
    final hasImage = imageFile != null || (existingUrl != null && existingUrl.isNotEmpty);

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
              image: hasImage
                  ? DecorationImage(
                      image: imageFile != null
                          ? FileImage(imageFile) as ImageProvider
                          : NetworkImage(existingUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: !hasImage ? const Icon(Icons.add_a_photo, color: AppColors.grey400) : null,
          ),
        ),
        16.verticalSpace,
      ],
    );
  }
}
