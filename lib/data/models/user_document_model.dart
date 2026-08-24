/// Model representing a user-uploaded document returned by `/users/my-documents`.
class UserDocumentModel {
  final String id;
  final String url;
  final String type;
  final String? requestId;

  const UserDocumentModel({
    required this.id,
    required this.url,
    required this.type,
    this.requestId,
  });

  factory UserDocumentModel.fromJson(Map<String, dynamic> json) {
    return UserDocumentModel(
      id: json['id'] as String,
      url: json['url'] as String,
      type: json['type'] as String,
      requestId: json['requestId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'type': type,
        'requestId': requestId,
      };
}
