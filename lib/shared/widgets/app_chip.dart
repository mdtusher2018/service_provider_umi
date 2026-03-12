import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Selection chip - as seen in frequency, day selection, time slots
class AppChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Widget? icon;
  final bool showBorder;

  const AppChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.padding,
    this.borderRadius,
    this.icon,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected
        ? (selectedColor ?? AppColors.secondary)
        : (unselectedColor ?? AppColors.white);

    final txtColor = isSelected
        ? (selectedTextColor ?? AppColors.white)
        : (unselectedTextColor ?? AppColors.textPrimary);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: padding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius ?? 24),
          border: showBorder
              ? Border.all(
                  color: isSelected ? AppColors.secondary : AppColors.border,
                  width: 1.5,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTextStyles.labelMd.copyWith(
                color: txtColor,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Day chip - compact version for day-of-week selection
class AppDayChip extends StatelessWidget {
  final String day;   // e.g. "Mon"
  final String? date; // e.g. "13"
  final bool isSelected;
  final VoidCallback? onTap;
  final bool isDisabled;

  const AppDayChip({
    super.key,
    required this.day,
    this.date,
    this.isSelected = false,
    this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(12),
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
            Text(
              day,
              style: AppTextStyles.labelSm.copyWith(
                color: isSelected
                    ? AppColors.white
                    : isDisabled
                        ? AppColors.textDisabled
                        : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (date != null) ...[
              const SizedBox(height: 2),
              Text(
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
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
