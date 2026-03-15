import 'package:flutter/material.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';

// ─── Block User Dialog ────────────────────────────────────────
class BlockUserDialog extends StatelessWidget {
  final String userName;
  final VoidCallback onBlock;
  final VoidCallback onCancel;

  const BlockUserDialog({
    super.key,
    required this.userName,
    required this.onBlock,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),

            // Title
            AppText.h3(
              'Are you sure you want to\nBlock this User?',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            // Yes, Block
            AppButton.primary(label: 'Yes, Block', onPressed: onBlock),
            const SizedBox(height: 10),

            // No, Don't Block
            AppButton.ghost(
              label: "No, Don't Block",
              onPressed: onCancel,
              isFullWidth: true,
            ),
          ],
        ),
      ),
    );
  }
}
