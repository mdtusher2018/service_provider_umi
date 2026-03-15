import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  final Set<String> _selectedTasks = {};
  final Set<String> _selectedConditions = {};
  final Set<int> _selectedExperiences = {};

  static const _tasks = [
    'Basic household cleaning',
    'Washing and ironing clothes',
    'Cooking',
    'Feeding the elderly',
    'Going for walks',
    'Medication reminder',
    'Help with personal hygiene',
    'Basic exercise',
    'Grocery shopping',
  ];

  static const _conditions = [
    'Senile dementia',
    "Alzheimer's",
    "Parkinson's",
    'Arthritis or osteoarthritis',
    'Arteriosclerosis',
    'Osteoporosis',
    'Blindness',
    'Deafness',
    'Cancer',
    'Diabetes',
    'Stroke',
    'ALS',
  ];

  static const _experiences = [
    '0-2 years of experience',
    '2-5 years of experience',
    '6-10 years of experience',
    '11-20 years of experience',
    '+20 years of experience',
  ];

  void _clearAll() {
    setState(() {
      _palliativeCare = false;
      _drivingLicence = false;
      _businessProfile = false;
      _qualifiedCarer = false;
      _priceRange = const RangeValues(0, 50);
      _selectedTasks.clear();
      _selectedConditions.clear();
      _selectedExperiences.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_back_ios_rounded,
                          color: AppColors.primary,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        AppText.h1(
                          'Back',
                          color: AppColors.primary,
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppToggleTile(
                      label: 'Palliative care',
                      subtitle:
                          'Only show professionals specialising in palliative care.',
                      value: _businessProfile,
                      onChanged: (v) => setState(() => _businessProfile = v),
                    ),

                    const AppDivider(height: 40, color: AppColors.grey400),
                    // ─── Price slider ────────────────────
                    AppPriceSlider(
                      values: _priceRange,
                      min: 0,
                      max: 100,
                      onChanged: (v) => setState(() => _priceRange = v),
                    ),
                    const AppDivider(height: 40, color: AppColors.grey400),

                    // ─── Experience ──────────────────────
                    AppText.h3("Professional's experience"),
                    const SizedBox(height: 12),
                    ..._experiences.asMap().entries.map(
                      (e) => AppCheckboxTile(
                        label: e.value,
                        value: _selectedExperiences.contains(e.key),
                        onChanged: (_) => setState(() {
                          _selectedExperiences.contains(e.key)
                              ? _selectedExperiences.remove(e.key)
                              : _selectedExperiences.add(e.key);
                        }),
                      ),
                    ),
                    const AppDivider(height: 40, color: AppColors.grey400),

                    // ─── Other tasks ─────────────────────
                    AppText.h3('Other required tasks'),
                    const SizedBox(height: 12),
                    ..._tasks.map(
                      (t) => AppCheckboxTile(
                        label: t,
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
                    const SizedBox(height: 12),
                    ..._conditions.map(
                      (c) => AppCheckboxTile(
                        label: c,
                        value: _selectedConditions.contains(c),
                        onChanged: (_) => setState(() {
                          _selectedConditions.contains(c)
                              ? _selectedConditions.remove(c)
                              : _selectedConditions.add(c);
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
                      onChanged: (v) => setState(() => _businessProfile = v),
                    ),
                    const AppDivider(height: 40, color: AppColors.grey400),
                    AppToggleTile(
                      label: 'Qualified carer',
                      subtitle:
                          'Only show caregivers with a qualification, diploma or degree as health personal',
                      value: _qualifiedCarer,
                      onChanged: (v) => setState(() => _qualifiedCarer = v),
                    ),
                    const SizedBox(height: 32),

                    // ─── Apply button ────────────────────
                    AppButton.primary(
                      label: 'Update',
                      onPressed: () => Navigator.of(context).pop({
                        'palliativeCare': _palliativeCare,
                        'drivingLicence': _drivingLicence,
                        'qualifiedCarer': _qualifiedCarer,
                        'businessProfile': _businessProfile,
                        'priceMin': _priceRange.start,
                        'priceMax': _priceRange.end,
                        'tasks': _selectedTasks.toList(),
                        'conditions': _selectedConditions.toList(),
                        'experiences': _selectedExperiences.toList(),
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
