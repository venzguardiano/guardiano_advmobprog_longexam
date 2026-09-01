// Model for a single comment on a post, based on the DummyJSON /comments shape.
class Comment {
  final int id;
  final String body;
  final int postId;
  final int likes;
  final int userId;
  final String userFullName;

  Comment({
    required this.id,
    required this.body,
    required this.postId,
    required this.likes,
    required this.userId,
    required this.userFullName,
  });

  // Builds a Comment from the JSON DummyJSON sends back.
  factory Comment.fromJson(Map<String, dynamic> json) {
    // DummyJSON nests the author info inside a "user" object.
    final user = json['user'] ?? {};

    return Comment(
      id: json['id'] ?? 0,
      body: json['body'] ?? '',
      postId: json['postId'] ?? 0,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      userId: user['id'] ?? 0,
      userFullName: user['fullName'] ?? user['username'] ?? 'Unknown',
    );
  }

  // Converts a Comment back into JSON, e.g. when saving locally or sending to API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'postId': postId,
      'likes': likes,
      'user': {'id': userId, 'fullName': userFullName},
    };
  }
}
