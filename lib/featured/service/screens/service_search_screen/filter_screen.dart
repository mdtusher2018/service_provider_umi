// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:service_provider_umi/core/router/app_routes.dart';
// import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
// import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:service_provider_umi/core/di/app_role_provider.dart';
// import 'package:service_provider_umi/data/models/service_provider_models.dart';
// import 'package:service_provider_umi/data/models/provider_models.dart';
// import 'package:service_provider_umi/data/models/category_models.dart';
// import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
// import 'package:service_provider_umi/shared/enums/app_enums.dart';
// import 'package:service_provider_umi/shared/widgets/app_button.dart';
// import 'package:service_provider_umi/shared/widgets/app_checkbox.dart';
// import 'package:service_provider_umi/core/theme/app_colors.dart';
// import 'package:service_provider_umi/shared/widgets/app_slider.dart';
// import 'package:service_provider_umi/shared/widgets/app_text.dart';
// import 'package:service_provider_umi/shared/widgets/app_utils.dart';

// class FilterScreen extends ConsumerStatefulWidget {
//   const FilterScreen({super.key});

//   @override
//   ConsumerState<FilterScreen> createState() => _FilterScreenState();
// }

// class _FilterScreenState extends ConsumerState<FilterScreen> {
//   // ─── State ───────────────────────────────────────────────
//   bool _palliativeCare = false;
//   bool _drivingLicence = false;
//   bool _businessProfile = false;
//   bool _qualifiedCarer = false;
//   RangeValues _priceRange = const RangeValues(0, 50);
//   double _hourlyPrice = 50;

//   final Set<FilterOptionModel> _selectedTasks = {};
//   CategoryModel? _selectedCategory;
//   FilterOptionModel? _selectedExperiences;

//   // ─── Image States ─────────────────────────
//   File? _coverImage;
//   File? _palliativeImage;
//   File? _drivingImage;
//   File? _businessImage;
//   File? _qualifiedImage;

//   void _clearAll() {
//     setState(() {
//       _palliativeCare = false;
//       _drivingLicence = false;
//       _businessProfile = false;
//       _qualifiedCarer = false;
//       _priceRange = const RangeValues(0, 50);
//       _selectedTasks.clear();
//       _selectedCategory = null;
//       _selectedExperiences = null;

//       _coverImage = null;
//       _palliativeImage = null;
//       _drivingImage = null;
//       _businessImage = null;
//       _qualifiedImage = null;
//     });
//   }

//   /// ─── Image Picker ───────────────────────
//   Future<void> _pickImage(Function(File) onPicked) async {
//     final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

//     if (picked != null) {
//       onPicked(File(picked.path));
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       ref.read(filterProvider.notifier).fetch();
//     });

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(filterProvider);
//     ref.listen<AsyncValue<bool>>(updateProviderProvider, (prev, next) {
//       if (next is AsyncError) {
//         context.showErrorSnackBar(next.error.toString());
//       }
//       if (next is AsyncData && next.value == true) {
//         context.go(AppRoutes.providerHome);
//         context.showSuccessSnackBar("updated successfully");
//       }
//     });

//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ─── Header ─────────────────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
//               child: Row(
//                 children: [
//                   if (!kIsWeb)
//                     GestureDetector(
//                       onTap: () => context.pop(),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.arrow_back_ios_rounded,
//                             color: AppColors.primaryFor(
//                               ref.watch(appRoleProvider),
//                             ),
//                             size: 18,
//                           ),
//                           8.horizontalSpace,
//                           AppText.h1(
//                             'Back',
//                             color: AppColors.primaryFor(
//                               ref.watch(appRoleProvider),
//                             ),
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ],
//                       ),
//                     ),
//                   const Spacer(),
//                   if (ref.read(appRoleProvider) == AppRole.user)
//                     GestureDetector(
//                       onTap: _clearAll,
//                       child: AppText.labelLg(
//                         'Clear filters',
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                 ],
//               ),
//             ),

