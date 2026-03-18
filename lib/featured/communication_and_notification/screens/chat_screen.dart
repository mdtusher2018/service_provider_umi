import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/utils/extensions/datetime_ext.dart';
import 'package:service_provider_umi/featured/communication_and_notification/screens/audio_call_screen.dart';
import 'package:service_provider_umi/featured/communication_and_notification/screens/video_call_screen.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
import '../widgets/block_dialog.dart';

// ─── Models ───────────────────────────────────────────────────
enum MessageStatus { sending, sent, delivered, read }

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;
  final MessageStatus status;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.status = MessageStatus.sent,
  });

  ChatMessage copyWith({MessageStatus? status}) => ChatMessage(
    id: id,
    senderId: senderId,
    text: text,
    timestamp: timestamp,
    status: status ?? this.status,
  );
}

// ─── Mock seed data ───────────────────────────────────────────
const _kMyId = 'me';

final _mockMessages = <ChatMessage>[
  ChatMessage(
    id: '1',
    senderId: 'other',
    text: 'Hello',
    timestamp: DateTime(2025, 1, 1, 13, 5),
    status: MessageStatus.read,
  ),
  ChatMessage(
    id: '2',
    senderId: _kMyId,
    text: 'Hello',
    timestamp: DateTime(2025, 1, 1, 13, 5),
    status: MessageStatus.read,
  ),
  ChatMessage(
    id: '3',
    senderId: 'other',
    text: 'How can we help you',
    timestamp: DateTime(2025, 1, 1, 13, 6),
    status: MessageStatus.read,
  ),
  ChatMessage(
    id: '4',
    senderId: _kMyId,
    text: 'I need a emergency appointment.... are you available now...',
    timestamp: DateTime(2025, 1, 1, 13, 7),
    status: MessageStatus.read,
  ),
  ChatMessage(
    id: '5',
    senderId: 'other',
    text:
        'Yes we are available for you.. at first book an appointment and come, you can use google map also if you have any problem.',
    timestamp: DateTime(2025, 1, 1, 13, 21),
    status: MessageStatus.read,
  ),
  ChatMessage(
    id: '1',
    senderId: 'other',
    text: 'Hello',
    timestamp: DateTime(2025, 1, 1, 13, 5),
    status: MessageStatus.read,
  ),
  ChatMessage(
    id: '2',
    senderId: _kMyId,
    text: 'Hello',
    timestamp: DateTime(2025, 1, 1, 13, 5),
    status: MessageStatus.read,
  ),
  ChatMessage(
    id: '3',
    senderId: 'other',
    text: 'How can we help you',
    timestamp: DateTime(2025, 1, 1, 13, 6),
    status: MessageStatus.read,
  ),
  ChatMessage(
    id: '4',
    senderId: _kMyId,
    text: 'I need a emergency appointment.... are you available now...',
    timestamp: DateTime(2025, 1, 1, 13, 7),
    status: MessageStatus.read,
  ),
  ChatMessage(
    id: '5',
    senderId: 'other',
    text:
        'Yes we are available for you.. at first book an appointment and come, you can use google map also if you have any problem.',
    timestamp: DateTime(2025, 1, 1, 13, 21),
    status: MessageStatus.read,
  ),
];

// ─── Screen ───────────────────────────────────────────────────
class ChatScreen extends StatefulWidget {
  final String contactId;
  final String contactName;
  final String? contactImageUrl;

