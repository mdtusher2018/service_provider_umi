// import 'package:flutter/material.dart';
// import 'package:service_provider_umi/core/theme/app_colors.dart';
// import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
// import 'package:service_provider_umi/shared/widgets/app_text.dart';

// extension BuildContextExtensions on BuildContext {
//   // ─── Theme ───────────────────────────────────────────────
//   ThemeData get theme => Theme.of(this);
//   ColorScheme get colorScheme => Theme.of(this).colorScheme;
//   TextTheme get textTheme => Theme.of(this).textTheme;
//   bool get isDark => Theme.of(this).brightness == Brightness.dark;

//   // ─── Media Query ─────────────────────────────────────────
//   MediaQueryData get mediaQuery => MediaQuery.of(this);
//   Size get screenSize => MediaQuery.of(this).size;
//   double get screenWidth => MediaQuery.of(this).size.width;
//   double get screenHeight => MediaQuery.of(this).size.height;
//   double get statusBarHeight => MediaQuery.of(this).padding.top;
//   double get bottomPadding => MediaQuery.of(this).padding.bottom;
//   double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;
//   bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;

//   // ─── Responsive ──────────────────────────────────────────
//   bool get isSmallScreen => screenWidth < 360;
//   bool get isMediumScreen => screenWidth >= 360 && screenWidth < 768;
//   bool get isLargeScreen => screenWidth >= 768;
//   bool get isTablet => screenWidth >= 600;

//   // ─── Navigation ──────────────────────────────────────────

//   // ─── Snackbar ────────────────────────────────────────────
//   void showSnackBar(
//     String message, {
//     bool isError = false,
//     Duration duration = const Duration(seconds: 3),
//   }) {
//     ScaffoldMessenger.of(this).hideCurrentSnackBar();
//     ScaffoldMessenger.of(this).showSnackBar(
//       SnackBar(
//         content: AppText(message, color: AppColors.white),
//         backgroundColor: isError ? colorScheme.error : colorScheme.primary,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: 10.circular),
//         duration: duration,
//       ),
//     );
//   }

//   void showSuccessSnackBar(String message) =>
//       showSnackBar(message, isError: false);

//   void showErrorSnackBar(String message) =>
//       showSnackBar(message, isError: true);

//   // ─── Localization ────────────────────────────────────────
//   // Uncomment once generated:
//   // AppLocalizations get l10n => AppLocalizations.of(this)!;
// }

import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';

extension BuildContextExtensions on BuildContext {
  // ─── Theme ───────────────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // ─── Media Query ─────────────────────────────────────────
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => MediaQuery.of(this).size;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;

  // ─── Web-safe screen dimensions ──────────────────────────
  // On web, MediaQuery inside the WebAppShell already reports the clamped
  // container size (430 × 860), so these are always "phone-sized" inside
  // the app container. Outside the container (WebsiteBody / WebsiteFooter)
  // they report the real browser width — which is correct for those widgets.
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // ─── Responsive ──────────────────────────────────────────
  // These now work correctly on web because MediaQuery is overridden
  // inside the container to report clamped phone dimensions.
  bool get isSmallScreen => screenWidth < 360;
  bool get isMediumScreen => screenWidth >= 360 && screenWidth < 768;
  bool get isLargeScreen => screenWidth >= 768;
  bool get isTablet => screenWidth >= 600;

  // ─── Snackbar ────────────────────────────────────────────
  void showSnackBar(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
    bool showAtTop = false,
  }) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: AppText(message, color: AppColors.white),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: 10.circular),
        duration: duration,
        margin: showAtTop
            ? EdgeInsets.only(
                bottom: MediaQuery.of(this).size.height -
                    (MediaQuery.of(this).padding.top + 80),
                left: 16,
                right: 16,
              )
            : null,
      ),
    );
  }

  void showSuccessSnackBar(String message) =>
      showSnackBar(message, isError: false,);
  void showErrorSnackBar(String message) =>
      showSnackBar(message, isError: true,);

  void showLoader() {
    showDialog(
      context: this,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (_) => const LoaderDialog(),
    );
  }

  void hideLoader() {
    if (Navigator.of(this, rootNavigator: true).canPop()) {
      Navigator.of(this, rootNavigator: true).pop();
    }
  }

  // ─── Localization ────────────────────────────────────────
  // Uncomment once generated:
  // AppLocalizations get l10n => AppLocalizations.of(this)!;
}
