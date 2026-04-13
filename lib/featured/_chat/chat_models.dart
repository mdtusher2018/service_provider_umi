// ─────────────────────────────────────────────────────────────────────────────
// Models
// ─────────────────────────────────────────────────────────────────────────────

class ChatUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? profile;
  final String? phoneNumber;

  const ChatUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profile,
    this.phoneNumber,
  });

  factory ChatUser.fromJson(Map<String, dynamic> j) => ChatUser(
    id: j['id'] ?? '',
    name: j['name'] ?? '',
    email: j['email'] ?? '',
    role: j['role'] ?? '',
    profile: j['profile'],
    phoneNumber: j['phoneNumber'],
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String text;
  final List<String> images;
  final DateTime createdAt;
  final bool seen;

  const ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.images,
    required this.createdAt,
    this.seen = false,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> j) => ChatMessage(
    id: j['id'] ?? '',
    chatId: j['chatId'] ?? '',
    senderId: j['senderId'] ?? '',
    receiverId: j['receiverId'] ?? '',
    text: j['text'] ?? '',
    images: _parseImages(j['images']),
    createdAt: j['createdAt'] != null
        ? DateTime.tryParse(j['createdAt'].toString()) ?? DateTime.now()
        : DateTime.now(),
    seen: j['seen'] ?? false,
  );

  /// 🔥 Handles multiple image formats
  static List<String> _parseImages(dynamic images) {
    try {
      if (images == null) return [];

      // Case 1: List [{url: ""}]
      if (images is List) {
        return images
            .map((img) => img['url']?.toString() ?? '')
            .where((e) => e.isNotEmpty)
            .toList();
      }

      // Case 2: { create: [{url: ""}] }
      if (images is Map && images['create'] is List) {
        return (images['create'] as List)
            .map((img) => img['url']?.toString() ?? '')
            .where((e) => e.isNotEmpty)
            .toList();
      }

      return [];
    } catch (_) {
      return [];
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'senderId': senderId,
    'receiverId': receiverId,
    'text': text,
    'images': images,
    'createdAt': createdAt.toIso8601String(),
    'seen': seen,
  };

  ChatMessage copyWith({bool? seen, String? text, List<String>? images}) =>
      ChatMessage(
        id: id,
        chatId: chatId,
        senderId: senderId,
        receiverId: receiverId,
        text: text ?? this.text,
        images: images ?? this.images,
        createdAt: createdAt,
        seen: seen ?? this.seen,
      );
}
// ─────────────────────────────────────────────────────────────────────────────

class ChatRoom {
  final String id;
  final ChatUser otherUser;
  final ChatMessage? lastMessage;
  final int unreadCount;

  const ChatRoom({
    required this.id,
    required this.otherUser,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> j) {
    final chat = j['chat'] ?? {};
    final participants = chat['participants'] as List? ?? [];

    // Get first participant's user (adjust if needed)
    final userJson = participants.isNotEmpty
        ? participants.first['user'] ?? {}
        : {};

    return ChatRoom(
      id: chat['id'] ?? '',
      otherUser: ChatUser.fromJson(userJson),
      lastMessage: j['message'] != null
          ? ChatMessage.fromJson(j['message'])
          : null,
      unreadCount: j['unreadMessageCount'] ?? 0,
    );
  }

  ChatRoom copyWith({ChatMessage? lastMessage, int? unreadCount}) => ChatRoom(
    id: id,
    otherUser: otherUser,
    lastMessage: lastMessage ?? this.lastMessage,
    unreadCount: unreadCount ?? this.unreadCount,
  );
}
// ─────────────────────────────────────────────────────────────────────────────
// Payloads (emit bodies)
// ─────────────────────────────────────────────────────────────────────────────

class SendMessagePayload {
  final String receiverId;
  final String? text;
  final List<String> images;

  const SendMessagePayload({
    required this.receiverId,
    this.text,
    this.images = const [],
  });

  Map<String, dynamic> toJson() => {
    'receiverId': receiverId,
    if (text != null && text!.isNotEmpty) 'text': text,
    if (images.isNotEmpty) 'images': images,
  };
}

class MessagePagePayload {
  final String userId;
  const MessagePagePayload({required this.userId});
  Map<String, dynamic> toJson() => {'userId': userId};
}

class SeenPayload {
  final String chatId;
  const SeenPayload({required this.chatId});
  Map<String, dynamic> toJson() => {'chatId': chatId};
}
