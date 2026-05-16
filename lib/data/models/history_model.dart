import 'package:service_provider_umi/shared/enums/all_enums.dart';

class CallHistoryItem {
  final String id;
  final String senderId;
  final String receiverId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CallUser? sender;
  final CallUser? receiver;
  final CallType type;

  const CallHistoryItem({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.createdAt,
    required this.updatedAt,
    this.sender,
    this.receiver,
    required this.type,
  });

  factory CallHistoryItem.fromJson(Map<String, dynamic> json) {
    return CallHistoryItem(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      sender: json['sender'] != null ? CallUser.fromJson(json['sender']) : null,
      receiver: json['receiver'] != null
          ? CallUser.fromJson(json['receiver'])
          : null,

      /// ✅ type parsing (backend should send "audio"/"video")
      type: CallType.values.firstWhere(
        (e) => e.name == (json['type'] ?? '').toString().toLowerCase(),
        orElse: () => CallType.audio,
      ),
    );
  }
}

class CallUser {
  final String id;
  final String name;
  final String? profile;

  const CallUser({required this.id, required this.name, this.profile});

  factory CallUser.fromJson(Map<String, dynamic> json) {
    return CallUser(
      id: json['id'],
      name: json['name'],
      profile: json['profile'],
    );
  }
}
