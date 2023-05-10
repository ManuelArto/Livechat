class User {
  final String username;
  final String imageUrl;
  bool isOnline;

  User({required this.username, required this.imageUrl, this.isOnline = false});

  Map<String, dynamic> toJson() => {
        "username": username,
        "imageUrl": imageUrl,
      };

  factory User.fromJson(Map<String, dynamic> data) => User(
        username: data["username"],
        imageUrl: data["imageUrl"],
      );
}
