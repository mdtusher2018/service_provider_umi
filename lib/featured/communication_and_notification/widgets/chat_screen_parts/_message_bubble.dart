part of '../../screens/chat_screen.dart';

// part '../widgets/chat_screen_parts/_message_bubble.dart'

// ─── Message Bubble ───────────────────────────────────────────────────────────
class _MessageBubble extends ConsumerStatefulWidget {
  final ChatMessage message;
  final bool isMine;
  final String contactName;
  final String? contactImageUrl;

  // ── New fields ──────────────────────────────────────────────
  /// True while waiting for the server ack (optimistic bubble).
  final bool isPending;

  final bool isSeen;

  /// True if the server returned success:false or the socket timed out.
  final bool isFailed;

  /// Called when the user taps "Retry" on a failed bubble.
  final VoidCallback? onRetry;

  const _MessageBubble({
    required this.message,
    required this.isMine,
    required this.contactName,
    this.contactImageUrl,
    this.isPending = false,
    // ignore: unused_element_parameter
    this.isSeen = false,
    this.isFailed = false,
    this.onRetry,
  });

  @override
  ConsumerState<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends ConsumerState<_MessageBubble>
    with SingleTickerProviderStateMixin {
  // Slide-in animation for new bubbles
  late final AnimationController _animCtrl;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _slideAnim = Tween<Offset>(
      begin: Offset(widget.isMine ? 0.12 : -0.12, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Padding(
          padding: 8.paddingBottom,
          child: Row(
            mainAxisAlignment: widget.isMine
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Other person avatar
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
                  // ── Bubble + failed indicator row ──────────────
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Failed indicator (left of bubble for mine)
                      if (widget.isMine && widget.isFailed) ...[
                        _FailedIndicator(onRetry: widget.onRetry),
                        6.horizontalSpace,
                      ],

                      // ── Main bubble ───────────────────────────
                      Opacity(
                        opacity: widget.isPending ? 0.55 : 1.0,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: context.screenWidth * 0.68,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: widget.isFailed
                                ? AppColors.error.withOpacity(0.12)
                                : widget.isMine
                                ? AppColors.primaryFor(
                                    ref.watch(appRoleProvider),
                                  )
                                : AppColors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(18),
                              topRight: const Radius.circular(18),
                              bottomLeft: Radius.circular(
                                widget.isMine ? 18 : 4,
                              ),
                              bottomRight: Radius.circular(
                                widget.isMine ? 4 : 18,
                              ),
                            ),
                            border: widget.isFailed
                                ? Border.all(
                                    color: AppColors.error.withOpacity(0.4),
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: widget.isMine
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            spacing: 4,
                            children: [
                              // Message text
                              AppText.bodyMd(
                                widget.message.text,
                                color: widget.isFailed
                                    ? AppColors.error
                                    : widget.isMine
                                    ? AppColors.white
                                    : AppColors.textPrimary,
                              ),

                              // Timestamp + status icon row
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppText.bodyXs(
                                    widget.message.createdAt.toDisplayTime,
                                    color: widget.isMine
                                        ? AppColors.white.withOpacity(0.65)
                                        : AppColors.textgrey,
                                  ),
                                  if (widget.isMine) ...[
                                    4.horizontalSpace,
                                    _StatusIcon(
                                      status: widget.isFailed
                                          ? MessageStatus.failed
                                          : widget.isPending
                                          ? MessageStatus.sending
                                          : widget.isSeen
                                          ? MessageStatus.read
                                          : MessageStatus.delivered,
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  3.verticalSpace,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Failed indicator widget ──────────────────────────────────────────────────
class _FailedIndicator extends StatelessWidget {
  final VoidCallback? onRetry;
  const _FailedIndicator({this.onRetry});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRetry,
      child: Tooltip(
        message: 'Tap to retry',
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: AppColors.error,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.priority_high_rounded,
            size: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ─── Status icon ──────────────────────────────────────────────────────────────
class _StatusIcon extends StatelessWidget {
  final MessageStatus status;
  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      // Sending — animated pulsing clock
      case MessageStatus.sending:
        return _PulsingIcon(
          icon: Icons.access_time_rounded,
          size: 12,
          color: AppColors.white.withOpacity(0.65),
        );

      // Sent — single grey tick
      case MessageStatus.sent:
        return Icon(
          Icons.check_rounded,
          size: 12,
          color: AppColors.white.withOpacity(0.65),
        );

      // Delivered — double grey tick
      case MessageStatus.delivered:
        return Icon(
          Icons.done_all_rounded,
          size: 12,
          color: AppColors.white.withOpacity(0.65),
        );

      // Read / Seen — double tick in primary colour + subtle glow
      case MessageStatus.read:
        return Stack(
          alignment: Alignment.center,
          children: [
            // glow behind the icon
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.done_all_rounded,
              size: 13,
              color: AppColors.white, // white on primary bg looks clean
            ),
          ],
        );

      // Failed — small red X
      case MessageStatus.failed:
        return const Icon(
          Icons.close_rounded,
          size: 12,
          color: AppColors.error,
        );
    }
  }
}

// ─── Pulsing icon (used for "sending" state) ──────────────────────────────────
class _PulsingIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final Color color;
  const _PulsingIcon({
    required this.icon,
    required this.size,
    required this.color,
  });

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(
      begin: 0.35,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Icon(widget.icon, size: widget.size, color: widget.color),
    );
  }
}
