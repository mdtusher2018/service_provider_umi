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

  /// Re-expose socket-level errors (connect errors, network failures, etc.)
  /// for the UI layer to consume as snackbars.
  Stream<String> get errorStream => _socket.errorStream;

  // ─── Internal state ───────────────────────────────────────────────────────
  String? _activeConversationUserId;
  String? _activeChatId;

  // Snapshot caches (optional — avoids blank UI during reconnects)
  List<ChatRoom> _cachedChatList = [];
  List<ChatMessage> _cachedMessages = [];

  List<ChatRoom> get cachedChatList => List.unmodifiable(_cachedChatList);
  List<ChatMessage> get cachedMessages => List.unmodifiable(_cachedMessages);

  String? _lastMessageId;
  DateTime? _lastMessageTime;

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
        fetchChatList(onAck: (response) {});
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
  Future<void> fetchChatList({
    required void Function(dynamic response) onAck,
  }) async {
    _socket.emit(ChatEvents.getMyChatList, ack: (response) => onAck(response));
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
    try {
      final list = _parseList(raw);
      final rooms = list.map((e) => ChatRoom.fromJson(e)).toList();
      _cachedChatList = rooms;
      _chatListController.add(rooms);
      log('[ChatSocketService] chat_list updated — ${rooms.length} rooms');
    } catch (e, st) {
      AppLogger.error('[ChatSocketService] Failed to parse chat_list $e, $st');
      log('[ChatSocketService] Failed to parse chat_list', error: e);
    }
  }

  void _onMessage(dynamic raw) {
    try {
      final list = raw['data'] as List? ?? [];

      final messages = list.map((e) => ChatMessage.fromJson(e)).toList();
      _cachedMessages = messages;
      _messagesController.add(messages);
      log('[ChatSocketService] message — ${messages.length} messages loaded');
    } catch (e, st) {
      AppLogger.error(
        '[ChatSocketService] Failed to parse message event $e \n $st',
      );
      log('[ChatSocketService] Failed to parse message', error: e);
    }
  }

  void _onNewMessage(dynamic raw) {
    AppLogger.info("${DateTime.now()} $raw");

    try {
      final map = Map<String, dynamic>.from(raw as Map);
      final data = map['message'] ?? map['data'];

      if (data == null) {
        log('new_message missing data field: $map');
        return;
      }

      final msg = ChatMessage.fromJson(Map<String, dynamic>.from(data));

      /// 🔥 TIME-BASED DUPLICATE PREVENTION (500ms)
      final now = DateTime.now();

      if (_lastMessageId == msg.id &&
          _lastMessageTime != null &&
          now.difference(_lastMessageTime!).inMilliseconds < 500) {
        AppLogger.info(
          '[ChatSocketService] skipped duplicate within 500ms: ${msg.id}',
        );
        return;
      }

      _lastMessageId = msg.id;
      _lastMessageTime = now;

      _newMessageController.add(msg);

      final isForActiveConvo =
          _activeConversationUserId != null &&
          msg.senderId == _activeConversationUserId;

      if (isForActiveConvo) {
        _cachedMessages = [..._cachedMessages, msg];
        _messagesController.add(_cachedMessages);

        if (_activeChatId != null) {
          markAsSeen(chatId: _activeChatId!);
        }
      }

      log('[ChatSocketService] new_message added: ${msg.text}');
    } catch (e, st) {
      AppLogger.error('[ChatSocketService] new_message error $e\n$st');
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
    _socket.emit(
      ChatEvents.sendMessage,
      data: payload.toJson(),
      ack: (response) {
        AppLogger.error(response.toString());
        final data = response['data'];
        final msg = ChatMessage(
          chatId: data['chatId'],
          createdAt: DateTime.tryParse(data['createdAt']) ?? DateTime.now(),
          id: data['createdAt'],
          images: [],
          receiverId: data['receiverId'],
          senderId: data['senderId'],
          text: data['text'],
        );
        _cachedMessages = [..._cachedMessages, msg];
        _messagesController.add(_cachedMessages);

        if (_activeChatId != null) {
          markAsSeen(chatId: _activeChatId!);
        }
        onAck(response);
      }, // ← ack callback
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
