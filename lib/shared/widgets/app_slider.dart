import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Duration slider - as seen in booking screens "Duration 2h"
class AppDurationSlider extends StatelessWidget {
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double>? onChanged;
  final String Function(double)? labelBuilder;

  const AppDurationSlider({
    super.key,
    required this.value,
    this.min = 1,
    this.max = 8,
    this.divisions = 7,
    this.onChanged,
    this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final label = labelBuilder?.call(value) ??
        '${value.toStringAsFixed(0)}h';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Duration ', style: AppTextStyles.labelLg),
            Text(
              label,
              style: AppTextStyles.labelLg.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.grey200,
            thumbColor: AppColors.primary,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 10,
              elevation: 3,
            ),
            overlayColor: AppColors.primary.withOpacity(0.15),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

/// Price range slider
class AppPriceSlider extends StatelessWidget {
  final RangeValues values;
  final double min;
  final double max;
  final ValueChanged<RangeValues>? onChanged;
  final String currency;

  const AppPriceSlider({
    super.key,
    required this.values,
    this.min = 0,
    this.max = 100,
    this.onChanged,
    this.currency = '\$',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Price/hour', style: AppTextStyles.h4),
            Text(
              '$currency${values.start.toStringAsFixed(0)} - $currency${values.end.toStringAsFixed(0)}/Maximum',
              style: AppTextStyles.labelMd.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 4,
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.grey200,
            thumbColor: AppColors.primary,
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 10,
              elevation: 3,
            ),
            overlayColor: AppColors.primary.withOpacity(0.15),
          ),
          child: RangeSlider(
            values: values,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
