import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
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
      padding: EdgeInsets.only(bottom: context.keyboardHeight),
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
                  borderRadius: 2.circular,
                ),
              ),
            ),
          if (title != null || onClose != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 0),
              child: Row(
                children: [
                  if (title != null) Expanded(child: AppText.h3(title!)),
                  if (onClose != null)
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 22),
                      onPressed: onClose ?? () => context.pop(),
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
      shape: RoundedRectangleBorder(borderRadius: 20.circular),
      child: Padding(
        padding: 24.paddingAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.h3('Privacy Policy'),
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
            20.verticalSpace,
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
            16.verticalSpace,
            AppText.h3('We value your privacy', textAlign: TextAlign.center),
            8.verticalSpace,
            AppText.bodyMd(
              'Wabad uses cookies to analyse advertising campaign performance, improve app ads, and personalize the experience based on user preference.',

              color: AppColors.textSecondary,

              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            GestureDetector(
              onTap: () {},
              child: AppText(
                'Privacy Policy',
                style: AppTextStyles.bodyMd.copyWith(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.primary,
                ),
              ),
            ),
            24.verticalSpace,
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
      onClose: onClose ?? () => context.pop(),
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
        padding: 12.paddingV,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: AppText.labelLg(widget.question)),
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
              8.verticalSpace,
              AppText.bodyMd(widget.answer!, color: AppColors.textSecondary),
            ],
          ],
        ),
      ),
    );
  }
}
