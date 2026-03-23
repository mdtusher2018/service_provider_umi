part of 'provider_profile_screen.dart';

// ─── Supporting widgets ───────────────────────────────────────

Widget _buildComments({required List<_CommentData> comments}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      AppText.h3('Comments'),
      12.verticalSpace,
      ...comments.map((c) => _CommentTile(comment: c)),
    ],
  );
}

class _CommentTile extends ConsumerWidget {
  final _CommentData comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(name: comment.author, size: AvatarSize.sm),

              10.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText.labelLg(comment.author),
                  Row(
                    children: [
                      AppText.bodySm(comment.timeAgo),
                      if (comment.isVerified) ...[
                        6.horizontalSpace,
                        Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.primaryFor(
                            ref.watch(appRoleProvider),
                          ),
                          size: 12,
                        ),
                        2.horizontalSpace,
                        AppText.bodySm(
                          'Verified service',
                          color: AppColors.primaryFor(
                            ref.watch(appRoleProvider),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
          8.verticalSpace,
          AppText.bodyMd(comment.text, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
