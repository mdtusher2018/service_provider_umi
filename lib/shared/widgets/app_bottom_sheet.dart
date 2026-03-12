import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_button.dart';

/// Show a styled bottom sheet
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  bool isDismissible = true,
  bool isScrollControlled = true,
  bool showDragHandle = true,
  String? title,
  VoidCallback? onClose,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isDismissible: isDismissible,
    isScrollControlled: isScrollControlled,
    backgroundColor: Colors.transparent,
    builder: (_) => AppBottomSheetContainer(
      title: title,
      showDragHandle: showDragHandle,
      onClose: onClose,
      child: child,
    ),
  );
}

class AppBottomSheetContainer extends StatelessWidget {
  final Widget child;
  final String? title;
  final bool showDragHandle;
  final VoidCallback? onClose;
  final EdgeInsetsGeometry? padding;

  const AppBottomSheetContainer({
    super.key,
    required this.child,
    this.title,
    this.showDragHandle = true,
    this.onClose,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showDragHandle)
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          if (title != null || onClose != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
              child: Row(
                children: [
                  if (title != null)
                    Expanded(child: Text(title!, style: AppTextStyles.h3)),
                  if (onClose != null)
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 22),
                      onPressed: onClose ?? () => Navigator.of(context).pop(),
                      color: AppColors.textSecondary,
                    ),
                ],
              ),
            ),
          Padding(
            padding: padding ?? const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Privacy policy / Cookie consent dialog - as seen in designs
class AppPrivacyDialog extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback? onClose;

  const AppPrivacyDialog({super.key, required this.onAccept, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Privacy Policy', style: AppTextStyles.h3),
                if (onClose != null)
                  GestureDetector(
                    onTap: onClose,
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.privacy_tip_outlined,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'We value your privacy',
              style: AppTextStyles.h3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Wabad uses cookies to analyse advertising campaign performance, improve app ads, and personalize the experience based on user preference.',
              style: AppTextStyles.bodyMd.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Privacy Policy',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 24),
            AppButton.primary(label: 'Accept', onPressed: onAccept),
          ],
        ),
      ),
    );
  }
}

/// "How does the service work?" FAQ dialog
class AppFaqBottomSheet extends StatelessWidget {
  final String title;
  final List<_FaqItem> items;
  final VoidCallback? onClose;

  const AppFaqBottomSheet({
    super.key,
    required this.title,
    required this.items,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetContainer(
      title: title,
      onClose: onClose ?? () => Navigator.of(context).pop(),
      child: Column(
        children: items
            .map(
              (item) => _FaqTile(question: item.question, answer: item.answer),
            )
            .toList(),
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem(this.question, this.answer);
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String? answer;
  const _FaqTile({required this.question, this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(widget.question, style: AppTextStyles.labelLg),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_right_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
              ],
            ),
            if (_expanded && widget.answer != null) ...[
              const SizedBox(height: 8),
              Text(
                widget.answer!,
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
