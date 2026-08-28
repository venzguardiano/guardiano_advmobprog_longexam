import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/user.dart';

// Handles everything related to the logged-in user: logging in, getting the current user, and saving/reading/clearing the session.
class UserService {
  static const String _userKey = 'currentUser';

  // Sends username/password to DummyJSON and gets back a User with tokens.
  Future<User> login(String username, String password) async {
    final uri = Uri.parse('$host/user/login');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 60,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User.fromJson(data);
    } else {
      throw Exception('Invalid username or password');
    }
  }

  // Fetches the current user's fresh profile info using a saved access token.
  Future<User> getCurrentUser(String accessToken) async {
    final uri = Uri.parse('$host/user/me');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      // Keep the same token since /user/me doesn't return one.
      final data = jsonDecode(response.body);
      return User.fromJson(data).copyWithToken(accessToken: accessToken);
    } else {
      throw Exception('Failed to fetch current user: ${response.statusCode}');
    }
  }

  // Saves the logged-in user (including their tokens) onto the device.
  Future<void> saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // Reads the saved user back out, or returns null if nobody is logged in.
  Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_userKey);
    if (raw == null) return null;

    final user = User.fromJson(jsonDecode(raw));

    // Treat a session with no token as logged out, just to be safe.
    if (user.accessToken == null || user.accessToken!.isEmpty) return null;
    return user;
  }

  // Clears the saved session — call this from the Sign Out button.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
