// Model for a single post, based on the actual DummyJSON /posts shape.
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;
  final List<String> tags;
  final int likes;
  final int dislikes;
  final int views;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.tags,
    required this.likes,
    required this.dislikes,
    required this.views,
  });

  // Builds a Post from the JSON DummyJSON sends back.
  factory Post.fromJson(Map<String, dynamic> json) {
    // Likes/dislikes are nested under "reactions" in the real API.
    final reactions = json['reactions'] ?? {};

    return Post(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      tags: (json['tags'] as List?)?.map((t) => t.toString()).toList() ?? [],
      likes: (reactions['likes'] as num?)?.toInt() ?? 0,
      dislikes: (reactions['dislikes'] as num?)?.toInt() ?? 0,
      views: (json['views'] as num?)?.toInt() ?? 0,
    );
  }

  // Converts a Post back into JSON, e.g. when sending an update to the API.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
      'tags': tags,
      'reactions': {'likes': likes, 'dislikes': dislikes},
      'views': views,
    };
  }
}
