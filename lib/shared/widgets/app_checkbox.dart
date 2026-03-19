import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Checkbox row - as seen in filter screens (palliative care, qualified carer, etc.)
class AppCheckboxTile extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final bool enabled;

  const AppCheckboxTile({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? () => onChanged?.call(!value) : null,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: value,
                onChanged: enabled ? onChanged : null,
                activeColor: AppColors.primary,
                checkColor: AppColors.white,
                side: const BorderSide(color: AppColors.border, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodyMd.copyWith(
                      color: enabled
                          ? AppColors.textPrimary
                          : AppColors.textDisabled,
                    ),
                  ),
                  if (subtitle != null) ...[
                    2.verticalSpace,
                    Text(subtitle!, style: AppTextStyles.bodySm),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Toggle switch row - as seen in filter (Palliative care, Qualified carer, Driving licence)
class AppToggleTile extends ConsumerWidget {
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const AppToggleTile({
    super.key,
    required this.label,
    this.subtitle,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.h4),
              if (subtitle != null) ...[
                2.verticalSpace,
                Text(subtitle!, style: AppTextStyles.bodySm),
              ],
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: AppColors.primary,
          activeTrackColor: AppColors.primaryFor(ref.watch(appRoleProvider)),
          inactiveThumbColor: AppColors.grey300,
          inactiveTrackColor: AppColors.grey200,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }
}