//             Expanded(
//               child: state.when(
//                 error: (error, stackTrace) {
//                   return ListView(
//                     children: [AppEmptyState(title: error.toString())],
//                   );
//                 },
//                 loading: () => AppLoader(),
//                 data: (data) {
//                   final experiences = data.experienceOptions;
//                   final tasks = data.othersTaskOptions;
//                   final category = data.category;
//                   return SingleChildScrollView(
//                     padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         AppToggleTile(
//                           label: 'Palliative care',
//                           subtitle:
//                               'Only show professionals specialising in palliative care.',
//                           value: _palliativeCare,
//                           onChanged: (v) => setState(() => _palliativeCare = v),
//                         ),

//                         const AppDivider(height: 40, color: AppColors.grey400),
//                         // ─── Price slider ────────────────────
//                         (ref.read(appRoleProvider) == AppRole.provider)
//                             ? AppPriceSlider(
//                                 value: _hourlyPrice,
//                                 min: 0,
//                                 max: 100,
//                                 onChanged: (v) =>
//                                     setState(() => _hourlyPrice = v),
//                               )
//                             : AppPriceRangeSlider(
//                                 values: _priceRange,
//                                 min: 0,
//                                 max: 100,
//                                 onChanged: (v) =>
//                                     setState(() => _priceRange = v),
//                               ),

//                         const AppDivider(height: 40, color: AppColors.grey400),

//                         // ─── Experience ──────────────────────
//                         AppText.h3("Professional's experience"),
//                         12.verticalSpace,
//                         ...experiences.asMap().entries.map(
//                           (e) => AppCheckboxTile(
//                             label: e.value.value,
//                             value: _selectedExperiences == e.value,
//                             onChanged: (_) => setState(() {
//                               _selectedExperiences = e.value;
//                             }),
//                           ),
//                         ),
//                         const AppDivider(height: 40, color: AppColors.grey400),

//                         // ─── Other tasks ─────────────────────
//                         AppText.h3('Other required tasks'),
//                         12.verticalSpace,
//                         ...tasks.map(
//                           (t) => AppCheckboxTile(
//                             label: t.value,
//                             value: _selectedTasks.contains(t),
//                             onChanged: (_) => setState(() {
//                               _selectedTasks.contains(t)
//                                   ? _selectedTasks.remove(t)
//                                   : _selectedTasks.add(t);
//                             }),
//                           ),
//                         ),
//                         const AppDivider(height: 40, color: AppColors.grey400),

//                         // ─── Specialists in ──────────────────
//                         AppText.h3('Show specialists in:'),
//                         12.verticalSpace,
//                         ...category.map(
//                           (c) => AppCheckboxTile(
//                             label: c.name,
//                             value: _selectedCategory == c,
//                             onChanged: (_) => setState(() {
//                               _selectedCategory = c;
//                             }),
//                           ),
//                         ),
//                         const AppDivider(height: 40, color: AppColors.grey400),

//                         // ─── Toggles ─────────────────────────
//                         AppToggleTile(
//                           label: 'Driving licence',
//                           subtitle:
//                               'Only show professionals with a driving licence',
//                           value: _drivingLicence,
//                           onChanged: (v) => setState(() => _drivingLicence = v),
//                         ),
//                         const AppDivider(height: 40, color: AppColors.grey400),
//                         AppToggleTile(
//                           label: 'Business profiles',
//                           subtitle:
//                               'Only profiles that correspond to a validated business or self employed professional.',
//                           value: _businessProfile,
//                           onChanged: (v) =>
//                               setState(() => _businessProfile = v),
//                         ),
//                         const AppDivider(height: 40, color: AppColors.grey400),
//                         AppToggleTile(
//                           label: 'Qualified carer',
//                           subtitle:
//                               'Only show caregivers with a qualification, diploma or degree as health personal',
//                           value: _qualifiedCarer,
//                           onChanged: (v) => setState(() => _qualifiedCarer = v),
//                         ),
//                         32.verticalSpace,

//                         if (ref.watch(appRoleProvider) == AppRole.provider) ...[
//                           AppText.h4("Images"),
//                           12.verticalSpace,

//                           /// Cover Image (Always)
//                           _buildImageTile(
//                             title: "Cover Image",
//                             imageFile: _coverImage,
//                             onTap: () => _pickImage((f) => _coverImage = f),
//                           ),

