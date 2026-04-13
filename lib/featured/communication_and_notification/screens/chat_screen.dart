import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/services/socket/chat_socket_service.dart';
import 'package:service_provider_umi/core/utils/animations.dart';
import 'package:service_provider_umi/core/utils/extensions/context_ext.dart';
import 'package:service_provider_umi/core/utils/extensions/num_ext.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:service_provider_umi/core/di/app_role_provider.dart';
import 'package:service_provider_umi/core/utils/extensions/datetime_ext.dart';
import 'package:service_provider_umi/featured/_chat/chat_models.dart';
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

// // ─── Mock seed data ───────────────────────────────────────────
// const _kMyId = 'me';
// final _mockMessages = <ChatMessage>[
//   ChatMessage(
//     id: '1',
//     senderId: 'other',
//     text: 'Hello',
//     timestamp: DateTime(2025, 1, 1, 13, 5),
//     status: MessageStatus.read,
//   ),
//   ChatMessage(
//     id: '2',
//     senderId: _kMyId,
//     text: 'Hello',
//     timestamp: DateTime(2025, 1, 1, 13, 5),
//     status: MessageStatus.read,
//   ),
//   ChatMessage(
//     id: '3',
//     senderId: 'other',
//     text: 'How can we help you',
//     timestamp: DateTime(2025, 1, 1, 13, 6),
//     status: MessageStatus.read,
//   ),
//   ChatMessage(
//     id: '4',
//     senderId: _kMyId,
//     text: 'I need a emergency appointment.... are you available now...',
//     timestamp: DateTime(2025, 1, 1, 13, 7),
//     status: MessageStatus.read,
//   ),
//   ChatMessage(
//     id: '5',
//     senderId: 'other',
//     text:
//         'Yes we are available for you.. at first book an appointment and come, you can use google map also if you have any problem.',
//     timestamp: DateTime(2025, 1, 1, 13, 21),
//     status: MessageStatus.read,
//   ),
//   ChatMessage(
//     id: '1',
//     senderId: 'other',
//     text: 'Hello',
//     timestamp: DateTime(2025, 1, 1, 13, 5),
//     status: MessageStatus.read,
//   ),
//   ChatMessage(
//     id: '2',
//     senderId: _kMyId,
//     text: 'Hello',
//     timestamp: DateTime(2025, 1, 1, 13, 5),
//     status: MessageStatus.read,
//   ),
//   ChatMessage(
//     id: '3',
//     senderId: 'other',
//     text: 'How can we help you',
//     timestamp: DateTime(2025, 1, 1, 13, 6),
//     status: MessageStatus.read,
//   ),
//   ChatMessage(
//     id: '4',
//     senderId: _kMyId,
//     text: 'I need a emergency appointment.... are you available now...',
//     timestamp: DateTime(2025, 1, 1, 13, 7),
//     status: MessageStatus.read,
//   ),
//   ChatMessage(
//     id: '5',
//     senderId: 'other',
//     text:
//         'Yes we are available for you.. at first book an appointment and come, you can use google map also if you have any problem.',
//     timestamp: DateTime(2025, 1, 1, 13, 21),
//     status: MessageStatus.read,
//   ),
// ];
// // ─── Screen ───────────────────────────────────────────────────
// class ChatScreen extends StatefulWidget {
//   final String contactId;
//   final String contactName;
//   final String? contactImageUrl;
//   const ChatScreen({
//     super.key,
//     required this.contactId,
//     required this.contactName,
//     this.contactImageUrl,
//   });
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
// class _ChatScreenState extends State<ChatScreen> {
//   final _messageController = TextEditingController();
//   final _scrollController = ScrollController();
//   final List<ChatMessage> _messages = List.from(_mockMessages);
//   bool _isSending = false;
//   @override
//   void dispose() {
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }
//   // ─── Send message (local state only) ──────────────────────
//   void _sendMessage() {
//     final text = _messageController.text.trim();
//     if (text.isEmpty || _isSending) return;
//     final newMsg = ChatMessage(
//       id: DateTime.now().millisecondsSinceEpoch.toString(),
//       senderId: _kMyId,
//       text: text,
//       timestamp: DateTime.now(),
//       status: MessageStatus.sending,
//     );
//     setState(() {
//       _isSending = true;
//       _messages.add(newMsg);
//       _messageController.clear();
//     });
//     _scrollToBottom();
//     // Simulate network delivery
//     Future.delayed(const Duration(milliseconds: 700), () {
//       if (!mounted) return;
//       setState(() {
//         final idx = _messages.indexWhere((m) => m.id == newMsg.id);
//         if (idx != -1) {
//           _messages[idx] = _messages[idx].copyWith(
//             status: MessageStatus.delivered,
//           );
//         }
//         _isSending = false;
//       });
//     });
//   }
//   void _scrollToBottom() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }
//   // ─── Overlay actions ──────────────────────────────────────
//   void _showOptions() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => _ChatOptionsSheet(
//         onBlock: () {
//           context.pop();
//           _showBlockDialog();
//         },
//       ),
//     );
//   }
//   void _showBlockDialog() {
//     showGeneralDialog(
//       context: context,
//       transitionDuration: dialogSlidingFadeTransitionDuration,
//       transitionBuilder: dialogSlideFadeTransition,
//       pageBuilder: (_, _, _) => _BlockUserDialog(
//         userName: widget.contactName,
//         onBlock: () {
//           context.pop();
//           context.pop();
//         },
//         onCancel: () => context.pop(),
//       ),
//     );
//   }
//   void _showCallOptions() {
//     showGeneralDialog(
//       context: context,
//       transitionDuration: dialogSlidingFadeTransitionDuration,
//       transitionBuilder: dialogSlideFadeTransition,
//       barrierColor: Colors.grey.withOpacity(0.4),
//       pageBuilder: (_, _, _) => _CallOptionDialog(
//         contactName: widget.contactName,
//         contactImageUrl: widget.contactImageUrl,
//         onCall: () {
//           context.pop();
//           _startAudioCall();
//         },
//         onMessage: () => context.pop(),
//       ),
//     );
//   }
//   void _startAudioCall() {
//     context.push(
//       AppRoutes.audioCallPath("1"),
//       extra: {
//         'name': 'John Doe',
//         'imageUrl': 'https://example.com/image.jpg',
//         'channelId': "",
//         'isIncoming': false,
//       },
//     );
//   }
//   void _startVideoCall() {
//     context.push(
//       AppRoutes.videoCallPath("1"),
//       extra: {
//         'name': 'John Doe',
//         'imageUrl': 'https://example.com/image.jpg',
//         'channelId': "",
//         'isIncoming': false,
//       },
//     );
//   }
//   // ─── Build ────────────────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: _buildAppBar(),
//       body: Column(
//         children: [
//           Expanded(child: _buildMessageList()),
//           _buildInputBar(),
//         ],
//       ),
//     );
//   }
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       backgroundColor: AppColors.background,
//       elevation: 0,
//       scrolledUnderElevation: 0,
//       leading: IconButton(
//         icon: const Icon(
//           Icons.arrow_back_ios_rounded,
//           color: AppColors.textPrimary,
//           size: 18,
//         ),
//         onPressed: () => context.pop(),
//       ),
//       title: GestureDetector(
//         onTap: _showCallOptions,
//         child: Row(
//           children: [
//             AppAvatar(
//               name: widget.contactName,
//               imageUrl: widget.contactImageUrl,
//               size: AvatarSize.sm,
//             ),
//             10.horizontalSpace,
//             AppText.labelLg(widget.contactName),
//           ],
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(
//             Icons.call_outlined,
//             color: AppColors.textPrimary,
//             size: 22,
//           ),
//           onPressed: _startAudioCall,
//         ),
//         IconButton(
//           icon: const Icon(
//             Icons.videocam_outlined,
//             color: AppColors.textPrimary,
//             size: 22,
//           ),
//           onPressed: _startVideoCall,
//         ),
//         IconButton(
//           icon: const Icon(
//             Icons.more_vert_rounded,
//             color: AppColors.textPrimary,
//             size: 22,
//           ),
//           onPressed: _showOptions,
//         ),
//       ],
//     );
//   }
//   Widget _buildMessageList() {
//     // Group by date
//     final grouped = <String, List<ChatMessage>>{};
//     for (final m in _messages) {
//       final key = DateFormat('d MMM yyyy').format(m.timestamp);
//       grouped.putIfAbsent(key, () => []).add(m);
//     }
//     final keys = grouped.keys.toList();
//     return ListView.builder(
//       controller: _scrollController,
//       padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
//       itemCount: keys.length,
//       itemBuilder: (_, i) {
//         final date = keys[i];
//         final msgs = grouped[date]!;
//         return Column(
//           children: [
//             // Date separator
//             Padding(
//               padding: 12.paddingV,
//               child: Row(
//                 children: [
//                   const Expanded(child: AppDivider()),
//                   Padding(
//                     padding: 12.paddingH,
//                     child: AppText.bodyXs(
//                       date == DateFormat('d MMM yyyy').format(DateTime.now())
//                           ? 'Today'
//                           : date,
//                     ),
//                   ),
//                   const Expanded(child: AppDivider()),
//                 ],
//               ),
//             ),
//             ...msgs.map(
//               (msg) => _MessageBubble(
//                 message: msg,
//                 isMine: msg.senderId == _kMyId,
//                 contactName: widget.contactName,
//                 contactImageUrl: widget.contactImageUrl,
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   Widget _buildInputBar() {
//     return Container(
//       padding: EdgeInsets.only(
//         left: 16,
//         right: 12,
//         top: 10,
//         bottom: context.keyboardHeight + context.bottomPadding + 10,
//       ),
//       decoration: BoxDecoration(
//         border: const Border(top: BorderSide(color: AppColors.border)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.greenAccent.withOpacity(0.04),
//             blurRadius: 8,
//             offset: const Offset(0, -2),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: AppTextField(
//               hint: "Message",
//               borderRadious: 100,
//               suffixIcon: Container(
//                 padding: EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: AppColors.grey200,
//                 ),
//                 child: Icon(Icons.image_outlined),
//               ),
//             ),
//           ),
//           8.horizontalSpace,
//           GestureDetector(
//             onTap: _sendMessage,
//             child: Container(
//               width: 42,
//               height: 42,
//               decoration: const BoxDecoration(
//                 color: AppColors.primary,
//                 shape: BoxShape.circle,
//               ),
//               child: _isSending
//                   ? const Padding(
//                       padding: EdgeInsets.all(10),
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                         color: AppColors.white,
//                       ),
//                     )
//                   : const Icon(
//                       Icons.send_rounded,
//                       color: AppColors.white,
//                       size: 18,
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ─── Screen ───────────────────────────────────────────────────────────────────
class ChatScreen extends ConsumerStatefulWidget {
  final String contactId; // == receiverId / otherUser's _id
  final String?
  chatId; // optional — known after first message or from chat list
  final String contactName;
  final String? contactImageUrl;

  const ChatScreen({
    super.key,
    required this.contactId,
    required this.contactName,
    this.chatId,
    this.contactImageUrl,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  // ── Services ─────────────────────────────────────────────────────────────
  final _chatService = ChatSocketService.instance;

  // ── Controllers ───────────────────────────────────────────────────────────
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  // ── State ─────────────────────────────────────────────────────────────────
  final List<_UiMessage> _messages = [];
  bool _isSending = false;
  String? _activeChatId; // filled once server confirms the chatId

  // ── Subscriptions ─────────────────────────────────────────────────────────
  late final StreamSubscription<List<ChatMessage>> _historySub;
  late final StreamSubscription<ChatMessage> _newMsgSub;

  // ─── currentUserId helper ────────────────────────────────────────────────
  // Replace this with however your app exposes the logged-in user's id.
  String get _myId => '69d08ac561dc3ba59910f702';

  // ─────────────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _activeChatId = widget.chatId;

    // 1. Pre-fill from cache so there's no blank flash on navigation
    final cached = _chatService.cachedMessages;
    if (cached.isNotEmpty) {
      _messages.addAll(cached.map(_UiMessage.fromSocket));
    }

    // 2. Listen to full history delivered by "message" event
    _historySub = _chatService.messagesStream.listen(_onHistoryReceived);

    // 3. Listen to brand-new messages ("new_message")
    _newMsgSub = _chatService.newMessageStream.listen(_onNewMessageArrived);

    // 4. Tell server to open this conversation (emits "message_page")
    _chatService.openConversation(
      otherUserId: widget.contactId,
      chatId: _activeChatId,
    );
  }

  @override
  void dispose() {
    _historySub.cancel();
    _newMsgSub.cancel();
    _chatService.leaveConversation();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ─── Socket callbacks ────────────────────────────────────────────────────

  /// Called when "message" fires — replaces list with authoritative history.
  void _onHistoryReceived(List<ChatMessage> socketMsgs) {
    if (!mounted) return;
    setState(() {
      _messages
        ..clear()
        ..addAll(socketMsgs.map(_UiMessage.fromSocket));
    });
    _scrollToBottom(jump: true);
  }

  /// Called when "new_message" fires for a message from the other person.
  void _onNewMessageArrived(ChatMessage msg) {
    if (!mounted) return;
    // Avoid duplicates (service may already append to messagesStream)
    final alreadyPresent = _messages.any((m) => m.id == msg.id);
    if (alreadyPresent) return;
    setState(() => _messages.add(_UiMessage.fromSocket(msg)));
    _scrollToBottom();

    // Mark as seen
    if (_activeChatId != null) {
      _chatService.markAsSeen(chatId: _activeChatId!);
    }
  }

  // ─── Send message ────────────────────────────────────────────────────────

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    // ── Optimistic UI: add a "pending" bubble immediately ──────────────────
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final optimistic = _UiMessage(
      id: tempId,
      senderId: _myId,
      text: text,
      images: const [],
      timestamp: DateTime.now(),
      status: MessageStatus.sending, // spinner / clock icon
      isPending: true,
    );

    setState(() {
      _isSending = true;
      _messages.add(optimistic);
      _messageController.clear();
    });
    _scrollToBottom();

    // ── Emit to server with ack callback ───────────────────────────────────
    _chatService.sendMessage(
      payload: SendMessagePayload(receiverId: widget.contactId, text: text),
      onAck: (response) {
        if (!mounted) return;
        // response == the raw ack data the server sends back:
        // { "success": true, "message": "...", "data": { "chatId": "...", ...message fields } }
        _handleSendAck(tempId: tempId, response: response);
      },
    );
  }

  /// Replace the optimistic bubble with the confirmed server message.
  void _handleSendAck({required String tempId, required dynamic response}) {
    if (!mounted) return;

    final bool success = response is Map && response['success'] == true;

    setState(() {
      final idx = _messages.indexWhere((m) => m.id == tempId);
      if (idx == -1) return;

      if (success) {
        final data = response['data'] as Map<String, dynamic>? ?? {};

        // Grab chatId from ack if we didn't have it yet
        _activeChatId ??= data['chatId']?.toString();

        // Build confirmed message from the ack data
        final confirmed = _UiMessage(
          id: data['_id']?.toString() ?? tempId,
          senderId: _myId,
          text: data['text']?.toString() ?? _messages[idx].text,
          images: List<String>.from(data['images'] ?? []),
          timestamp: data['createdAt'] != null
              ? DateTime.tryParse(data['createdAt'].toString()) ??
                    DateTime.now()
              : DateTime.now(),
          status: MessageStatus.delivered,
          isPending: false,
        );

        _messages[idx] = confirmed;
      } else {
        // Mark as failed so user can retry
        _messages[idx] = _messages[idx].copyWith(status: MessageStatus.failed);
      }

      _isSending = false;
    });
  }

  // ─── Retry a failed message ───────────────────────────────────────────────
  void _retryMessage(_UiMessage msg) {
    setState(() => _messages.remove(msg));
    _messageController.text = msg.text ?? '';
    _sendMessage();
  }

  // ─── Scroll helper ────────────────────────────────────────────────────────
  void _scrollToBottom({bool jump = false}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      if (jump) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } else {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ─── Overlay helpers (unchanged from original) ───────────────────────────
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
    showGeneralDialog(
      context: context,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      pageBuilder: (_, _, _) => _BlockUserDialog(
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
    showGeneralDialog(
      context: context,
      transitionDuration: dialogSlidingFadeTransitionDuration,
      transitionBuilder: dialogSlideFadeTransition,
      barrierColor: Colors.grey.withOpacity(0.4),
      pageBuilder: (_, _, _) => _CallOptionDialog(
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

  void _startAudioCall() => context.push(
    AppRoutes.audioCallPath("1"),
    extra: {
      'name': widget.contactName,
      'imageUrl': widget.contactImageUrl ?? '',
      'channelId': '',
      'isIncoming': false,
    },
  );

  void _startVideoCall() => context.push(
    AppRoutes.videoCallPath("1"),
    extra: {
      'name': widget.contactName,
      'imageUrl': widget.contactImageUrl ?? '',
      'channelId': '',
      'isIncoming': false,
    },
  );

  // ─── Build ────────────────────────────────────────────────────────────────
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
    final grouped = <String, List<_UiMessage>>{};
    for (final m in _messages) {
      final key = DateFormat('d MMM yyyy').format(m.timestamp);
      grouped.putIfAbsent(key, () => []).add(m);
    }
    final keys = grouped.keys.toList();

    if (keys.isEmpty) {
      return Center(child: AppText.bodyXs('Say hello 👋'));
    }

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
              padding: 12.paddingV,
              child: Row(
                children: [
                  const Expanded(child: AppDivider()),
                  Padding(
                    padding: 12.paddingH,
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
                // _MessageBubble now accepts _UiMessage — see note below
                message: msg.toChatMessage(),
                isMine: msg.senderId == _myId,
                isPending: msg.isPending,
                isFailed: msg.status == MessageStatus.failed,
                contactName: widget.contactName,
                contactImageUrl: widget.contactImageUrl,
                onRetry: msg.status == MessageStatus.failed
                    ? () => _retryMessage(msg)
                    : null,
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
            color: Colors.greenAccent.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: AppTextField(
              controller: _messageController, // ← wire up your controller
              hint: "Message",
              borderRadious: 100,
              suffixIcon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.grey200,
                ),
                child: const Icon(Icons.image_outlined),
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

// ─────────────────────────────────────────────────────────────────────────────
// _UiMessage  — internal view-model used only inside this screen
// Holds both pending (optimistic) state and confirmed server data.
// ─────────────────────────────────────────────────────────────────────────────

class _UiMessage {
  final String id;
  final String senderId;
  final String? text;
  final List<String> images;
  final DateTime timestamp;
  final MessageStatus status;
  final bool isPending; // true while waiting for server ack

  const _UiMessage({
    required this.id,
    required this.senderId,
    this.text,
    this.images = const [],
    required this.timestamp,
    required this.status,
    this.isPending = false,
  });

  /// Build from the socket model that comes through "message" / "new_message"
  factory _UiMessage.fromSocket(ChatMessage m) => _UiMessage(
    id: m.id,
    senderId: m.senderId,
    text: m.text,
    images: m.images,
    timestamp: m.createdAt,
    status: m.seen ? MessageStatus.read : MessageStatus.delivered,
    isPending: false,
  );

  _UiMessage copyWith({MessageStatus? status, bool? isPending}) => _UiMessage(
    id: id,
    senderId: senderId,
    text: text,
    images: images,
    timestamp: timestamp,
    status: status ?? this.status,
    isPending: isPending ?? this.isPending,
  );

  /// Bridge back to your existing ChatMessage model so _MessageBubble works
  /// without changes (or add isPending/isFailed directly to _MessageBubble).
  ChatMessage toChatMessage() => ChatMessage(
    id: id,
    senderId: senderId,
    text: text ?? '',
    createdAt: timestamp,
    receiverId: '',
    images: [],
  );
}
