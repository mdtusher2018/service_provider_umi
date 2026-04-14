import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:service_provider_umi/core/config/app_config.dart';
import 'package:service_provider_umi/core/di/core_providers.dart';
import 'package:service_provider_umi/core/logger/app_logger.dart';
import 'package:service_provider_umi/core/router/app_routes.dart';
import 'package:service_provider_umi/core/services/socket/chat_socket_service.dart';
import 'package:service_provider_umi/core/services/socket/socket_service.dart';
import 'package:service_provider_umi/core/services/storage/storage_key.dart';
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

// ─── Screen ───────────────────────────────────────────────────────────────────
class ChatScreen extends ConsumerStatefulWidget {
  final String otherUserId;
  final String myId;
  final String? chatId;
  final String contactName;
  final String? contactImageUrl;

  const ChatScreen({
    super.key,
    required this.otherUserId,
    required this.myId,
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
  bool _isOffline = false;
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  _UiMessage? _pendingOfflineMessage; // ← new: holds the unsent message
  String? _activeChatId; // filled once server confirms the chatId

  // ── Subscriptions ─────────────────────────────────────────────────────────
  late final StreamSubscription<List<ChatMessage>> _historySub;
  late final StreamSubscription<String> _errorSub;
  late final StreamSubscription<bool> _networkSub; // ← new
  // ─────────────────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _activeChatId = widget.chatId;

    _scrollController.addListener(() {
      if (_scrollController.offset <= 300 && _chatService.hasMorePages) {
        _isLoadingMore = true; // start loading
        _chatService.fetchMoreMessages(widget.otherUserId);
      }
    });

    final cached = _chatService.cachedMessages;
    if (cached.isNotEmpty) {
      _messages.addAll(cached.map(_UiMessage.fromSocket));
    }

    _networkSub = ref.read(networkInfoProvider).onConnectivityChanged.listen((
      connected,
    ) {
      if (!mounted) return;
      setState(() => _isOffline = !connected);
      initializedChatService();
      // ── Back online: retry any message that was stuck ──────────────────

      if (connected && _pendingOfflineMessage != null) {
        final msg = _pendingOfflineMessage!;
        _pendingOfflineMessage = null;
        _retrySendMessage(msg);
      }
    });

    // 2. Listen to full history delivered by "message" event
    _historySub = _chatService.messagesStream.listen(_onHistoryReceived);

    // 3. Listen to socket errors and show snackbar
    _errorSub = _chatService.errorStream.listen(_onSocketError);

    // 5. Tell server to open this conversation (emits "message_page")
    _chatService.openConversation(
      otherUserId: widget.otherUserId,
      chatId: widget.chatId,
    );
  }

  Future<void> initializedChatService() async {
    final token = await ref
        .read(localStorageProvider)
        .read(StorageKey.accessToken);

    ChatSocketService.instance.init(
      baseUrl: AppConfig.socketUrl,
      token: token ?? "",
    );
  }

  @override
  void dispose() {
    _networkSub.cancel();
    _historySub.cancel();
    _errorSub.cancel();
    _chatService.leaveConversation();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ─── Socket callbacks ────────────────────────────────────────────────────

  /// Called whenever messagesStream emits — covers initial history load AND
  /// real-time incoming messages (service appends & re-emits on new_message).
  /// Pending (optimistic) bubbles are preserved so they don't flash away
  /// while waiting for their send-ack.
  void _onHistoryReceived(List<ChatMessage> socketMsgs) {
    if (!mounted) return;
    // Keep optimistic bubbles that haven't been confirmed yet
    final pending = _messages.where((m) => m.isPending).toList();
    setState(() {
      _messages
        ..clear()
        ..addAll(socketMsgs.map(_UiMessage.fromSocket))
        ..addAll(pending);
      _isInitialLoading = false;
      _isLoadingMore = false;
    });
    if (_chatService.currentPage == 1) _scrollToBottom(jump: true);
  }

  // ─── Socket error handler ────────────────────────────────────────────────

  void _onSocketError(String message) async {
    final connected = await ref.read(networkInfoProvider).isConnected;
    if (!mounted || !connected) return;
    context.showErrorSnackBar(message);
    AppLogger.error(message);

    context.showErrorSnackBar(message);
  }

  // ─── Send message ────────────────────────────────────────────────────────

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    // ── Optimistic UI: add a "pending" bubble immediately ──────────────────
    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';
    final optimistic = _UiMessage(
      id: tempId,
      senderId: widget.myId,
      text: text,
      images: const [],
      timestamp: DateTime.now(),
      status: MessageStatus.sending, // spinner / clock icon
      isPending: true,
    );

    setState(() {
      _messages.add(optimistic);
      _messageController.clear();
      if (!_isOffline) _isSending = true;
    });
    _scrollToBottom();

    // ── If offline, park it and bail — no spinner, shows failed state ──
    if (_isOffline) {
      _pendingOfflineMessage = optimistic;
      return;
    }

    _dispatchMessage(optimistic);
  }

  void _dispatchMessage(_UiMessage optimistic) {
    AppLogger.debug("Rety called");
    _chatService.sendMessage(
      payload: SendMessagePayload(
        receiverId: widget.otherUserId,
        text: optimistic.text ?? '',
      ),
      onAck: (response) {
        _handleSendAck(tempId: optimistic.id, response: response);
      },
    );
  }

  void _retrySendMessage(_UiMessage msg, {int attempt = 1}) async {
    const maxAttempts = 5;

    if (!mounted) return;

    // ── Too many attempts → mark as failed and give up ────────────────────
    if (attempt > maxAttempts) {
      AppLogger.error('[Chat] Gave up after $maxAttempts attempts');
      setState(() {
        final idx = _messages.indexWhere((m) => m.id == msg.id);
        if (idx != -1) {
          _messages[idx] = msg.copyWith(
            status: MessageStatus.failed,
            isPending: false,
          );
        }
        _isSending = false;
      });
      return;
    }

    // ── Update bubble to "sending" ─────────────────────────────────────────
    setState(() {
      final idx = _messages.indexWhere((m) => m.id == msg.id);
      if (idx != -1) {
        _messages[idx] = msg.copyWith(
          status: MessageStatus.sending,
          isPending: true,
        );
      }
      _isSending = true;
    });

    // ── Check socket readiness ─────────────────────────────────────────────
    if (_chatService.connectionState != SocketConnectionState.connected) {
      AppLogger.warning(
        '[Chat] Socket not ready — attempt $attempt/$maxAttempts, waiting 5s',
      );

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      if (_chatService.connectionState != SocketConnectionState.connected) {
        _retrySendMessage(msg, attempt: attempt + 1);
        return;
      }
    }

    // ── Socket is ready — dispatch ─────────────────────────────────────────
    AppLogger.debug('[Chat] Dispatching — attempt $attempt');
    _dispatchMessage(msg);
  }

  void _handleSendAck({required String tempId, required dynamic response}) {
    final bool success = response is Map && response['success'] == true;

    setState(() {
      final idx = _messages.indexWhere((m) => m.id == tempId);
      if (idx == -1) {
        _isSending = false; // ← guard: bubble already gone
        return;
      }

      if (success) {
        final data = response['data'] as Map<String, dynamic>? ?? {};
        _activeChatId ??= data['chatId']?.toString();

        final confirmed = _UiMessage(
          id: data['_id']?.toString() ?? tempId,
          senderId: widget.myId,
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
        AppLogger.success("Replaced optimistic bubble");
      } else {
        _messages[idx] = _messages[idx].copyWith(
          status: MessageStatus.failed,
          isPending: false,
        );
      }

      _isSending = false; // ← always resets
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
            Flexible(child: AppText.labelLg(widget.contactName)),
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

    if (_isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (keys.isEmpty) {
      return Center(child: AppText.bodyXs('Say hello 👋'));
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      itemCount: keys.length + (_isLoadingMore ? 1 : 0),
      itemBuilder: (_, i) {
        // ✅ Top loader
        if (_isLoadingMore && i == 0) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        final index = _isLoadingMore ? i - 1 : i;

        final date = keys[index];
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
            ...msgs.map((msg) {
              return _MessageBubble(
                // _MessageBubble now accepts _UiMessage — see note below
                message: msg.toChatMessage(),
                isMine: msg.senderId == widget.myId,
                isPending: msg.isPending,
                isFailed: msg.status == MessageStatus.failed,
                contactName: widget.contactName,
                contactImageUrl: widget.contactImageUrl,
                onRetry: msg.status == MessageStatus.failed
                    ? () => _retryMessage(msg)
                    : null,
              );
            }),
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
    chatId: '',
    senderId: senderId,
    text: text ?? '',
    createdAt: timestamp,
    receiverId: '',
    images: [],
  );
}
