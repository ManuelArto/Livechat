import 'package:isar/isar.dart';

import 'user.dart';

part 'friend.g.dart';

@embedded
class Friend extends User {
  @ignore
  bool isOnline = false;

  double lat;
  double long;

  Friend({
    String id = '',
    String username = '',
    String imageUrl = '',
    String email = '',
    String phoneNumber = '',
    this.lat = 0,
    this.long = 0,
  }) : super(id, username, imageUrl, email, phoneNumber);

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "imageUrl": imageUrl,
        "email": email,
        "phoneNumber": phoneNumber,
        "lat": lat,
        "long": long,
      };

  factory Friend.fromJson(Map<String, dynamic> data) => Friend(
        id: data["id"],
        username: data["username"],
        imageUrl: data["imageUrl"],
        email: data["email"],
        phoneNumber: data["phoneNumber"],
        lat: data["location"]?["lat"],
        long: data["location"]?["long"],
      );
}
