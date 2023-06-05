import 'package:isar/isar.dart';

part 'auth_user.g.dart';

@collection
class AuthUser {
  Id? id;
  final String userId;
  final String token;
  final String username;
  final String imageUrl;
  bool isLogged = true;

  AuthUser(this.token, this.userId, this.username, this.imageUrl);

  AuthUser.fromMap(Map<String, dynamic> map)
      : token = map["token"],
        userId = map["id"],
        username = map["username"],
        imageUrl = map["imageUrl"];

  Map<String, dynamic> toJson() => {
        "token": token,
        "id": userId,
        "username": username,
        "imageUrl": imageUrl,
      };
}
