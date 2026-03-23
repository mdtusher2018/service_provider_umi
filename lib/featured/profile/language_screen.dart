import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/core/theme/app_text_styles.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selected = 'English';
  final List<String> _languages = [
    'English',
    'Romanian',
    'French',
    'Spanish',
    'German',
    'Arabic',
    'Portuguese',
    'Italian',
  ];

  @override
  Widget build(BuildContext context) {
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
        title: const AppText.h3('Change Language'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText.labelMd(
              'Change language',
              color: AppColors.textSecondary,
            ),
            10.verticalSpace,
            // Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selected,
                  isExpanded: true,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                  ),
                  style: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  items: _languages
                      .map(
                        (lang) =>
                            DropdownMenuItem(value: lang, child: AppText(lang)),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selected = v!),
                ),
              ),
            ),
            const Spacer(),
            AppButton.primary(
              label: 'Save',
              onPressed: () {
                context.showSnackBar('Language changed to $_selected');
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
