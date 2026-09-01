import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/comment.dart';

// Handles fetching, posting, and locally persisting comments for specific posts.
class CommentService {
  static const String _localCommentsKey = 'local_saved_comments';

  // Gets comments that belong ONLY to the specified postId (API + Local Storage).
  Future<List<Comment>> getCommentsByPostId(int postId) async {
    List<Comment> apiComments = [];

    // Fetch remote comments for this specific post from the API
    try {
      final uri = Uri.parse('$host/comments/post/$postId');
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List commentsJson = data['comments'] ?? [];
        apiComments = commentsJson.map((c) => Comment.fromJson(c)).toList();
      }
    } catch (_) {
      // Handles network errors gracefully
    }

    // Load local comments from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final String? localJsonString = prefs.getString(_localCommentsKey);

    if (localJsonString != null) {
      final List decoded = jsonDecode(localJsonString);
      final List<Comment> allLocalComments = decoded
          .map((json) => Comment.fromJson(json))
          .toList();

      // STRICT FILTER: Only retrieve comments matching this specific postId
      final postLocalComments = allLocalComments
          .where((c) => c.postId == postId)
          .toList();

      // Prepend local comments for this post ahead of the API comments
      return [...postLocalComments, ...apiComments];
    }

    return apiComments;
  }

  // Adds a new comment linked to a specific postId and persists it in SharedPreferences.
  Future<Comment> addComment({
    required String body,
    required int postId,
    required int userId,
  }) async {
    Comment? newComment;

    try {
      final uri = Uri.parse('$host/comments/add');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'body': body, 'postId': postId, 'userId': userId}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        data['user'] ??= {'id': userId, 'fullName': 'You'};
        data['postId'] =
            postId; // Ensures the returned object retains the exact target postId
        newComment = Comment.fromJson(data);
      }
    } catch (_) {
      // Fallback if network request fails
    }

    // Fallback if API fails or responds with non-200 status
    newComment ??= Comment(
      id: DateTime.now().millisecondsSinceEpoch,
      body: body,
      postId: postId,
      likes: 0,
      userId: userId,
      userFullName: 'You',
    );

    // Save to SharedPreferences while preserving the post association
    final prefs = await SharedPreferences.getInstance();
    final String? localJsonString = prefs.getString(_localCommentsKey);

    List<dynamic> currentLocalList = [];
    if (localJsonString != null) {
      currentLocalList = jsonDecode(localJsonString);
    }

    currentLocalList.insert(0, newComment.toJson());
    await prefs.setString(_localCommentsKey, jsonEncode(currentLocalList));

    return newComment;
  }
}
