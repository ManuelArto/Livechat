import 'package:isar/isar.dart';

import '../../services/hash_service.dart';

part 'auth_user.g.dart';

@collection
class AuthUser {
  final String id;
  final String token;
  final String username;
  final String imageUrl;
  bool isLogged = true;

  Id get isarId => fastHash(id);

  AuthUser(this.token, this.id, this.username, this.imageUrl);

  AuthUser.fromMap(Map<String, dynamic> map)
      : token = map["token"],
        id = map["id"],
        username = map["username"],
        imageUrl = map["imageUrl"];

  Map<String, dynamic> toJson() => {
        "token": token,
        "id": id,
        "username": username,
        "imageUrl": imageUrl,
      };
}
