import 'package:isar/isar.dart';
import 'package:livechat/models/user.dart';

import '../../services/hash_service.dart';

part 'auth_user.g.dart';

@collection
class AuthUser extends User {
  final String id;
  final String token;
  // TODO: add email and phone number
  // TODO: add theme and themeMode
  bool isLogged = true;

  Id get isarId => fastHash(id);

  AuthUser(this.token, this.id, String username, String imageUrl, String email, String phoneNumber) : super(username, imageUrl, email, phoneNumber);

  AuthUser.fromMap(Map<String, dynamic> map)
      : token = map["token"],
        id = map["id"],
        super(map["username"], map["imageUrl"], map["email"], map["phoneNumber"]);
}
