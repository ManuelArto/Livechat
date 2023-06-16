import 'user.dart';

class Friend extends User {
  bool isOnline = false;

  Friend(
      {required String username,
      required String imageUrl,
      required String email,
      required String phoneNumber,
      this.isOnline = false})
      : super(username, imageUrl, email, phoneNumber);

  Map<String, dynamic> toJson() => {
        "username": username,
        "imageUrl": imageUrl,
        "email": email,
        "phoneNumber": phoneNumber
      };

  factory Friend.fromJson(Map<String, dynamic> data) => Friend(
        username: data["username"],
        imageUrl: data["imageUrl"],
        email: data["email"],
        phoneNumber: data["phoneNumber"],
      );
}
