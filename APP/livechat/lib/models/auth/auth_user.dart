import 'package:isar/isar.dart';
import 'package:livechat/models/user.dart';

import '../../services/hash_service.dart';
import '../friend.dart';

part 'auth_user.g.dart';

@collection
class AuthUser extends User {
  final String token;
  List<Friend> friends;
  bool isLogged = true;

  Id get isarId => fastHash(id);

  AuthUser(this.token, this.friends, String id, String username,
      String imageUrl, String email, String phoneNumber)
      : super(id, username, imageUrl, email, phoneNumber);

  AuthUser.fromMap(Map<String, dynamic> map)
      : token = map["token"],
        friends =
            (map["friends"] as List).map((e) => Friend.fromJson(e)).toList(),
        super(
          map["id"],
          map["username"],
          map["imageUrl"],
          map["email"],
          map["phoneNumber"],
        );
}
