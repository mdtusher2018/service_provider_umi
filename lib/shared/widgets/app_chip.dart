import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Day chip - compact version for day-of-week selection
class AppDayChip extends StatelessWidget {
  final String day; // e.g. "Mon"
  final String? date; // e.g. "13"
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDisabled;
  final EdgeInsetsGeometry? padding;

  const AppDayChip({
    super.key,
    required this.day,
    this.date,
    this.isSelected = false,
    this.onTap,
    this.isDisabled = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        constraints: BoxConstraints(minWidth: 44),
        padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isDisabled
                ? AppColors.grey200
                : AppColors.border,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              day,
              style: AppTextStyles.labelMd.copyWith(
                color: isSelected
                    ? AppColors.white
                    : isDisabled
                    ? AppColors.textDisabled
                    : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (date != null) ...[
              2.verticalSpace,
              AppText(
                date!,
                style: AppTextStyles.labelMd.copyWith(
                  color: isSelected
                      ? AppColors.white
                      : isDisabled
                      ? AppColors.textDisabled
                      : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Time slot chip
class AppTimeChip extends StatelessWidget {
  final String time;
  final bool isSelected;
  final bool isAvailable;
  final VoidCallback? onTap;

  const AppTimeChip({
    super.key,
    required this.time,
    this.isSelected = false,
    this.isAvailable = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isAvailable
              ? AppColors.white
              : AppColors.grey100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isAvailable
                ? AppColors.border
                : AppColors.grey200,
          ),
        ),
        child: Text(
          time,
          style: AppTextStyles.labelMd.copyWith(
            color: isSelected
                ? AppColors.white
                : isAvailable
                ? AppColors.textPrimary
                : AppColors.textDisabled,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
