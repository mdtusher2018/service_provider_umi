import 'dart:async';
import 'dart:developer';

import 'package:service_provider_umi/core/logger/app_logger.dart';
import 'package:service_provider_umi/featured/_chat/chat_events.dart';
import 'package:service_provider_umi/featured/_chat/chat_models.dart';
import 'socket_service.dart';

/// Feature-level service that wires chat-specific socket events.
/// Depends on [SocketService] but is otherwise self-contained.
///
/// Lifecycle:
///   1. Call [init] once (initialises [SocketService] too).
///   2. On ChatList screen → call [subscribeToMyChatList] then [fetchChatList].
///   3. On Message screen → call [openConversation].
///   4. On leaving Message screen → call [leaveConversation].
///   5. On logout → call [dispose].
class ChatSocketService {
  ChatSocketService._();
  static final ChatSocketService instance = ChatSocketService._();

  final _socket = SocketService.instance;

  // ─── Streams ─────────────────────────────────────────────────────────────────
  final _chatListController = StreamController<List<ChatRoom>>.broadcast();
  final _messagesController = StreamController<List<ChatMessage>>.broadcast();
  final _newMessageController = StreamController<ChatMessage>.broadcast();

  /// Emits the full refreshed chat list whenever the server pushes one.
  Stream<List<ChatRoom>> get chatListStream => _chatListController.stream;

  /// Emits the full message history (and updates) for the open conversation.
  Stream<List<ChatMessage>> get messagesStream => _messagesController.stream;

  /// Emits individual new messages as they arrive.
  Stream<ChatMessage> get newMessageStream => _newMessageController.stream;

  /// Re-expose connection state from the underlying service.
  Stream<SocketConnectionState> get connectionStream =>
      _socket.connectionStream;
  SocketConnectionState get connectionState => _socket.state;

  // ─── Internal state ───────────────────────────────────────────────────────
  String? _activeConversationUserId;
  String? _activeChatId;

  // Snapshot caches (optional — avoids blank UI during reconnects)
  List<ChatRoom> _cachedChatList = [];
  List<ChatMessage> _cachedMessages = [];

  List<ChatRoom> get cachedChatList => List.unmodifiable(_cachedChatList);
  List<ChatMessage> get cachedMessages => List.unmodifiable(_cachedMessages);

  // ─── Init ─────────────────────────────────────────────────────────────────

  /// Initialise the socket and register persistent chat listeners.
  void init({required String baseUrl, required String token}) {
    _socket.init(baseUrl: baseUrl, token: token);

    // chat_list — always active
    _socket.on(ChatEvents.chatList, _onChatList);

    // new_message — always active (drives notifications / badge updates)
    _socket.on(ChatEvents.newMessage, _onNewMessage);

    // message — always registered; only meaningful while a convo is open
    _socket.on(ChatEvents.message, _onMessage);

    // Auto-refetch chat list after reconnect
    _socket.connectionStream.listen((state) {
      if (state == SocketConnectionState.connected) {
        fetchChatList();
        if (_activeConversationUserId != null) {
          _emitMessagePage(_activeConversationUserId!);
        }
      }
    });

    log('[Access Token] $token');
    log('[ChatSocketService] Initialised');
  }

  // ─── Chat List ────────────────────────────────────────────────────────────

  /// Emit [my_chat_list] to request a fresh list from the server.
  /// The response arrives via [chatListStream].
  void fetchChatList() {
    _socket.emit(ChatEvents.getMyChatList);
  }

  // ─── Conversation ─────────────────────────────────────────────────────────

  /// Call when navigating INTO a chat conversation screen.
  /// Emits [message_page] and stores the active convo for reconnect recovery.
  void openConversation({required String otherUserId, String? chatId}) {
    _activeConversationUserId = otherUserId;
    _activeChatId = chatId;
    _cachedMessages = [];
    _emitMessagePage(otherUserId);

    // Mark as seen if we have a chatId
    if (chatId != null) markAsSeen(chatId: chatId);
  }

  /// Call when navigating AWAY from the conversation screen.
  void leaveConversation() {
    _activeConversationUserId = null;
    _activeChatId = null;
    _cachedMessages = [];
  }

  // ─── Messaging ────────────────────────────────────────────────────────────

  /// Mark a chat as seen by the current user.
  void markAsSeen({required String chatId}) {
    _socket.emit(ChatEvents.seen, data: SeenPayload(chatId: chatId).toJson());
  }

  // ─── Private handlers ─────────────────────────────────────────────────────

  void _onChatList(dynamic raw) {
    AppLogger.debug(raw.toString());
    try {
      final list = _parseList(raw);
      final rooms = list.map((e) => ChatRoom.fromJson(e)).toList();
      _cachedChatList = rooms;
      _chatListController.add(rooms);
      log('[ChatSocketService] chat_list updated — ${rooms.length} rooms');
    } catch (e) {
      log('[ChatSocketService] Failed to parse chat_list', error: e);
    }
  }

  void _onMessage(dynamic raw) {
    try {
      AppLogger.debug(raw.toString());
      final list = raw['data'] as List? ?? [];
      AppLogger.debug(list.toString());
      final messages = list.map((e) => ChatMessage.fromJson(e)).toList();
      _cachedMessages = messages;
      _messagesController.add(messages);
      log('[ChatSocketService] message — ${messages.length} messages loaded');
    } catch (e) {
      log('[ChatSocketService] Failed to parse message', error: e);
    }
  }

  void _onNewMessage(dynamic raw) {
    try {
      final data = raw is Map<String, dynamic>
          ? raw
          : Map<String, dynamic>.from(raw as Map);
      final msg = ChatMessage.fromJson(data);
      _newMessageController.add(msg);

      // Append to cached messages if it belongs to the open convo
      if (_activeConversationUserId != null &&
          (msg.senderId == _activeConversationUserId ||
              msg.receiverId == _activeConversationUserId)) {
        _cachedMessages = [..._cachedMessages, msg];
        _messagesController.add(_cachedMessages);

        // Auto-mark seen
        if (_activeChatId != null) markAsSeen(chatId: _activeChatId!);
      }

      log('[ChatSocketService] new_message from ${msg.senderId}');
    } catch (e) {
      log('[ChatSocketService] Failed to parse new_message', error: e);
    }
  }

  void _emitMessagePage(String userId) {
    _socket.emit(
      ChatEvents.messagePage,
      data: MessagePagePayload(userId: userId).toJson(),
    );
  }

  void sendMessage({
    required SendMessagePayload payload,
    required void Function(dynamic response) onAck,
  }) {
    if (!_socket.isConnected) {
      // Still optimistically show — queue the real emit for when reconnected
      _socket.emit(
        ChatEvents.sendMessage,
        data: payload.toJson(),

        queueIfOffline: true,
      );
      // Can't get an ack while offline; caller should handle via new_message stream
      return;
    }

    _socket.emit(
      ChatEvents.sendMessage,
      data: payload.toJson(),
      ack: (response) => onAck(response), // ← ack callback
    );
  }

  // ─── Dispose ──────────────────────────────────────────────────────────────

  void dispose() {
    _socket.off(ChatEvents.chatList, _onChatList);
    _socket.off(ChatEvents.newMessage, _onNewMessage);
    _socket.off(ChatEvents.message, _onMessage);
    _socket.dispose();
    _chatListController.close();
    _messagesController.close();
    _newMessageController.close();
  }

  // ─── Utils ────────────────────────────────────────────────────────────────

  List<dynamic> _parseList(dynamic raw) {
    return raw['chats'];
  }
}
