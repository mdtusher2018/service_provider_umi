part of 'provider_profile_screen.dart';

// ─── Supporting widgets ───────────────────────────────────────

Widget _buildComments({required List<ProviderComment> comments}) {
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
  final ProviderComment comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = DateTime.tryParse(comment.createdAt) ?? DateTime.now();
    return Padding(
      padding: 14.paddingBottom,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppAvatar(name: comment.userImage, size: AvatarSize.sm),

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
                      if (comment.userVerified) ...[
                        Icon(
                          Icons.verified_outlined,
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
          AppText.bodyMd(comment.comment, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}
