class MessageModel {
  final String id;
  final String userId;
  final String content;
  final DateTime createdAt;
  String? username;
  String? avatarColor;

  MessageModel({
    required this.id,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.username,
    this.avatarColor,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      username: json['username'] as String?,
      avatarColor: json['avatar_color'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
    };
  }

  MessageModel copyWith({
    String? id,
    String? userId,
    String? content,
    DateTime? createdAt,
    String? username,
    String? avatarColor,
  }) {
    return MessageModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      username: username ?? this.username,
      avatarColor: avatarColor ?? this.avatarColor,
    );
  }
}