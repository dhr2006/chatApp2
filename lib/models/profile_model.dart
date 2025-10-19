class ProfileModel {
  final String id;
  final String username;
  final String avatarColor;
  final DateTime createdAt;

  ProfileModel({
    required this.id,
    required this.username,
    required this.avatarColor,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      username: json['username'] as String,
      avatarColor: json['avatar_color'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar_color': avatarColor,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get initials {
    if (username.isEmpty) return '?';
    return username[0].toUpperCase();
  }
}