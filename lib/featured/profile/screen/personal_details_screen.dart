import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:service_provider_umi/core/config/app_config.dart';
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

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'package:service_provider_umi/l10n/app_localizations.dart';

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
  LocationModel? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name;
    _phoneController.text = widget.user.phoneNumber ?? "";
    _bioController.text = widget.user.bio ?? "";
    _addressController.text = widget.user.locaation?.address ?? "";
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _buildAddressModelFromLatLng(
    String address,
    double lat,
    double lng,
  ) async {
    setState(() {
      _selectedAddress = LocationModel(
        type: 'Points',
        address: address,
        coordinates: [lng, lat],
      );
    });
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
            address: _selectedAddress,
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
        title: AppLocalizations.of(context)!.areYouSureToDeleteAccount,
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
          context.showSnackBar(AppLocalizations.of(context)!.profileUpdatedSuccessfully);
          ref.read(myProfileProvider.notifier).fetch();
          if (context.mounted) {
            context.pop();
          }
        },
        failure: (failure) {
          context.showSnackBar(AppLocalizations.of(context)!.failedToUpdateProfile(failure.message ?? 'Unknown error'));
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
          context.showSnackBar(AppLocalizations.of(context)!.failedToDeleteAccount(failure.message ?? 'Unknown error'));
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: AppLocalizations.of(context)!.personalDetails),
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

            AppTextField(hint: AppLocalizations.of(context)!.fullName, controller: _nameController),
            12.verticalSpace,

            if (ref.watch(appRoleProvider) == AppRole.provider) ...[
              AppTextField(
                hint: AppLocalizations.of(context)!.aboutMe,
                maxLines: 3,
                controller: _bioController,
              ),
              12.verticalSpace,

              RawAutocomplete<Map<String, dynamic>>(
                textEditingController: _addressController,
                focusNode: FocusNode(),
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<Map<String, dynamic>>.empty();
                  }
                  try {
                    final response = await Dio().get(
                      'https://nominatim.openstreetmap.org/search',
                      queryParameters: {
                        'q': textEditingValue.text,
                        'format': 'json',
                        'addressdetails': 1,
                        'limit': 5,
                        'accept-language': 'en',
                      },
                      options: Options(
                        headers: {
                          'User-Agent': 'ServiceProviderUmi/1.0',
                        },
                      ),
                    );
                    if (response.statusCode == 200) {
                      final List data = response.data;
                      return data.cast<Map<String, dynamic>>();
                    } else {
                      debugPrint('Nominatim API error: ${response.statusCode} - ${response.data}');
                    }
                  } catch (e) {
                    debugPrint('Nominatim API exception: $e');
                  }
                  return const Iterable<Map<String, dynamic>>.empty();
                },
                displayStringForOption: (option) => option['display_name'] ?? '',
                onSelected: (selection) {
                  final lat = double.tryParse(selection['lat'].toString()) ?? 0.0;
                  final lon = double.tryParse(selection['lon'].toString()) ?? 0.0;
                  final address = selection['display_name'] ?? '';
                  _addressController.text = address;
                  _buildAddressModelFromLatLng(address, lat, lon);
                },
                fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    onEditingComplete: onEditingComplete,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchYourAddress,
                      hintStyle: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.grey400,
                        size: 20,
                      ),
                      suffixIcon: ValueListenableBuilder(
                        valueListenable: controller,
                        builder: (_, v, __) => v.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close, size: 18),
                                color: AppColors.grey400,
                                onPressed: () {
                                  controller.clear();
                                },
                              )
                            : const SizedBox.shrink(),
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.white,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 250,
                          maxWidth: MediaQuery.of(context).size.width - 40,
                        ),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              title: Text(
                                option['display_name'] ?? '',
                                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                              ),
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),

              12.verticalSpace,
            ],

            AppTextField(hint: AppLocalizations.of(context)!.phoneNumber, controller: _phoneController),
            80.verticalSpace,

            // ✅ isLoading drives the button — no _isSaving bool anywhere
            AppButton.primary(
              label: AppLocalizations.of(context)!.save,
              isLoading: isLoading,
              onPressed: isLoading ? null : _save,
            ),
            40.verticalSpace,

            GestureDetector(
              onTap: _confirmDeleteAccount,
              child: AppText.bodyMd(
                AppLocalizations.of(context)!.deleteAccountPermanently,
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
              label: AppLocalizations.of(context)!.yesDelete,
              onPressed: onYes,
              isLoading: isDeleting,
            ),
            10.verticalSpace,
            AppButton.outline(label: AppLocalizations.of(context)!.noDontDelete, onPressed: onNo),
          ],
        ),
      ),
    );
  }
}
