
import 'package:isar/isar.dart';

part 'user.g.dart';

@collection
class User {
  Id? id;

  @Index(unique: true)
  final String username;
  final String imageUrl;

  @Ignore()
  bool isOnline = false;

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
