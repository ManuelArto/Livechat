import 'user.dart';

class Friend extends User {
  bool isOnline = false;

  Friend(
      {required String username,
      required String imageUrl,
      this.isOnline = false})
      : super(username, imageUrl);

  Map<String, dynamic> toJson() => {
        "username": username,
        "imageUrl": imageUrl,
      };

  factory Friend.fromJson(Map<String, dynamic> data) => Friend(
        username: data["username"],
        imageUrl: data["imageUrl"],
      );
}
