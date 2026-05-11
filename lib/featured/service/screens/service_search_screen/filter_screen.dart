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
import 'package:service_provider_umi/data/models/mock_service_provider_models.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';
import 'package:service_provider_umi/data/models/service_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_checkbox.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_slider.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

class FilterScreen extends ConsumerStatefulWidget {
  const FilterScreen({super.key});

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  // ─── State ───────────────────────────────────────────────
  bool _palliativeCare = false;
  bool _drivingLicence = false;
  bool _businessProfile = false;
  bool _qualifiedCarer = false;
  RangeValues _priceRange = const RangeValues(0, 50);
  double _hourlyPrice = 50;

  final Set<FilterOptionModel> _selectedTasks = {};
  ServiceModel? _selectedCategory;
  FilterOptionModel? _selectedExperiences;

  // ─── Image States ─────────────────────────
  File? _coverImage;
  File? _palliativeImage;
  File? _drivingImage;
  File? _businessImage;
  File? _qualifiedImage;

  void _clearAll() {
    setState(() {
      _palliativeCare = false;
      _drivingLicence = false;
      _businessProfile = false;
      _qualifiedCarer = false;
      _priceRange = const RangeValues(0, 50);
      _selectedTasks.clear();
      _selectedCategory = null;
      _selectedExperiences = null;

      _coverImage = null;
      _palliativeImage = null;
      _drivingImage = null;
      _businessImage = null;
      _qualifiedImage = null;
    });
  }