  const ChatScreen({
    super.key,
    required this.contactId,
    required this.contactName,
    this.contactImageUrl,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final List<ChatMessage> _messages = List.from(_mockMessages);
  bool _isSending = false;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ─── Send message (local state only) ──────────────────────
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    final newMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: _kMyId,
      text: text,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
    );

    setState(() {
      _isSending = true;
      _messages.add(newMsg);
      _messageController.clear();
    });

    _scrollToBottom();

    // Simulate network delivery
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        final idx = _messages.indexWhere((m) => m.id == newMsg.id);
        if (idx != -1) {
          _messages[idx] = _messages[idx].copyWith(
            status: MessageStatus.delivered,
          );
        }
        _isSending = false;
      });
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ─── Overlay actions ──────────────────────────────────────
  void _showOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ChatOptionsSheet(
        onBlock: () {
          Navigator.of(context).pop();
          _showBlockDialog();
        },
      ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (_) => BlockUserDialog(
        userName: widget.contactName,
        onBlock: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _showCallOptions() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (_) => _CallOptionDialog(
        contactName: widget.contactName,
        contactImageUrl: widget.contactImageUrl,
        onCall: () {
          Navigator.of(context).pop();
          _startAudioCall();
        },
        onMessage: () => Navigator.of(context).pop(),
      ),
    );
  }

  void _startAudioCall() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AudioCallScreen(
          contactId: widget.contactId,
          contactName: widget.contactName,
          contactImageUrl: widget.contactImageUrl,
          isIncoming: false,
        ),
      ),
    );
  }

  void _startVideoCall() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VideoCallScreen(
          contactId: widget.contactId,
          contactName: widget.contactName,
          contactImageUrl: widget.contactImageUrl,
          isIncoming: false,
        ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),

          _buildInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_rounded,
          color: AppColors.textPrimary,
          size: 18,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: GestureDetector(
        onTap: _showCallOptions,
        child: Row(
          children: [
            AppAvatar(
              name: widget.contactName,
              imageUrl: widget.contactImageUrl,
              size: AvatarSize.sm,
            ),
            const SizedBox(width: 10),
            AppText.labelLg(widget.contactName),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.call_outlined,
            color: AppColors.textPrimary,
            size: 22,
          ),
          onPressed: _startAudioCall,
        ),
        IconButton(
          icon: const Icon(
            Icons.videocam_outlined,
            color: AppColors.textPrimary,
            size: 22,
          ),
          onPressed: _startVideoCall,
        ),
        IconButton(
          icon: const Icon(
            Icons.more_vert_rounded,
            color: AppColors.textPrimary,
            size: 22,
          ),
          onPressed: _showOptions,
        ),
      ],
    );
  }

  Widget _buildMessageList() {
    // Group by date
    final grouped = <String, List<ChatMessage>>{};
    for (final m in _messages) {
      final key = DateFormat('d MMM yyyy').format(m.timestamp);
      grouped.putIfAbsent(key, () => []).add(m);
    }
    final keys = grouped.keys.toList();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      itemCount: keys.length,
      itemBuilder: (_, i) {
        final date = keys[i];
        final msgs = grouped[date]!;
        return Column(
          children: [
            // Date separator
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  const Expanded(child: AppDivider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: AppText.bodyXs(
                      date == DateFormat('d MMM yyyy').format(DateTime.now())
                          ? 'Today'
                          : date,
                    ),
                  ),
                  const Expanded(child: AppDivider()),
                ],
              ),
            ),
            ...msgs.map(
              (msg) => _MessageBubble(
                message: msg,
                isMine: msg.senderId == _kMyId,
                contactName: widget.contactName,
                contactImageUrl: widget.contactImageUrl,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 12,
        top: 10,
        bottom:
            MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom +
            10,
      ),
      decoration: BoxDecoration(
        border: const Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              hint: "Message",
              borderRadious: 100,

              suffixIcon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grey200,
                ),
                child: Icon(Icons.image_outlined),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: _isSending
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.white,
                      ),
                    )
                  : const Icon(
                      Icons.send_rounded,
                      color: AppColors.white,
                      size: 18,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

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
      padding: const EdgeInsets.only(bottom: 8),
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
            const SizedBox(width: 8),
          ],
          Column(
            crossAxisAlignment: widget.isMine
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.68,
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
                          const SizedBox(width: 4),
                          _StatusIcon(status: widget.message.status),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
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

// ─── Call Option Dialog ───────────────────────────────────────
class _CallOptionDialog extends StatelessWidget {
  final String contactName;
  final String? contactImageUrl;
  final VoidCallback onCall;
  final VoidCallback onMessage;

  const _CallOptionDialog({
    required this.contactName,
    this.contactImageUrl,
    required this.onCall,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText.h3('Choose option'),
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
            const SizedBox(height: 16),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.grey100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: AppAvatar(
                  name: contactName,
                  imageUrl: contactImageUrl,
                  size: AvatarSize.lg,
                ),
              ),
            ),
            const SizedBox(height: 16),
            AppButton.primary(label: '📞  Call', onPressed: onCall),
            const SizedBox(height: 10),
            AppButton.outline(label: '💬  Message', onPressed: onMessage),
          ],
        ),
      ),
    );
  }
}

// ─── Chat Options Sheet ───────────────────────────────────────
class ChatOptionsSheet extends StatelessWidget {
  final VoidCallback onBlock;

  const ChatOptionsSheet({super.key, required this.onBlock});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText.h3("Settings"),

          _OptionTile(
            icon: Icons.block_rounded,
            label: 'Block user',
            color: AppColors.error,
            onTap: onBlock,
          ),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.label,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: color ?? AppColors.textPrimary),
      title: AppText.bodyLg(label, color: color ?? AppColors.textPrimary),
      contentPadding: EdgeInsets.zero,
    );
  }
}
