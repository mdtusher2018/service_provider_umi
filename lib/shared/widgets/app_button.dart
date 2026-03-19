import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/theme/app_role.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, outline, ghost, danger, social }

enum AppButtonSize { sm, md, lg }

// ─────────────────────────────────────────────────────────────
//  AppButton — role-aware
//
//  Only change from your original:
//   1. StatelessWidget → ConsumerWidget
//   2. build() receives WidgetRef ref
//   3. _primary(ref) resolves the correct color from role
//
//  Everything else is identical to your original.
// ─────────────────────────────────────────────────────────────

class AppButton extends ConsumerWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.lg,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  });

  const AppButton.primary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.lg,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  }) : variant = AppButtonVariant.primary;

  const AppButton.secondary({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.lg,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  }) : variant = AppButtonVariant.secondary;

  const AppButton.outline({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.lg,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  }) : variant = AppButtonVariant.outline;

  const AppButton.ghost({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.md,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  }) : variant = AppButtonVariant.ghost;

  const AppButton.danger({
    super.key,
    required this.label,
    this.onPressed,
    this.size = AppButtonSize.lg,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
  }) : variant = AppButtonVariant.danger;

  // ─── Single helper: resolves primary based on role ────────
  Color _primary(WidgetRef ref) {
    final role = ref.watch(appRoleProvider);
    return role == AppRole.provider
        ? AppColors.primaryProvider
        : AppColors.primary;
  }

  // ─── Build ────────────────────────────────────────────────
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = _primary(ref); // ← teal or blue
    final radius = borderRadius ?? BorderRadius.circular(12);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: isFullWidth ? double.infinity : width,
        height: _height,
        decoration: _decoration(radius, primary),
        alignment: Alignment.center,
        child: isLoading ? _loader(primary) : _content(primary),
      ),
    );
  }

  // ─── Widgets ─────────────────────────────────────────────

  Widget _content(Color primary) {
    return Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (prefixIcon != null) ...[prefixIcon!, 10.horizontalSpace],
        Text(label, style: _textStyle(primary)),
        if (suffixIcon != null) ...[10.horizontalSpace, suffixIcon!],
      ],
    );
  }

  Widget _loader(Color primary) {
    return SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: textColor ?? _defaultTextColor(primary),
      ),
    );
  }

  // ─── Decoration ──────────────────────────────────────────

  BoxDecoration _decoration(BorderRadius radius, Color primary) {
    return BoxDecoration(
      color: backgroundColor ?? _defaultBackgroundColor(primary),
      borderRadius: radius,
      border: _border(primary),
    );
  }

  Border? _border(Color primary) {
    if (variant == AppButtonVariant.outline) {
      return Border.all(
        color: borderColor ?? primary, // ← teal or blue border
        width: 1.5,
      );
    }
    if (variant == AppButtonVariant.social) {
      return Border.all(color: borderColor ?? AppColors.border, width: 1.5);
    }
    return null;
  }

  // ─── Color resolvers ─────────────────────────────────────

  Color _defaultBackgroundColor(Color primary) {
    switch (variant) {
      case AppButtonVariant.primary:
        return primary; // ← teal or blue
      case AppButtonVariant.secondary:
        return AppColors.secondary;
      case AppButtonVariant.outline:
      case AppButtonVariant.social:
        return AppColors.white;
      case AppButtonVariant.ghost:
        return Colors.transparent;
      case AppButtonVariant.danger:
        return AppColors.error;
    }
  }

  Color _defaultTextColor(Color primary) {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.secondary:
      case AppButtonVariant.danger:
        return AppColors.white;
      case AppButtonVariant.outline:
      case AppButtonVariant.social:
        return AppColors.textPrimary;
      case AppButtonVariant.ghost:
        return primary; // ← teal or blue
    }
  }

  // ─── Unchanged ───────────────────────────────────────────

  double get _height {
    switch (size) {
      case AppButtonSize.sm:
        return 36;
      case AppButtonSize.md:
        return 44;
      case AppButtonSize.lg:
        return 52;
    }
  }

  TextStyle _textStyle(Color primary) {
    final base = size == AppButtonSize.sm
        ? AppTextStyles.buttonMd
        : AppTextStyles.buttonLg;
    return base.copyWith(color: textColor ?? _defaultTextColor(primary));
  }
}
