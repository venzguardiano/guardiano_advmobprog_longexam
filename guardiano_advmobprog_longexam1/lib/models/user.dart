// Model for the logged-in user, based on the DummyJSON /user shape, plus tokens from login.
class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String image;
  final String? accessToken;
  final String? refreshToken;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.image,
    this.accessToken,
    this.refreshToken,
  });

  // Convenience getter to show "First Last" instead of two separate fields.
  String get fullName => '$firstName $lastName'.trim();

  // Builds a User from the JSON DummyJSON sends back.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      gender: json['gender'] ?? '',
      image: json['image'] ?? '',
      // Handles both accessToken and legacy token property keys from DummyJSON.
      accessToken: json['accessToken'] ?? json['token'],
      refreshToken: json['refreshToken'],
    );
  }

  // Converts a User back into JSON so it can be saved to shared_preferences.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'image': image,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  // Makes a copy of this user while preserving or updating tokens.
  User copyWithToken({String? accessToken, String? refreshToken}) {
    return User(
      id: id,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      image: image,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