//                           /// Conditional Images
//                           if (_palliativeCare)
//                             _buildImageTile(
//                               title: "Palliative Care Image",
//                               imageFile: _palliativeImage,
//                               onTap: () =>
//                                   _pickImage((f) => _palliativeImage = f),
//                             ),

//                           if (_drivingLicence)
//                             _buildImageTile(
//                               title: "Driving Licence Image",
//                               imageFile: _drivingImage,
//                               onTap: () => _pickImage((f) => _drivingImage = f),
//                             ),

//                           if (_businessProfile)
//                             _buildImageTile(
//                               title: "Business Profile Image",
//                               imageFile: _businessImage,
//                               onTap: () =>
//                                   _pickImage((f) => _businessImage = f),
//                             ),

//                           if (_qualifiedCarer)
//                             _buildImageTile(
//                               title: "Qualification Certificate",
//                               imageFile: _qualifiedImage,
//                               onTap: () =>
//                                   _pickImage((f) => _qualifiedImage = f),
//                             ),
//                         ],
//                         // ─── Apply button ────────────────────
//                         AppButton.primary(
//                           label: 'Update',
//                           isLoading: ref
//                               .watch(updateProviderProvider)
//                               .isLoading,

//                           onPressed: () async {
//                             if (ref.watch(appRoleProvider) ==
//                                 AppRole.provider) {
//                               if (kIsWeb) {
//                                 context.go(AppRoutes.profilePicture);
//                               } else {
//                                 final notifier = ref.read(
//                                   updateProviderProvider.notifier,
//                                 );

//                                await notifier.update(
//                                   UpdateProviderRequest(
//                                     hourlyRate: _hourlyPrice,
//                                     businessProfilesOnly: _businessImage,
//                                     drivingLicense: _drivingImage,
//                                     experience: _selectedExperiences?.id,

//                                     palliativeCare: _palliativeImage,
//                                     qualifiedOnly: _qualifiedImage,
//                                     specializations: [
//                                       _selectedCategory?.id ?? "",
//                                     ],
//                                     tasks: _selectedTasks
//                                         .map((e) => e.id)
//                                         .toList(),
//                                   ),
//                                 );
//                               }

//                               return;
//                             }

