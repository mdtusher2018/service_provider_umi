import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/core/theme/app_text_styles.dart';
import 'package:service_provider_umi/core/localization/locale_provider.dart';

import '../../../l10n/app_localizations.dart';

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  final Map<String, String> _languageMap = {
    'en': 'English',
    'ro': 'Romanian',
    'fr': 'French',
    'es': 'Spanish',
    'de': 'German',
    'ar': 'Arabic',
    'pt': 'Portuguese',
    'it': 'Italian',
  };

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localizationProvider).value?.languageCode ?? 'en';
    final currentLanguageName = _languageMap[currentLocale] ?? 'English';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
          onPressed: () => context.pop(),
        ),
        title: AppText.h3(AppLocalizations.of(context)!.changeLanguage),
        centerTitle: true,
      ),
      body: Padding(
        padding: 20.paddingAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText.labelMd(
              AppLocalizations.of(context)!.changeLanguage,
              color: AppColors.textSecondary,
            ),
            10.verticalSpace,
            // Dropdown
            Container(
              padding: 16.paddingH,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: 12.circular,
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: currentLanguageName,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                  ),
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  items: _languageMap.values
                      .map(
                        (lang) =>
                            DropdownMenuItem(value: lang, child: AppText(lang)),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      final code = _languageMap.entries.firstWhere((e) => e.value == v).key;
                      ref.read(localizationProvider.notifier).setLocale(code);
                    }
                  },
                ),
              ),
            ),
            const Spacer(),
            AppButton.primary(
              label: AppLocalizations.of(context)!.save,
              onPressed: () {
                context.showSnackBar(
                  AppLocalizations.of(context)!.languageChangedTo(currentLanguageName),
                );
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
