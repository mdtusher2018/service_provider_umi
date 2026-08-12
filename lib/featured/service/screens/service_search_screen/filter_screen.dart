import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_provider_umi/core/di/repository_providers.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/data/models/service_provider_models.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';
import 'package:service_provider_umi/data/models/category_models.dart';
import 'package:service_provider_umi/featured/authentication/riverpod/auth_provider.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/featured/service/riverpod/verification_provider.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_checkbox.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_slider.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import 'package:service_provider_umi/l10n/app_localizations.dart';

class FilterScreen extends ConsumerStatefulWidget {
  /// The service / search context we're filtering within.
  final String serviceId;

  /// All query params currently active on the SearchResultsScreen.
  /// FilterScreen will keep scheduling params intact and only override
  /// filter params.
  final Map<String, String> existingParams;

  const FilterScreen({
    super.key,
    required this.serviceId,
    required this.existingParams,
  });

  @override
  ConsumerState<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends ConsumerState<FilterScreen> {
  // ─── State ────────────────────────────────────────────────────────────────
  late bool _palliativeCare;
  late bool _drivingLicence;
  late bool _businessProfile;
  late bool _qualifiedCarer;
  late RangeValues _priceRange;
  late double _hourlyPrice;

  final Set<FilterOptionModel> _selectedTasks = {};
  final Set<CategoryModel> _selectedCategories = {};
  final Set<SubCategoryModel> _selectedSubCategories = {};
  FilterOptionModel? _selectedExperiences;

  // ─── Image states (provider only) ────────────────────────────────────────
  File? _coverImage;
  File? _palliativeImage;
  File? _drivingImage;
  File? _businessImage;
  File? _qualifiedImage;
  List<File> _images = [];

  @override
  void initState() {
    super.initState();
    _initFromExistingParams();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(filterProvider.notifier).fetch();
    });
  }

  /// Pre-populate toggles + sliders from the URL params that came from the
  /// previous search screen so the user sees their current filter state.
  void _initFromExistingParams() {
    final p = widget.existingParams;

    _palliativeCare = p['palliativeCare'] == 'true';
    _drivingLicence = p['drivingLicense'] == 'true';
    _businessProfile = p['businessProfiles'] == 'true';
    _qualifiedCarer = p['qualifiedCarer'] == 'true';

    final min = double.tryParse(p['minPrice'] ?? '') ?? 0;
    final max = double.tryParse(p['maxPrice'] ?? '') ?? 50;
    _priceRange = RangeValues(min, max);
    _hourlyPrice = double.tryParse(p['minPrice'] ?? '') ?? 50;
  }

  void _clearAll() {
    setState(() {
      _palliativeCare = false;
      _drivingLicence = false;
      _businessProfile = false;
      _qualifiedCarer = false;
      _priceRange = const RangeValues(0, 50);
      _hourlyPrice = 50;
      _selectedTasks.clear();
      _selectedCategories.clear();
      _selectedSubCategories.clear();
      _selectedExperiences = null;
      _coverImage = null;
      _palliativeImage = null;
      _drivingImage = null;
      _businessImage = null;
      _qualifiedImage = null;
    });
  }

  Future<void> _pickImage(Function(File) onPicked) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      onPicked(File(picked.path));
      setState(() {});
    }
  }

  Future<void> _pickMultipleImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        _images.addAll(pickedFiles.map((e) => File(e.path)));
      });
    }
  }

  // ── Apply: merge filter state back into existing params ───────────────────
  void _applyFilters() {
    final newCategoryId = _selectedCategories.isNotEmpty
        ? _selectedCategories.map((c) => c.id).join(',')
        : null;

    // Build comma-separated otherTaskIds
    final newTaskIds = _selectedTasks.isNotEmpty
        ? _selectedTasks.map((t) => t.id).join(',')
        : null;

    final newSubCategoryIds = _selectedSubCategories.isNotEmpty
        ? _selectedSubCategories.map((s) => s.id).join(',')
        : null;

    final newPath = AppRoutes.searchResultPathMerged(
      serviceId: widget.serviceId,
      existingParams: widget.existingParams,
      // Override filter params with current UI state:
      categoryId: newCategoryId ?? '', // '' clears it if deselected
      experienceOptionId: _selectedExperiences?.id ?? '',
      otherTaskIds: newTaskIds ?? '',
      minPrice: _priceRange.start > 0
          ? _priceRange.start.toStringAsFixed(0)
          : '',
      maxPrice: _priceRange.end < 100 ? _priceRange.end.toStringAsFixed(0) : '',
      palliativeCare: _palliativeCare ? 'true' : '',
      drivingLicense: _drivingLicence ? 'true' : '',
      businessProfiles: _businessProfile ? 'true' : '',
      qualifiedCarer: _qualifiedCarer ? 'true' : '',
      subcategoryIds: newSubCategoryIds ?? '',
    );

    context.go(newPath);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filterProvider);

    final pendingVerification = ref.watch(pendingVerificationProvider);

    ref.listen<AsyncValue<bool>>(updateProviderProvider, (prev, next) {
      if (next is AsyncError) {
        context.showErrorSnackBar(next.error.toString());
      }
      // Only auto-navigate on update flow; submit flow handles its own navigation
      if (next is AsyncData && next.value == true && pendingVerification == null) {
        context.go(AppRoutes.providerHome);
        context.showSuccessSnackBar(AppLocalizations.of(context)!.updatedSuccessfully);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ──────────────────────────────────────────────────
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
                            AppLocalizations.of(context)!.back,
                            color: AppColors.primaryFor(
                              ref.watch(appRoleProvider),
                            ),
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  if (ref.read(appRoleProvider) == AppRole.user)
                    GestureDetector(
                      onTap: _clearAll,
                      child: AppText.labelLg(
                        AppLocalizations.of(context)!.clearFilters,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                ],
              ),
            ),

            // ─── Body ────────────────────────────────────────────────────
            Expanded(
              child: state.when(
                error: (error, _) => ListView(
                  children: [AppEmptyState(title: error.toString())],
                ),
                loading: () => const AppLoader(),
                data: (data) {
                  // Pre-select items that match existing params.
                  _preselectFromData(data);

                  final experiences = data.experienceOptions;
                  final tasks = data.othersTaskOptions;
                  final categories = data.category;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (ref.read(appRoleProvider) == AppRole.user) ...[
                          AppToggleTile(
                            label: AppLocalizations.of(context)!.palliativeCare,
                            subtitle:
                                AppLocalizations.of(context)!.palliativeCareDesc,
                            value: _palliativeCare,
                            onChanged: (v) =>
                                setState(() => _palliativeCare = v),
                          ),
                          const AppDivider(
                            height: 40,
                            color: AppColors.grey400,
                          ),
                        ],
                        // ─── Price slider ──────────────────────────────
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

                        // ─── Experience ────────────────────────────────
                        AppText.h3(AppLocalizations.of(context)!.experienceLevel),
                        12.verticalSpace,
                        ...experiences.map(
                          (e) => AppCheckboxTile(
                            label: e.value,
                            value: _selectedExperiences == e,
                            onChanged: (_) =>
                                setState(() => _selectedExperiences = e),
                          ),
                        ),
                        const AppDivider(height: 40, color: AppColors.grey400),

                        // ─── Other tasks ───────────────────────────────
                        AppText.h3(AppLocalizations.of(context)!.specificTasksRequirements),
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

                        // ─── Specialists in ────────────────────────────
                        AppText.h3('Show specialists in:'),
                        12.verticalSpace,
                        ...categories.map(
                          (c) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppCheckboxTile(
                                label: c.name,
                                value: _selectedCategories.contains(c),
                                onChanged: (_) => setState(() {
                                  if (_selectedCategories.contains(c)) {
                                    _selectedCategories.remove(c);
                                    // Optionally clear selected subcategories for this category:
                                    _selectedSubCategories.removeWhere((sub) => sub.categoryId == c.id);
                                  } else {
                                    _selectedCategories.add(c);
                                  }
                                }),
                              ),
                              if (_selectedCategories.contains(c))
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: ref.watch(subcategoriesProvider(c.id)).when(
                                    data: (subcategories) {
                                      if (subcategories.isEmpty) return const SizedBox.shrink();
                                      return Column(
                                        children: subcategories.map(
                                          (sub) => AppCheckboxTile(
                                            label: sub.name,
                                            value: _selectedSubCategories.contains(sub),
                                            onChanged: (_) => setState(() {
                                              if (_selectedSubCategories.contains(sub)) {
                                                _selectedSubCategories.remove(sub);
                                              } else {
                                                _selectedSubCategories.add(sub);
                                              }
                                            }),
                                          ),
                                        ).toList(),
                                      );
                                    },
                                    loading: () => const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                    error: (error, _) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: AppText.bodySm('Error loading subcategories: $error', color: AppColors.error),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const AppDivider(height: 40, color: AppColors.grey400),

                        // ─── Toggles ───────────────────────────────────
                        if (ref.read(appRoleProvider) == AppRole.user) ...[
                          AppToggleTile(
                            label: AppLocalizations.of(context)!.drivingLicence,
                            subtitle:
                                AppLocalizations.of(context)!.drivingLicenceDesc,
                            value: _drivingLicence,
                            onChanged: (v) =>
                                setState(() => _drivingLicence = v),
                          ),
                          const AppDivider(
                            height: 40,
                            color: AppColors.grey400,
                          ),
                          AppToggleTile(
                            label: AppLocalizations.of(context)!.businessProfiles,
                            subtitle:
                                AppLocalizations.of(context)!.businessProfilesDesc,
                            value: _businessProfile,
                            onChanged: (v) =>
                                setState(() => _businessProfile = v),
                          ),
                          const AppDivider(
                            height: 40,
                            color: AppColors.grey400,
                          ),
                          AppToggleTile(
                            label: AppLocalizations.of(context)!.qualifiedCarer,
                            subtitle:
                                AppLocalizations.of(context)!.qualifiedCarerDesc,
                            value: _qualifiedCarer,
                            onChanged: (v) =>
                                setState(() => _qualifiedCarer = v),
                          ),
                          32.verticalSpace,
                        ],
                        // ─── Provider-only image uploads ───────────────
                        if (ref.watch(appRoleProvider) == AppRole.provider) ...[
                          AppText.h4(AppLocalizations.of(context)!.images),
                          12.verticalSpace,
                          _buildImageTile(
                            title: AppLocalizations.of(context)!.coverImage,
                            imageFile: _coverImage,
                            onTap: () => _pickImage((f) => _coverImage = f),
                          ),
                          AppText.labelLg(AppLocalizations.of(context)!.galleryImages),
                          12.verticalSpace,

                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _images.length + 1, // +1 for add button
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1,
                                ),
                            itemBuilder: (context, index) {
                              // ➕ ADD IMAGE TILE
                              if (index == 0) {
                                return GestureDetector(
                                  onTap: _pickMultipleImages,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: AppColors.grey300,
                                      ),
                                      color: AppColors.grey100,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate,
                                          size: 28,
                                          color: AppColors.grey600,
                                        ),
                                        6.verticalSpace,
                                        AppText.bodySm(
                                          AppLocalizations.of(context)!.add,
                                          color: AppColors.grey600,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }

                              final file = _images[index - 1];

                              return Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.05),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                      image: DecorationImage(
                                        image: FileImage(file),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),

                                  // ❌ Remove Button (clean modern style)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _images.removeAt(index - 1);
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.6),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          12.verticalSpace,
                          if (_palliativeCare)
                            _buildImageTile(
                              title: AppLocalizations.of(context)!.palliativeCareImage,
                              imageFile: _palliativeImage,
                              onTap: () =>
                                  _pickImage((f) => _palliativeImage = f),
                            ),
                          if (_drivingLicence)
                            _buildImageTile(
                              title: AppLocalizations.of(context)!.drivingLicenceImage,
                              imageFile: _drivingImage,
                              onTap: () => _pickImage((f) => _drivingImage = f),
                            ),
                          if (_businessProfile)
                            _buildImageTile(
                              title: AppLocalizations.of(context)!.businessProfileImage,
                              imageFile: _businessImage,
                              onTap: () =>
                                  _pickImage((f) => _businessImage = f),
                            ),
                          if (_qualifiedCarer)
                            _buildImageTile(
                              title: AppLocalizations.of(context)!.qualificationCertificate,
                              imageFile: _qualifiedImage,
                              onTap: () =>
                                  _pickImage((f) => _qualifiedImage = f),
                            ),
                        ],

                        // ─── Apply / Update button ─────────────────────
                        AppButton.primary(
                          label: ref.read(appRoleProvider) == AppRole.provider
                              ? (pendingVerification != null ? AppLocalizations.of(context)!.submit : AppLocalizations.of(context)!.update)
                              : AppLocalizations.of(context)!.applyFilters,
                          isLoading: ref.watch(updateProviderProvider).isLoading,
                          onPressed: () async {
                            if (ref.watch(appRoleProvider) == AppRole.provider) {
                              await ref
                                  .read(updateProviderProvider.notifier)
                                  .update(
                                    UpdateProviderRequest(
                                      hourlyRate: _hourlyPrice,
                                      businessProfilesOnly: _businessImage,
                                      drivingLicense: _drivingImage,
                                      experience: _selectedExperiences?.id,
                                      palliativeCare: _palliativeImage,
                                      qualifiedOnly: _qualifiedImage,
                                      coverImage: _businessImage,
                                      minimumPrice: _hourlyPrice,
                                      images: _images,
                                      specializations: _selectedCategories
                                          .map((c) => c.id)
                                          .toList(),
                                      providerSubcategories: _selectedSubCategories
                                          .map((c) => c.id)
                                          .toList(),
                                      tasks: _selectedTasks
                                          .map((e) => e.id)
                                          .toList(),
                                    ),
                                  );

                              if (!mounted) return;

                              // Submit flow: after profile update, call verification API
                              final pending = ref.read(pendingVerificationProvider);
                              if (pending != null) {
                                final result = await ref
                                    .read(userRepositoryProvider)
                                    .submitVerification(pending);
                                if (!mounted) return;
                                result.when(
                                  success: (_) {
                                    ref.read(pendingVerificationProvider.notifier).clear();
                                    _showVerificationSuccessDialog();
                                  },
                                  failure: (f) => context.showErrorSnackBar(f.message),
                                );
                              }
                            } else {
                              _applyFilters();
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

  /// Once the filter options load from the API, pre-select the items whose IDs
  /// match what's currently in the URL params.
  void _preselectFromData(ServiceFiltersModel data) {
    final p = widget.existingParams;

    // Experience
    final expId = p['experienceOptionId'];
    if (expId != null && _selectedExperiences == null) {
      final match = data.experienceOptions
          .cast<FilterOptionModel?>()
          .firstWhere((e) => e?.id == expId, orElse: () => null);
      if (match != null) {
        // Use addPostFrameCallback to avoid calling setState during build.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _selectedExperiences = match);
        });
      }
    }

    // Tasks
    final taskIds = (p['otherTaskIds'] ?? '')
        .split(',')
        .where((s) => s.isNotEmpty)
        .toSet();
    if (taskIds.isNotEmpty && _selectedTasks.isEmpty) {
      final matches = data.othersTaskOptions
          .where((t) => taskIds.contains(t.id))
          .toSet();
      if (matches.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _selectedTasks.addAll(matches));
        });
      }
    }

    // Categories (multi-select)
    final catIds = (p['categoryId'] ?? '')
        .split(',')
        .where((s) => s.isNotEmpty)
        .toSet();
    if (catIds.isNotEmpty && _selectedCategories.isEmpty) {
      final matches = data.category.where((c) => catIds.contains(c.id)).toSet();
      if (matches.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _selectedCategories.addAll(matches));
        });
      }
    }
  }

  void _showVerificationSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: AppText(AppLocalizations.of(context)!.verificationSubmitted),
        content: AppText(
          AppLocalizations.of(context)!.verificationSubmittedDesc,
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(logoutProvider.notifier).logout();
              context.go(AppRoutes.login);
            },
            child: AppText(AppLocalizations.of(context)!.logout),
          ),
        ],
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
