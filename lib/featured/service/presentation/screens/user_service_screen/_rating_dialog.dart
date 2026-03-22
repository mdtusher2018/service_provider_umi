part of 'user_service_screen.dart';

// ─── Rating Dialog ────────────────────────────────────────────
class RatingDialog extends StatefulWidget {
  final String serviceName;
  final void Function(int rating, List<String> tags, String comment) onSubmit;

  const RatingDialog({
    super.key,
    required this.serviceName,
    required this.onSubmit,
  });

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _rating = 5;
  final Set<String> _selectedTags = {'Overall Service', 'Repair Quality'};
  final _commentController = TextEditingController(text: 'Nice work');

  static const _tags = [
    'Overall Service',
    'Customer Support',
    'Speed and Efficiency',
    'Repair Quality',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ─────────────────────────────
            Row(
              children: [
                const Expanded(child: AppText.h3('Rate Your Experience')),
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
                    padding: const EdgeInsets.symmetric(horizontal: 4),
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
            10.verticalSpace,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _tags.map((tag) {
                final isSelected = _selectedTags.contains(tag);
                return GestureDetector(
                  onTap: () => setState(() {
                    isSelected
                        ? _selectedTags.remove(tag)
                        : _selectedTags.add(tag);
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: AppText.labelMd(
                      tag,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            16.verticalSpace,

            // ─── Comment box ─────────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
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
                  contentPadding: const EdgeInsets.all(14),
                ),
              ),
            ),
            20.verticalSpace,

            // ─── Submit ──────────────────────────────
            AppButton.primary(
              label: 'Submit',
              onPressed: () => widget.onSubmit(
                _rating,
                _selectedTags.toList(),
                _commentController.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
