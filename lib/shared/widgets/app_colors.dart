import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Brand ───────────────────────────────────────────────
  static const Color primary = Color(0xFF00C0B5); // Teal/Cyan - main CTA
  static const Color primaryLight = Color(0xFFE0F7F4); // Light teal background
  static const Color primarySurface = Color(0xFFF0FFFE);

  static const Color secondary = Color(0xFF1C3E64);
  static const Color secondaryLight = Color(0xFF2C4263);

  static const Color accent = Color(0xFFFF6B6B); // Red accent (logo)

  // ─── Neutrals ────────────────────────────────────────────
  static const Color black = Color(0xFF0D0D0D);
  static const Color grey900 = Color(0xFF1C1C1E);
  static const Color grey800 = Color(0xFF3A3A3C);
  static const Color grey700 = Color(0xFF48484A);
  static const Color grey600 = Color(0xFF636366);
  static const Color grey500 = Color(0xFF8E8E93);
  static const Color grey400 = Color(0xFFAEAEB2);
  static const Color grey300 = Color(0xFFC7C7CC);
  static const Color grey200 = Color(0xFFE5E5EA);
  static const Color grey100 = Color(0xFFF2F2F7);
  static const Color grey50 = Color(0xFFF8F8FA);
  static const Color white = Color(0xFFFFFFFF);

  // ─── Semantic ────────────────────────────────────────────
  static const Color success = Color(0xFF34C759);
  static const Color successLight = Color(0xFFD4F5DC);
  static const Color warning = Color(0xFFFF9500);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color error = Color(0xFFFF3B30);
  static const Color errorLight = Color(0xFFFFE5E5);
  static const Color info = Color(0xFF007AFF);
  static const Color infoLight = Color(0xFFE5F0FF);

  // ─── Star / Rating ───────────────────────────────────────
  static const Color star = Color(0xFFFFCC00);
  static const Color starEmpty = Color(0xFFE5E5EA);

  // ─── Background ──────────────────────────────────────────
  static const Color background = Color(0xFFF2F2F2);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color shimmer = Color(0xFFE8E8E8);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ─── Text ────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0D0D0D);
  static const Color textSecondary = Color(0xFF1C3E64);
  static const Color textgrey = Color(0xFF00BFA5);
  static const Color textHint = Color(0xFF0D0D0D);
  static const Color textDisabled = Color(0xFFC7C7CC);

  // ─── Border ──────────────────────────────────────────────
  static const Color border = Color(0xFFE5E5EA);
  static const Color borderFocus = Color(0xFF00BFA5);
  static const Color divider = Colors.black45;

  // ─── Map / Location ──────────────────────────────────────

  // ─── Gradients ───────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00D4BC), Color(0xFF00BFA5)],
  );

  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFF0FFFE)],
  );
}
