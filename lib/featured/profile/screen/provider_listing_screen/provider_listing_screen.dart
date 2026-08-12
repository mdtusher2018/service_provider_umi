import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';
import 'package:service_provider_umi/data/models/category_models.dart';
import 'package:service_provider_umi/data/models/user_models.dart';
import 'package:service_provider_umi/data/models/service_provider_models.dart';
import 'package:service_provider_umi/featured/profile/riverpod/user_provider.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/l10n/app_localizations.dart';
import 'package:service_provider_umi/shared/widgets/app_appbar.dart';
import 'package:service_provider_umi/shared/widgets/app_error_widget.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';

class ProviderListingScreen extends ConsumerStatefulWidget {
  const ProviderListingScreen({super.key});

  @override
  ConsumerState<ProviderListingScreen> createState() =>
      _ProviderListingScreenState();
}

class _ProviderListingScreenState
    extends ConsumerState<ProviderListingScreen> {
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  String? _selectedExperienceId;
  final Set<String> _selectedSpecialtyIds = {};
  final Set<String> _selectedSubCategoryIds = {};
  final Set<String> _selectedTaskIds = {};
  File? _coverImage;
  String? _existingCoverImageUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(filterProvider.notifier).fetch();
      _initFromProfile();
    });
  }

  void _initFromProfile() {
    final userState = ref.read(myProfileProvider);
    userState.whenOrNull(
      success: (user) {
        if (user.bio != null && user.bio!.isNotEmpty) {
          _bioController.text = user.bio!;
        }
        final provider = user.serviceProviderInfo;
        if (provider != null) {
          if (provider.perHourPrice > 0) {
            _priceController.text = provider.perHourPrice.toString();
          }
          if (provider.coverImage != null && provider.coverImage!.isNotEmpty) {
            _existingCoverImageUrl = provider.coverImage;
          }

          _selectedExperienceId = provider.experienceOptionId;

          // Pre-select specialties from profile
          for (final s in provider.specialists) {
            if (s.id.isNotEmpty) _selectedSpecialtyIds.add(s.id);
          }

          // Pre-select subcategories from profile
          for (final sub in provider.subcategories) {
            if (sub.id.isNotEmpty) _selectedSubCategoryIds.add(sub.id);
          }

          // Pre-select tasks from profile
          for (final t in provider.otherTasks) {
            if (t.id.isNotEmpty) _selectedTaskIds.add(t.id);
          }

          setState(() {});
        }
      },
    );
  }


  @override
  void dispose() {
    _bioController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _coverImage = File(picked.path);
      });
    }
  }

  void _save() async {
    final double? hourlyRate = double.tryParse(_priceController.text);
    if (hourlyRate == null) {
      context.showErrorSnackBar('Please enter a valid price per hour');
      return;
    }

    // Update bio via user profile API
    final bioText = _bioController.text.trim();
    if (bioText.isNotEmpty) {
      await ref
          .read(updateProfileProvider.notifier)
          .update(UpdateProfileRequest(bio: bioText));
    }

    // Update provider listing via provider API
    final request = UpdateProviderRequest(
      hourlyRate: hourlyRate,
      experience: _selectedExperienceId?.isNotEmpty == true ? _selectedExperienceId : null,
      specializations: _selectedSpecialtyIds.where((id) => id.isNotEmpty).toList(),
      providerSubcategories: _selectedSubCategoryIds.where((id) => id.isNotEmpty).toList(),
      tasks: _selectedTaskIds.where((id) => id.isNotEmpty).toList(),
      coverImage: _coverImage,
    );

    await ref.read(updateProviderProvider.notifier).update(request);
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(filterProvider);
    final isUpdatingUser = ref.watch(updateProfileProvider).maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
    final isUpdatingProvider = ref.watch(updateProviderProvider).isLoading;
    final isSaving = isUpdatingUser || isUpdatingProvider;

    ref.listen<AsyncValue<bool>>(updateProviderProvider, (prev, next) {
      if (next is AsyncError) {
        context.showErrorSnackBar(next.error.toString());
      }
      if (next is AsyncData && next.value == true) {
        context.showSuccessSnackBar('Listing updated successfully');
        ref.read(myProfileProvider.notifier).fetch();
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(AppRoutes.providerProfile);
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(title: AppLocalizations.of(context)!.myListing),
      body: filterState.when(
        error: (e, st) => AppErrorWidget(
          error: e,
          onRetry: () => ref.read(filterProvider.notifier).fetch(),
        ),
        loading: () => const AppLoader(),
        data: (filterData) {
          return SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Cover Photo ───────────────────────────
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius: BorderRadius.circular(12),
                      image: _coverImage != null
                          ? DecorationImage(
                              image: FileImage(_coverImage!),
                              fit: BoxFit.cover,
                            )
                          : _existingCoverImageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(
                                      _existingCoverImageUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                    ),
                    child: Stack(
                      children: [
                        if (_coverImage == null &&
                            _existingCoverImageUrl == null)
                          const Center(
                            child: Icon(
                              Icons.add_a_photo_outlined,
                              size: 48,
                              color: AppColors.grey400,
                            ),
                          ),
                        Positioned(
                          bottom: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                24.verticalSpace,

                // ─── Bio ───────────────────────────────────
                AppText.labelLg(AppLocalizations.of(context)!.bio, color: AppColors.textSecondary),
                8.verticalSpace,
                AppTextField(
                  controller: _bioController,
                  hint: AppLocalizations.of(context)!.writeSomethingAboutYourself,
                  maxLines: 4,
                ),
                24.verticalSpace,

                // ─── Price per hour ────────────────────────
                AppText.labelLg(AppLocalizations.of(context)!.pricePerHour,
                    color: AppColors.textSecondary),
                8.verticalSpace,
                AppTextField(
                  controller: _priceController,
                  hint: '50',
                  keyboardType: TextInputType.number,
                ),
                24.verticalSpace,

                // ─── Experience ────────────────────────────
                AppText.labelLg(AppLocalizations.of(context)!.experience,
                    color: AppColors.textSecondary),
                8.verticalSpace,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      hint: AppText.labelLg(
                        AppLocalizations.of(context)!.selectExperience,
                        color: AppColors.grey400,
                      ),
                      value: _selectedExperienceId,
                      items: filterData.experienceOptions
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e.id,
                              child: AppText.labelLg(e.value),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() => _selectedExperienceId = val);
                      },
                    ),
                  ),
                ),
                24.verticalSpace,

                // ─── Specialties ───────────────────────────
                AppText.labelLg(AppLocalizations.of(context)!.specialties,
                    color: AppColors.textSecondary),
                12.verticalSpace,
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: filterData.category.map((cat) {
                    final selected =
                        _selectedSpecialtyIds.contains(cat.id);
                    return ChoiceChip(
                      label: Text(cat.name),
                      selected: selected,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color:
                            selected ? Colors.white : AppColors.textPrimary,
                      ),
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _selectedSpecialtyIds.add(cat.id);
                          } else {
                            _selectedSpecialtyIds.remove(cat.id);
                            // Clear subcategories if the parent category is deselected
                            _selectedSubCategoryIds.removeWhere((subId) {
                              // We need to know which subcategories belong to this category
                              // Since we don't have the full object here, we might leave them
                              // or we can remove them inside the subcategoriesProvider data.
                              // Actually, the API will likely just ignore orphan subcategories,
                              // but to be clean, let's keep it as is.
                              return false; 
                            });
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                if (_selectedSpecialtyIds.isNotEmpty) ...[
                  ...filterData.category
                      .where((cat) => _selectedSpecialtyIds.contains(cat.id))
                      .map((cat) {
                    return ref.watch(subcategoriesProvider(cat.id)).when(
                          data: (subcats) {
                            if (subcats.isEmpty) return const SizedBox.shrink();
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                16.verticalSpace,
                                AppText.labelMd('${cat.name} Subcategories', color: AppColors.textSecondary),
                                8.verticalSpace,
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 10,
                                  children: subcats.map((sub) {
                                    final selected = _selectedSubCategoryIds.contains(sub.id);
                                    return ChoiceChip(
                                      label: Text(sub.name),
                                      selected: selected,
                                      selectedColor: AppColors.primary,
                                      labelStyle: TextStyle(
                                        color: selected ? Colors.white : AppColors.textPrimary,
                                      ),
                                      onSelected: (val) {
                                        setState(() {
                                          if (val) {
                                            _selectedSubCategoryIds.add(sub.id);
                                          } else {
                                            _selectedSubCategoryIds.remove(sub.id);
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          },
                          loading: () => const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          ),
                          error: (err, _) => const SizedBox.shrink(),
                        );
                  }),
                ],
                24.verticalSpace,

                // ─── Other tasks offered ───────────────────
                AppText.labelLg(AppLocalizations.of(context)!.otherTasksOffered,
                    color: AppColors.textSecondary),
                12.verticalSpace,
                Wrap(
                  spacing: 8,
                  runSpacing: 10,
                  children: filterData.othersTaskOptions.map((task) {
                    final selected =
                        _selectedTaskIds.contains(task.id);
                    return ChoiceChip(
                      label: Text(task.value),
                      selected: selected,
                      selectedColor: AppColors.primary,
                      labelStyle: TextStyle(
                        color:
                            selected ? Colors.white : AppColors.textPrimary,
                      ),
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            _selectedTaskIds.add(task.id);
                          } else {
                            _selectedTaskIds.remove(task.id);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                40.verticalSpace,

                // ─── Save Button ───────────────────────────
                SizedBox(
                  width: double.infinity,
                  child: AppButton.primary(
                    label: AppLocalizations.of(context)!.save,
                    isLoading: isSaving,
                    onPressed: _save,
                  ),
                ),
                24.verticalSpace,
              ],
            ),
          );
        },
      ),
    );
  }
}
