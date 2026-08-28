import 'dart:convert';
import 'package:http/http.dart';

import '../constants.dart';
import '../models/post.dart';

// Handles fetching posts from the DummyJSON API.
class PostService {
  // Gets a general page of posts (used for a general/global feed).
  Future<List<Post>> getPosts({int limit = 30, int skip = 0}) async {
    final uri = Uri.parse('$host/posts?limit=$limit&skip=$skip');
    final response = await get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List postsJson = data['posts'] ?? [];
      return postsJson.map((p) => Post.fromJson(p)).toList();
    } else {
      throw Exception('Failed to load posts: ${response.statusCode}');
    }
  }

  // Gets only the posts that belong to one specific user (for their profile screen).
  Future<List<Post>> getPostsByUserId(int userId) async {
    final uri = Uri.parse('$host/posts/user/$userId');
    final response = await get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List postsJson = data['posts'] ?? [];
      return postsJson.map((p) => Post.fromJson(p)).toList();
    } else {
      throw Exception(
        'Failed to load posts for user $userId: ${response.statusCode}',
      );
    }
  }
}
