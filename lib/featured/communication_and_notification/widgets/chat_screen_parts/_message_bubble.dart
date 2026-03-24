part of '../../screens/chat_screen.dart';

// ─── Message Bubble ───────────────────────────────────────────
class _MessageBubble extends ConsumerStatefulWidget {
  final ChatMessage message;
  final bool isMine;
  final String contactName;
  final String? contactImageUrl;

  const _MessageBubble({
    required this.message,
    required this.isMine,
    required this.contactName,
    this.contactImageUrl,
  });

  @override
  ConsumerState<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends ConsumerState<_MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: 8.paddingBottom,
      child: Row(
        mainAxisAlignment: widget.isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!widget.isMine) ...[
            AppAvatar(
              name: widget.contactName,
              imageUrl: widget.contactImageUrl,
              size: AvatarSize.xs,
            ),
            8.horizontalSpace,
          ],
          Column(
            crossAxisAlignment: widget.isMine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: context.screenWidth * 0.68,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: widget.isMine
                      ? AppColors.primaryFor(ref.watch(appRoleProvider))
                      : AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(widget.isMine ? 18 : 4),
                    bottomRight: Radius.circular(widget.isMine ? 4 : 18),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: widget.isMine
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,

                  spacing: 4,
                  children: [
                    AppText.bodyMd(
                      widget.message.text,
                      color: widget.isMine
                          ? AppColors.white
                          : AppColors.textPrimary,
                    ),

                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText.bodyXs(
                          widget.message.timestamp.toDisplayTime,
                          color: AppColors.textgrey,
                        ),
                        if (widget.isMine) ...[
                          4.horizontalSpace,
                          _StatusIcon(status: widget.message.status),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              3.verticalSpace,
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  final MessageStatus status;
  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageStatus.sending:
        return const Icon(
          Icons.access_time_rounded,
          size: 12,
          color: AppColors.grey400,
        );
      case MessageStatus.sent:
        return const Icon(
          Icons.check_rounded,
          size: 12,
          color: AppColors.grey400,
        );
      case MessageStatus.delivered:
        return const Icon(
          Icons.done_all_rounded,
          size: 12,
          color: AppColors.grey400,
        );
      case MessageStatus.read:
        return const Icon(
          Icons.done_all_rounded,
          size: 12,
          color: AppColors.primary,
        );
    }
  }
}
