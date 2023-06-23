import 'package:isar/isar.dart';

import 'user.dart';

part 'friend.g.dart';

@embedded
class Friend extends User {
  @ignore
  bool isOnline = false;

  Friend(
      {String id = '',
      String username = '',
      String imageUrl = '',
      String email = '',
      String phoneNumber = ''})
      : super(id, username, imageUrl, email, phoneNumber);

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "imageUrl": imageUrl,
        "email": email,
        "phoneNumber": phoneNumber
      };

  factory Friend.fromJson(Map<String, dynamic> data) => Friend(
        id: data["id"],
        username: data["username"],
        imageUrl: data["imageUrl"],
        email: data["email"],
        phoneNumber: data["phoneNumber"],
      );
}
