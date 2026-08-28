import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/comment.dart';

// Handles fetching and adding comments for posts.
class CommentService {
  // Gets all comments that belong to one specific post.
  Future<List<Comment>> getCommentsByPostId(int postId) async {
    final uri = Uri.parse('$host/comments/post/$postId');

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List commentsJson = data['comments'] ?? [];
      return commentsJson.map((c) => Comment.fromJson(c)).toList();
    } else {
      throw Exception('Failed to load comments: ${response.statusCode}');
    }
  }

  // Adds a new comment to a post and returns the created Comment.
  Future<Comment> addComment({
    required String body,
    required int postId,
    required int userId,
  }) async {
    final uri = Uri.parse('$host/comments/add');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'body': body, 'postId': postId, 'userId': userId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // DummyJSON's "add" response doesn't nest user info the same way as
      // /comments/post, so fall back to the userId we sent if user is missing.
      final data = jsonDecode(response.body);
      data['user'] ??= {'id': userId, 'fullName': 'You'};
      return Comment.fromJson(data);
    } else {
      throw Exception('Failed to add comment: ${response.statusCode}');
    }
  }
}
