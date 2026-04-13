/// All socket event names used in the chat feature.
/// Centralised here so a typo never causes a silent bug.
abstract class ChatEvents {
  // ── Emit (client → server) ───────────────────────────────────────────────
  /// Fetch the current user's chat list. No payload required.
  static const String getMyChatList = 'my_chat_list';

  /// Open a specific conversation. Payload: [MessagePagePayload]
  static const String messagePage = 'message_page';

  /// Send a new message. Payload: [SendMessagePayload]
  static const String sendMessage = 'send_message';

  /// Mark a chat as seen. Payload: [SeenPayload]
  static const String seen = 'seen';

  // ── Listen (server → client) ─────────────────────────────────────────────
  /// Stream of chat-list updates (always active).
  static const String chatList = 'chat_list';

  /// Delivers conversation history + real-time messages.
  static const String message = 'message';

  /// Fires when a brand-new message arrives for the current user.
  static const String newMessage = 'new_message';
}
