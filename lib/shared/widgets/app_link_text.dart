import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

class AppLinkText extends StatelessWidget {
  final String text;
  final List<AppTextLink> links;
  final TextAlign textAlign;

  /// Optional colors for customization
  final Color? textColor;
  final Color? linkColor;
  final FontWeight? linkFontWeight;
  final double? textSize;
  final TextDecoration? linkDecoration;

  const AppLinkText(
    this.text, {
    super.key,
    required this.links,
    this.textAlign = TextAlign.start,
    this.textColor,
    this.textSize,
    this.linkColor,
    this.linkFontWeight,
    this.linkDecoration,
  });

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = [];
    String remaining = text;

    for (final link in links) {
      final index = remaining.indexOf(link.label);

      if (index == -1) continue;

      // Add normal text before the link
      if (index > 0) {
        spans.add(
          TextSpan(
            text: remaining.substring(0, index),
            style: AppTextStyles.bodyMd.copyWith(
              fontSize: textSize,
              color: textColor ?? AppColors.textSecondary,
            ),
          ),
        );
      }

      // Add the link text
      spans.add(
        TextSpan(
          text: link.label,
          style: AppTextStyles.bodyMd.copyWith(
            color: linkColor ?? AppColors.primary,
            fontSize: textSize,
            fontWeight: linkFontWeight ?? FontWeight.w600,
            decoration: linkDecoration ?? TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()..onTap = link.onTap,
        ),
      );

      // Update remaining text
      remaining = remaining.substring(index + link.label.length);
    }

    // Add any remaining text after last link
    if (remaining.isNotEmpty) {
      spans.add(
        TextSpan(
          text: remaining,
          style: AppTextStyles.bodyMd.copyWith(
            fontSize: textSize,
            color: textColor ?? AppColors.textSecondary,
          ),
        ),
      );
    }

    return RichText(
      textAlign: textAlign,
      text: TextSpan(children: spans),
    );
  }
}

class AppTextLink {
  final String label;
  final VoidCallback onTap;

  AppTextLink({required this.label, required this.onTap});
}
