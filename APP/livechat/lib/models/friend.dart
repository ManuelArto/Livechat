class Friend {
  final String username;
  final String imageUrl;

  bool isOnline = false;

  Friend({required this.username, required this.imageUrl, this.isOnline = false});

  Map<String, dynamic> toJson() => {
        "username": username,
        "imageUrl": imageUrl,
      };

  factory Friend.fromJson(Map<String, dynamic> data) => Friend(
        username: data["username"],
        imageUrl: data["imageUrl"],
      );
}
