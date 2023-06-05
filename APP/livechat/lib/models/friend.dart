
import 'package:isar/isar.dart';

import 'auth/auth_user.dart';

part 'friend.g.dart';

@collection
class Friend {
  Id? id;

  @Index(unique: true)
  final String username;
  final String imageUrl;

  final authUser = IsarLink<AuthUser>();

  @Ignore()
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
