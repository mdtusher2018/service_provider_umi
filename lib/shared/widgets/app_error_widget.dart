import 'package:flutter/material.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';

class AppErrorWidget extends StatelessWidget {
  final Object? error;
  final VoidCallback onRetry;
  final String? customMessage;

  const AppErrorWidget({
    super.key,
    this.error,
    required this.onRetry,
    this.customMessage,
  });

  @override
  Widget build(BuildContext context) {
    String errorMessage = customMessage ?? 'Something went wrong';

    if (error != null && customMessage == null) {
      final errorString = error.toString();
      if (errorString.contains('Failure.timeout')) {
        errorMessage = 'Request timed out. Please try again.';
      } else if (errorString.contains('SocketException') || errorString.contains('NetworkException')) {
        errorMessage = 'No internet connection. Please check your network and try again.';
      } else if (errorString.length < 100) {
        errorMessage = errorString;
      }
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 48,
            ),
            const SizedBox(height: 16),
            AppText.bodyLg(
              errorMessage,
              textAlign: TextAlign.center,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            AppButton(
              onPressed: onRetry,
              label: 'Try Again',
              width: 140,
              variant: AppButtonVariant.outline,
            ),
          ],
        ),
      ),
    );
  }
}
