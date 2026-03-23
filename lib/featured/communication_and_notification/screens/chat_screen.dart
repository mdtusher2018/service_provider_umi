import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/utils/extensions/datetime_ext.dart';
import 'package:service_provider_umi/shared/enums/all_enums.dart';
import 'package:service_provider_umi/shared/enums/app_enums.dart';
import 'package:service_provider_umi/shared/widgets/app_avatar.dart';
import 'package:service_provider_umi/shared/widgets/app_button.dart';
import 'package:service_provider_umi/core/theme/app_colors.dart';
import 'package:service_provider_umi/shared/widgets/app_text.dart';
import 'package:service_provider_umi/shared/widgets/app_text_field.dart';
import 'package:service_provider_umi/shared/widgets/app_utils.dart';
part '../widgets/chat_screen_parts/_block_dialog.dart';
part '../widgets/chat_screen_parts/_message_bubble.dart';
part '../widgets/chat_screen_parts/_call_option_dialog.dart';
part '../widgets/chat_screen_parts/_chat_options_sheet.dart';

// ─── Models ───────────────────────────────────────────────────
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
      builder: (_) => _ChatOptionsSheet(
        onBlock: () {
          context.pop();
          _showBlockDialog();
        },
      ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (_) => _BlockUserDialog(
        userName: widget.contactName,
        onBlock: () {
          context.pop();
          context.pop();
        },
        onCancel: () => context.pop(),
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
          context.pop();
          _startAudioCall();
        },
        onMessage: () => context.pop(),
      ),
    );
  }

  void _startAudioCall() {
    context.push(
      AppRoutes.audioCallPath("1"),
      extra: {
        'name': 'John Doe',
        'imageUrl': 'https://example.com/image.jpg',
        'channelId': "",
        'isIncoming': false,
      },
    );
  }

  void _startVideoCall() {
    context.push(
      AppRoutes.videoCallPath("1"),
      extra: {
        'name': 'John Doe',
        'imageUrl': 'https://example.com/image.jpg',
        'channelId': "",
        'isIncoming': false,
      },
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
        onPressed: () => context.pop(),
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
            10.horizontalSpace,
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
        bottom: context.keyboardHeight + context.bottomPadding + 10,
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
          8.horizontalSpace,
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