//                             if (kIsWeb) {
//                               context.go(AppRoutes.searchResults);
//                             } else {
//                               context.go(AppRoutes.searchResults);
//                               context.pop({
//                                 'palliativeCare': _palliativeCare,
//                                 'drivingLicence': _drivingLicence,
//                                 'qualifiedCarer': _qualifiedCarer,
//                                 'businessProfile': _businessProfile,
//                                 'priceMin': _priceRange.start,
//                                 'priceMax': _priceRange.end,
//                                 'tasks': _selectedTasks.toList(),
//                                 'conditions': [_selectedCategory],
//                                 'experiences': [_selectedExperiences],
//                               });
//                             }
//                           },
//                         ),
//                         32.verticalSpace,
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// ─── Reusable Image Tile ───────────────
//   Widget _buildImageTile({
//     required String title,
//     required File? imageFile,
//     required VoidCallback onTap,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AppText.labelLg(title),
//         8.verticalSpace,
//         GestureDetector(
//           onTap: onTap,
//           child: Container(
//             height: 100,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               color: AppColors.grey200,
//               image: imageFile != null
//                   ? DecorationImage(
//                       image: FileImage(imageFile),
//                       fit: BoxFit.cover,
//                     )
//                   : null,
//             ),
//             child: imageFile == null ? const Icon(Icons.add_a_photo) : null,
//           ),
//         ),
//         16.verticalSpace,
//       ],
//     );
//   }
// }
//

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
import 'package:service_provider_umi/data/models/service_provider_models.dart';
import 'package:service_provider_umi/data/models/provider_models.dart';
import 'package:service_provider_umi/data/models/category_models.dart';
import 'package:service_provider_umi/featured/service/riverpod/service_provider.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_checkbox.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_slider.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

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
  CategoryModel? _selectedCategory;
  FilterOptionModel? _selectedExperiences;

  // ─── Image states (provider only) ────────────────────────────────────────
  File? _coverImage;
  File? _palliativeImage;
  File? _drivingImage;
  File? _businessImage;
  File? _qualifiedImage;

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
      _selectedCategory = null;
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

  // ── Apply: merge filter state back into existing params ───────────────────
  void _applyFilters() {
    // categoryId from filter selection takes priority over the existing one.
    final newCategoryId = _selectedCategory?.id;

    // Build comma-separated otherTaskIds
    final newTaskIds = _selectedTasks.isNotEmpty
        ? _selectedTasks.map((t) => t.id).join(',')
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
    );


      context.go(newPath);
    
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filterProvider);

    ref.listen<AsyncValue<bool>>(updateProviderProvider, (prev, next) {
      if (next is AsyncError) {
        context.showErrorSnackBar(next.error.toString());
      }
      if (next is AsyncData && next.value == true) {
        context.go(AppRoutes.providerHome);
        context.showSuccessSnackBar('Updated successfully');
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
                  if (ref.read(appRoleProvider) == AppRole.user)
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
                        AppToggleTile(
                          label: 'Palliative care',
                          subtitle:
                              'Only show professionals specialising in palliative care.',
                          value: _palliativeCare,
                          onChanged: (v) => setState(() => _palliativeCare = v),
                        ),
                        const AppDivider(height: 40, color: AppColors.grey400),

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
                        AppText.h3("Professional's experience"),
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

                        // ─── Specialists in ────────────────────────────
                        AppText.h3('Show specialists in:'),
                        12.verticalSpace,
                        ...categories.map(
                          (c) => AppCheckboxTile(
                            label: c.name,
                            value: _selectedCategory == c,
                            onChanged: (_) =>
                                setState(() => _selectedCategory = c),
                          ),
                        ),
                        const AppDivider(height: 40, color: AppColors.grey400),

                        // ─── Toggles ───────────────────────────────────
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

                        // ─── Provider-only image uploads ───────────────
                        if (ref.watch(appRoleProvider) == AppRole.provider) ...[
                          AppText.h4('Images'),
                          12.verticalSpace,
                          _buildImageTile(
                            title: 'Cover Image',
                            imageFile: _coverImage,
                            onTap: () => _pickImage((f) => _coverImage = f),
                          ),
                          if (_palliativeCare)
                            _buildImageTile(
                              title: 'Palliative Care Image',
                              imageFile: _palliativeImage,
                              onTap: () =>
                                  _pickImage((f) => _palliativeImage = f),
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
                              onTap: () =>
                                  _pickImage((f) => _businessImage = f),
                            ),
                          if (_qualifiedCarer)
                            _buildImageTile(
                              title: 'Qualification Certificate',
                              imageFile: _qualifiedImage,
                              onTap: () =>
                                  _pickImage((f) => _qualifiedImage = f),
                            ),
                        ],

                        // ─── Apply / Update button ─────────────────────
                        AppButton.primary(
                          label: ref.read(appRoleProvider) == AppRole.provider
                              ? 'Update'
                              : 'Apply filters',
                          isLoading: ref
                              .watch(updateProviderProvider)
                              .isLoading,
                          onPressed: () async {
                            if (ref.watch(appRoleProvider) ==
                                AppRole.provider) {
                              // Provider profile update flow (unchanged)
                              if (kIsWeb) {
                                context.go(AppRoutes.profilePicture);
                              } else {
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
                                        specializations: [
                                          _selectedCategory?.id ?? '',
                                        ],
                                        tasks: _selectedTasks
                                            .map((e) => e.id)
                                            .toList(),
                                      ),
                                    );
                              }
                              return;
                            } else {
                              // User / search filter flow:
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

    // Category
    final catId = p['categoryId'];
    if (catId != null && _selectedCategory == null) {
      final match = data.category.cast<CategoryModel?>().firstWhere(
        (c) => c?.id == catId,
        orElse: () => null,
      );
      if (match != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _selectedCategory = match);
        });
      }
    }
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
