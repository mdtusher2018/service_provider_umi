import 'package:flutter/material.dart';

extension NumExtensions on num {
  // ─── SizedBox Shortcuts ──────────────────────────────────
  SizedBox get verticalSpace => SizedBox(height: toDouble());
  SizedBox get horizontalSpace => SizedBox(width: toDouble());

  // ─── BorderRadius ────────────────────────────────────────
  BorderRadius get circular => BorderRadius.circular(toDouble());

  // ─── EdgeInsets ──────────────────────────────────────────
  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());
  EdgeInsets get paddingH => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get paddingV => EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get paddingTop => EdgeInsets.only(top: toDouble());
  EdgeInsets get paddingBottom => EdgeInsets.only(bottom: toDouble());
  EdgeInsets get paddingLeft => EdgeInsets.only(left: toDouble());
  EdgeInsets get paddingRight => EdgeInsets.only(right: toDouble());

  // ─── Radius ──────────────────────────────────────────────
  Radius get radius => Radius.circular(toDouble());

  // ─── Duration ────────────────────────────────────────────
  Duration get milliseconds => Duration(milliseconds: toInt());
  Duration get seconds => Duration(seconds: toInt());
  Duration get minutes => Duration(minutes: toInt());

  // ─── Utils ───────────────────────────────────────────────
  bool get isPositive => this > 0;
  bool get isNegative => this < 0;
  bool get isZero => this == 0;

  double clampBetween(double min, double max) => clamp(min, max).toDouble();

  double get toRad => this * (3.14159265358979323846 / 180);
  double get toDeg => this * (180 / 3.14159265358979323846);
}

extension IntExtensions on int {
  String get padLeft2 => toString().padLeft(2, '0');
  String get formatCount {
    if (this >= 1000000) return '${(this / 1000000).toStringAsFixed(1)}M';
    if (this >= 1000) return '${(this / 1000).toStringAsFixed(1)}K';
    return toString();
  }
}

extension DoubleExtensions on double {
  String toFixedString(int decimals) => toStringAsFixed(decimals);
  bool get isInteger => this == truncateToDouble();
}
