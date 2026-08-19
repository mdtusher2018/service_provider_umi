part of 'provider_profile_screen.dart';

// ─── Supporting widgets ───────────────────────────────────────

Widget _buildComments({required List<ProviderComment> comments}) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(vertical: 6),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.border),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.bodyLg('Comments', fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        12.verticalSpace,
        if (comments.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: AppText.bodyMd('No comments found', color: AppColors.textSecondary),
            ),
          )
        else
          ...comments.map((c) => _CommentTile(comment: c)),
      ],
    ),
  );
}

class _CommentTile extends ConsumerWidget {
  final ProviderComment comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = comment.createdAt ?? DateTime.now();
    return Padding(
      padding: 14.paddingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(imageUrl: comment.userImage, size: AvatarSize.sm),

              10.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      AppText.labelLg(comment.userName),
                      AppText.bodySm(".${time.toRelativeTime}"),
                    ],
                  ),
                  Row(
                    children: [
                      ...[
                        Stack(
                          alignment: AlignmentGeometry.center,
                          children: [
                            Icon(Icons.star, color: AppColors.black, size: 20),
                            Icon(Icons.star, color: AppColors.star, size: 16),
                          ],
                        ),
                        2.horizontalSpace,
                        AppText.bodySm(comment.rating.toFixedString(1)),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
          8.verticalSpace,
          AppText.bodyMd(comment.comment, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
