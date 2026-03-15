import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// A unified text widget that wraps all app text styles.
/// Usage: AppText.h1('Hello'), AppText.bodyMd('Description')
class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final double? letterSpacing;
  final double? height;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextDecoration? decoration;

  const AppText(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap,
    this.letterSpacing,
    this.height,
    this.fontWeight,
    this.fontSize,
    this.decoration,
  });

  // ─── Named Constructors ──────────────────────────────────
  const AppText.display(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.softWrap, this.fontWeight, this.fontSize, this.decoration, this.letterSpacing, this.height})
      : style = AppTextStyles.display;

  const AppText.h1(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.softWrap, this.fontWeight, this.fontSize, this.decoration, this.letterSpacing, this.height})
      : style = AppTextStyles.h1;

  const AppText.h2(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.softWrap, this.fontWeight, this.fontSize, this.decoration, this.letterSpacing, this.height})
      : style = AppTextStyles.h2;

  const AppText.h3(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.softWrap, this.fontWeight, this.fontSize, this.decoration, this.letterSpacing, this.height})
      : style = AppTextStyles.h3;

  const AppText.h4(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.softWrap, this.fontWeight, this.fontSize, this.decoration, this.letterSpacing, this.height})
      : style = AppTextStyles.h4;

  const AppText.bodyLg(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.softWrap, this.fontWeight, this.fontSize, this.decoration, this.letterSpacing, this.height})
      : style = AppTextStyles.bodyLg;

  const AppText.bodyMd(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.softWrap, this.fontWeight, this.fontSize, this.decoration, this.letterSpacing, this.height})
      : style = AppTextStyles.bodyMd;

  const AppText.bodySm(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.softWrap, this.fontWeight, this.fontSize, this.decoration, this.letterSpacing, this.height})
      : style = AppTextStyles.bodySm;

  const AppText.bodyXs(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.softWrap, this.fontWeight, this.fontSize, this.decoration, this.letterSpacing, this.height})
      : style = AppTextStyles.bodyXs;

  const AppText.labelLg(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.softWrap, this.fontWeight, this.fontSize, this.decoration, this.letterSpacing, this.height})
      : style = AppTextStyles.labelLg;

  const AppText.labelMd(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.softWrap, this.fontWeight, this.fontSize, this.decoration, this.letterSpacing, this.height})
      : style = AppTextStyles.labelMd;

  const AppText.labelSm(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.softWrap, this.fontWeight, this.fontSize, this.decoration, this.letterSpacing, this.height})
      : style = AppTextStyles.labelSm;

  const AppText.price(this.text, {super.key, this.color, this.textAlign, this.maxLines, this.overflow, this.softWrap, this.fontWeight, this.fontSize, this.decoration, this.letterSpacing, this.height})
      : style = AppTextStyles.price;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow ?? (maxLines != null ? TextOverflow.ellipsis : null),
      softWrap: softWrap,
      style: (style ?? AppTextStyles.bodyMd).copyWith(
        color: color,
        letterSpacing: letterSpacing,
        height: height,
        fontWeight: fontWeight,
        fontSize: fontSize,
        decoration: decoration,
        decorationColor: color,
      ),
    );
  }
}

/// Highlighted text with teal color
class AppTextHighlight extends StatelessWidget {
  final String text;
  final TextStyle? baseStyle;

  const AppTextHighlight(this.text, {super.key, this.baseStyle});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: (baseStyle ?? AppTextStyles.bodyMd).copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
