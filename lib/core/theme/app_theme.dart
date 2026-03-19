import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_dimensions.dart';
import 'app_role.dart';
import 'app_text_styles.dart';

// ─────────────────────────────────────────────────────────────
//  AppTheme
//
//  BEFORE (your original):
//    theme: AppTheme.light
//
//  AFTER (role-aware):
//    theme: AppTheme.of(AppRole.user)      → teal  #00C0B5
//    theme: AppTheme.of(AppRole.provider)  → blue  #0084BF
//
//  The static `light` getter is kept for zero breaking changes.
//  It always returns the user (teal) theme.
// ─────────────────────────────────────────────────────────────

class AppTheme {
  AppTheme._();

  // ─── Public API ──────────────────────────────────────────

  /// Role-aware entry point. Pass the current session role.
  static ThemeData of(AppRole role) => _build(
    primary: AppColors.primaryFor(role),
    primaryDark: AppColors.primaryDarkFor(role),
    primaryLight: AppColors.primaryLightFor(role),
    primarySurface: AppColors.primarySurfaceFor(role),
    borderFocus: AppColors.borderFocusFor(role),
  );

  /// Backward-compatible — same as of(AppRole.user).
  static ThemeData get light => of(AppRole.user);

  // ─── Core builder ────────────────────────────────────────
  static ThemeData _build({
    required Color primary,
    required Color primaryDark,
    required Color primaryLight,
    required Color primarySurface,
    required Color borderFocus,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: _colorScheme(
        primary: primary,
        primaryLight: primaryLight,
        primarySurface: primarySurface,
      ),
      elevatedButtonTheme: _elevatedButton(primary),
      outlinedButtonTheme: _outlinedButton(primary),
      textButtonTheme: _textButton(primary),
      inputDecorationTheme: _inputDecoration(primary, borderFocus),
      cardTheme: _cardTheme(),
      dividerTheme: _dividerTheme(),
      bottomNavigationBarTheme: _bottomNavTheme(primary),
      bottomSheetTheme: _bottomSheetTheme(),
      chipTheme: _chipTheme(primary),
      scaffoldBackgroundColor: AppColors.background,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: 'Poppins',
    );
  }

  // ─── ColorScheme ─────────────────────────────────────────
  static ColorScheme _colorScheme({
    required Color primary,
    required Color primaryLight,
    required Color primarySurface,
  }) {
    return ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: AppColors.white,
      primaryContainer: primaryLight,
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      secondaryContainer: AppColors.secondaryLight,
      tertiary: AppColors.accent,
      onTertiary: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      errorContainer: AppColors.errorLight,
      onErrorContainer: AppColors.error,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.border,
      outlineVariant: AppColors.divider,
    );
  }

  // ─── ElevatedButton ──────────────────────────────────────
  static ElevatedButtonThemeData _elevatedButton(Color primary) =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: AppColors.white,
          minimumSize: const Size(
            AppDimensions.buttonMinWidth,
            AppDimensions.buttonHeightMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          textStyle: AppTextStyles.buttonLg,
          elevation: 0,
        ),
      );

  // ─── OutlinedButton ──────────────────────────────────────
  static OutlinedButtonThemeData _outlinedButton(Color primary) =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size(
            AppDimensions.buttonMinWidth,
            AppDimensions.buttonHeightMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          side: BorderSide(color: primary),
          textStyle: AppTextStyles.buttonLg,
        ),
      );

  // ─── TextButton ──────────────────────────────────────────
  static TextButtonThemeData _textButton(Color primary) => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: primary,
      textStyle: AppTextStyles.labelLg,
    ),
  );

  // ─── InputDecoration ─────────────────────────────────────
  static InputDecorationTheme _inputDecoration(
    Color primary,
    Color borderFocus,
  ) => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.grey100,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.spaceLg,
      vertical: AppDimensions.spaceMd,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
      borderSide: const BorderSide(color: AppColors.border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
      borderSide: BorderSide(color: borderFocus, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
      borderSide: const BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimensions.inputRadius),
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
    ),
    labelStyle: AppTextStyles.bodyMd,
    hintStyle: AppTextStyles.bodyMd.copyWith(color: AppColors.textDisabled),
    errorStyle: AppTextStyles.bodySm.copyWith(color: AppColors.error),
  );

  // ─── Card ────────────────────────────────────────────────
  static CardThemeData _cardTheme() => CardThemeData(
    color: AppColors.surface, // ← fixed: was warningLight
    elevation: AppDimensions.cardElevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.cardRadius),
    ),
    margin: EdgeInsets.zero,
  );

  // ─── Divider ─────────────────────────────────────────────
  static const DividerThemeData _dividerThemeData = DividerThemeData(
    color: AppColors.divider,
    thickness: 1,
    space: 1,
  );
  static DividerThemeData _dividerTheme() => _dividerThemeData;

  // ─── BottomNavigationBar ─────────────────────────────────
  static BottomNavigationBarThemeData _bottomNavTheme(Color primary) =>
      BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: primary,
        unselectedItemColor: AppColors.grey500,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: AppTextStyles.labelSm,
        unselectedLabelStyle: AppTextStyles.labelSm,
      );

  // ─── BottomSheet ─────────────────────────────────────────
  static BottomSheetThemeData _bottomSheetTheme() => const BottomSheetThemeData(
    backgroundColor: AppColors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppDimensions.bottomSheetRadius),
      ),
    ),
    elevation: 8,
    showDragHandle: true,
  );

  // ─── Chip ────────────────────────────────────────────────
  static ChipThemeData _chipTheme(Color primary) => ChipThemeData(
    backgroundColor: AppColors.grey100,
    selectedColor: primary.withOpacity(0.12),
    labelStyle: AppTextStyles.labelMd,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      side: const BorderSide(color: AppColors.border),
    ),
    padding: const EdgeInsets.symmetric(
      horizontal: AppDimensions.spaceMd,
      vertical: AppDimensions.spaceSm,
    ),
  );
}
