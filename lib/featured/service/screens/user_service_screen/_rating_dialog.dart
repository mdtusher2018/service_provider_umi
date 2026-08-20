part of 'user_service_screen.dart';


// ─── Rating Dialog ────────────────────────────────────────────
class RatingDialog extends ConsumerStatefulWidget {
  final String providerId;
  final void Function() onSubmit;

  const RatingDialog({
    super.key,
    required this.providerId,
    required this.onSubmit,
  });

  @override
  ConsumerState<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends ConsumerState<RatingDialog> {
  int _rating = 5;
  // final Set<String> _selectedTags = {'Overall Service', 'Repair Quality'};
  final _commentController = TextEditingController(text: 'Nice work');

  // static const _tags = [
  //   'Overall Service',
  //   'Customer Support',
  //   'Speed and Efficiency',
  //   'Repair Quality',
  // ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(giveReviewProvider, (previous, next) {
      if (previous?.isLoading == true && next.isLoading == false) {
        if (next.hasError) {
          AppLogger.error("Failed to submit review: ${next.error}");
          context.showErrorSnackBar(AppLocalizations.of(context)!.failedToSubmitReview);
        } else {
          context.showSuccessSnackBar(AppLocalizations.of(context)!.reviewSubmittedSuccessfully);
        }
      }
    });

    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: 20.circular),
      insetPadding: 24.paddingH,
      child: Padding(
        padding: 20.paddingAll,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ─────────────────────────────
            Row(
              children: [
                Expanded(child: AppText.h3(AppLocalizations.of(context)!.rateYourExperience)),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.close_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ],
            ),
            6.verticalSpace,
            AppText.bodySm(
              'Are you Satisfied with the service?',
              color: AppColors.textSecondary,
            ),
            16.verticalSpace,

            // ─── Stars ──────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _rating = i + 1),
                  child: Padding(
                    padding: 4.paddingH,
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        i < _rating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        key: ValueKey('$i-${i < _rating}'),
                        color: AppColors.primary,
                        size: 38,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const AppDivider(height: 20),
            10.verticalSpace,

            // ─── Tags ────────────────────────────────
            AppText.labelLg(
              'Tell us what can be Improved?',
              color: AppColors.textPrimary,
            ),
            // 10.verticalSpace,
            // Wrap(
            //   spacing: 8,
            //   runSpacing: 8,
            //   children: _tags.map((tag) {
            //     final isSelected = _selectedTags.contains(tag);
            //     return GestureDetector(
            //       onTap: () => setState(() {
            //         isSelected
            //             ? _selectedTags.remove(tag)
            //             : _selectedTags.add(tag);
            //       }),
            //       child: AnimatedContainer(
            //         duration: const Duration(milliseconds: 180),
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 14,
            //           vertical: 8,
            //         ),
            //         decoration: BoxDecoration(
            //           color: isSelected ? AppColors.primary : AppColors.white,
            //           borderRadius: 20.circular,
            //           border: Border.all(
            //             color: isSelected
            //                 ? AppColors.primary
            //                 : AppColors.border,
            //             width: 1.5,
            //           ),
            //         ),
            //         child: AppText.labelMd(
            //           tag,
            //           color: isSelected
            //               ? AppColors.white
            //               : AppColors.textPrimary,
            //           fontWeight: FontWeight.w500,
            //         ),
            //       ),
            //     );
            //   }).toList(),
            // ),
            16.verticalSpace,

            // ─── Comment box ─────────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: 12.circular,
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _commentController,
                maxLines: 4,
                style: AppTextStyles.bodyMd,
                decoration: InputDecoration(
                  hintText: 'Write your comment...',
                  hintStyle: AppTextStyles.bodyMd.copyWith(
                    color: AppColors.textgrey,
                  ),
                  border: InputBorder.none,
                  contentPadding: 14.paddingAll,
                ),
              ),
            ),
            20.verticalSpace,

            // ─── Submit ──────────────────────────────
            AppButton.primary(
              label: 'Submit',
              isLoading: ref.watch(giveReviewProvider).isLoading,
              onPressed: () async {
                await ref
                    .read(giveReviewProvider.notifier)
                    .giveReview(
                      widget.providerId,

                      _commentController.text,
                      _rating.toDouble(),
                    );
                widget.onSubmit();
              },
            ),
          ],
        ),
      ),
    );
  }
}
