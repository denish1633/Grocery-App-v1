class User {
  int id;
  String email;
  String? username;
  String? accessToken;
  String? tokenType;

  User({required this.id, required this.email, this.username, this.accessToken, this.tokenType});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
        username: json['username'],
        accessToken: json['access_token'],
        tokenType: json['token_type'],
      );
}