  /// ─── Image Picker ───────────────────────
  Future<void> _pickImage(Function(File) onPicked) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked != null) {
      onPicked(File(picked.path));
      setState(() {});
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(filterProvider.notifier).fetch();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filterProvider);
    ref.listen<AsyncValue<bool>>(updateProviderProvider, (prev, next) {
      if (next is AsyncError) {
        context.showErrorSnackBar(next.error.toString());
      }
      if (next is AsyncData && next.value == true) {
        // optionally show success
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  if (!kIsWeb)
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios_rounded,
                            color: AppColors.primaryFor(
                              ref.watch(appRoleProvider),
                            ),
                            size: 18,
                          ),
                          8.horizontalSpace,
                          AppText.h1(
                            'Back',
                            color: AppColors.primaryFor(
                              ref.watch(appRoleProvider),
                            ),
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _clearAll,
                    child: AppText.labelLg(
                      'Clear filters',
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: state.when(
                error: (error, stackTrace) {
                  return ListView(
                    children: [AppEmptyState(title: error.toString())],
                  );
                },
                loading: () => AppLoader(),
                data: (data) {
                  final experiences = data.experienceOptions;
                  final tasks = data.othersTaskOptions;
                  final category = data.category;
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppToggleTile(
                          label: 'Palliative care',
                          subtitle:
                              'Only show professionals specialising in palliative care.',
                          value: _palliativeCare,
                          onChanged: (v) => setState(() => _palliativeCare = v),
                        ),

                        const AppDivider(height: 40, color: AppColors.grey400),
                        // ─── Price slider ────────────────────
                        (ref.read(appRoleProvider) == AppRole.provider)
                            ? AppPriceSlider(
                                value: _hourlyPrice,
                                min: 0,
                                max: 100,
                                onChanged: (v) =>
                                    setState(() => _hourlyPrice = v),
                              )
                            : AppPriceRangeSlider(
                                values: _priceRange,
                                min: 0,
                                max: 100,
                                onChanged: (v) =>
                                    setState(() => _priceRange = v),
                              ),

                        const AppDivider(height: 40, color: AppColors.grey400),

                        // ─── Experience ──────────────────────
                        AppText.h3("Professional's experience"),
                        12.verticalSpace,
                        ...experiences.asMap().entries.map(
                          (e) => AppCheckboxTile(
                            label: e.value.value,
                            value: _selectedExperiences == e.value,
                            onChanged: (_) => setState(() {
                              _selectedExperiences = e.value;
                            }),
                          ),
                        ),
                        const AppDivider(height: 40, color: AppColors.grey400),

                        // ─── Other tasks ─────────────────────
                        AppText.h3('Other required tasks'),
                        12.verticalSpace,
                        ...tasks.map(
                          (t) => AppCheckboxTile(
                            label: t.value,
                            value: _selectedTasks.contains(t),
                            onChanged: (_) => setState(() {
                              _selectedTasks.contains(t)
                                  ? _selectedTasks.remove(t)
                                  : _selectedTasks.add(t);
                            }),
                          ),
                        ),
                        const AppDivider(height: 40, color: AppColors.grey400),

                        // ─── Specialists in ──────────────────
                        AppText.h3('Show specialists in:'),
                        12.verticalSpace,
                        ...category.map(
                          (c) => AppCheckboxTile(
                            label: c.name,
                            value: _selectedCategory == c,
                            onChanged: (_) => setState(() {
                              _selectedCategory = c;
                            }),
                          ),
                        ),
                        const AppDivider(height: 40, color: AppColors.grey400),

                        // ─── Toggles ─────────────────────────
                        AppToggleTile(
                          label: 'Driving licence',
                          subtitle:
                              'Only show professionals with a driving licence',
                          value: _drivingLicence,
                          onChanged: (v) => setState(() => _drivingLicence = v),
                        ),
                        const AppDivider(height: 40, color: AppColors.grey400),
                        AppToggleTile(
                          label: 'Business profiles',
                          subtitle:
                              'Only profiles that correspond to a validated business or self employed professional.',
                          value: _businessProfile,
                          onChanged: (v) =>
                              setState(() => _businessProfile = v),
                        ),
                        const AppDivider(height: 40, color: AppColors.grey400),
                        AppToggleTile(
                          label: 'Qualified carer',
                          subtitle:
                              'Only show caregivers with a qualification, diploma or degree as health personal',
                          value: _qualifiedCarer,
                          onChanged: (v) => setState(() => _qualifiedCarer = v),
                        ),
                        32.verticalSpace,

                        if (ref.watch(appRoleProvider) == AppRole.provider) ...[
                          AppText.h4("Images"),
                          12.verticalSpace,

                          /// Cover Image (Always)
                          _buildImageTile(
                            title: "Cover Image",
                            imageFile: _coverImage,
                            onTap: () => _pickImage((f) => _coverImage = f),
                          ),

                          /// Conditional Images
                          if (_palliativeCare)
                            _buildImageTile(
                              title: "Palliative Care Image",
                              imageFile: _palliativeImage,
                              onTap: () =>
                                  _pickImage((f) => _palliativeImage = f),
                            ),

                          if (_drivingLicence)
                            _buildImageTile(
                              title: "Driving Licence Image",
                              imageFile: _drivingImage,
                              onTap: () => _pickImage((f) => _drivingImage = f),
                            ),

                          if (_businessProfile)
                            _buildImageTile(
                              title: "Business Profile Image",
                              imageFile: _businessImage,
                              onTap: () =>
                                  _pickImage((f) => _businessImage = f),
                            ),

                          if (_qualifiedCarer)
                            _buildImageTile(
                              title: "Qualification Certificate",
                              imageFile: _qualifiedImage,
                              onTap: () =>
                                  _pickImage((f) => _qualifiedImage = f),
                            ),
                        ],
                        // ─── Apply button ────────────────────
                        AppButton.primary(
                          label: 'Update',
                          isLoading: ref
                              .watch(updateProviderProvider)
                              .isLoading,

                          onPressed: () async {
                            if (ref.watch(appRoleProvider) ==
                                AppRole.provider) {
                              if (kIsWeb) {
                                context.go(AppRoutes.profilePicture);
                              } else {
                                final notifier = ref.read(
                                  updateProviderProvider.notifier,
                                );

                                final success = await notifier.update(
                                  UpdateProviderRequest(
                                    hourlyRate: _hourlyPrice,
                                    businessProfilesOnly: _businessImage,
                                    drivingLicense: _drivingImage,
                                    experience: _selectedExperiences?.id,

                                    palliativeCare: _palliativeImage,
                                    qualifiedOnly: _qualifiedImage,
                                    specializations: [
                                      _selectedCategory?.id ?? "",
                                    ],
                                    tasks: _selectedTasks
                                        .map((e) => e.id)
                                        .toList(),
                                  ),
                                );

                                if (!context.mounted) return;

                                if (success) {
                                  context.push(AppRoutes.profilePicture);
                                }
                              }

                              return;
                            }

                            if (kIsWeb) {
                              context.go(AppRoutes.searchResults);
                            } else {
                              context.go(AppRoutes.searchResults);
                              context.pop({
                                'palliativeCare': _palliativeCare,
                                'drivingLicence': _drivingLicence,
                                'qualifiedCarer': _qualifiedCarer,
                                'businessProfile': _businessProfile,
                                'priceMin': _priceRange.start,
                                'priceMax': _priceRange.end,
                                'tasks': _selectedTasks.toList(),
                                'conditions': [_selectedCategory],
                                'experiences': [_selectedExperiences],
                              });
                            }
                          },
                        ),
                        32.verticalSpace,
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ─── Reusable Image Tile ───────────────
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
