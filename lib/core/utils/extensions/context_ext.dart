import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  // ─── Theme ───────────────────────────────────────────────
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // ─── Media Query ─────────────────────────────────────────
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  double get statusBarHeight => MediaQuery.of(this).padding.top;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;
  bool get isKeyboardVisible => MediaQuery.of(this).viewInsets.bottom > 0;

  // ─── Responsive ──────────────────────────────────────────
  bool get isSmallScreen => screenWidth < 360;
  bool get isMediumScreen => screenWidth >= 360 && screenWidth < 768;
  bool get isLargeScreen => screenWidth >= 768;
  bool get isTablet => screenWidth >= 600;

  // ─── Navigation ──────────────────────────────────────────
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
  bool canPop() => Navigator.of(this).canPop();

  Future<T?> push<T>(Widget screen) =>
      Navigator.of(this).push<T>(MaterialPageRoute(builder: (_) => screen));

  Future<T?> pushReplacement<T>(Widget screen) => Navigator.of(
    this,
  ).pushReplacement<T, T>(MaterialPageRoute(builder: (_) => screen));

  // ─── Snackbar ────────────────────────────────────────────
  void showSnackBar(
    String message, {
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: duration,
      ),
    );
  }

  void showSuccessSnackBar(String message) =>
      showSnackBar(message, isError: false);

  void showErrorSnackBar(String message) =>
      showSnackBar(message, isError: true);

  // ─── Focus ───────────────────────────────────────────────
  void unfocus() => FocusScope.of(this).unfocus();
  void requestFocus(FocusNode node) => FocusScope.of(this).requestFocus(node);

  // ─── Localization ────────────────────────────────────────
  // Uncomment once generated:
  // AppLocalizations get l10n => AppLocalizations.of(this)!;
}
