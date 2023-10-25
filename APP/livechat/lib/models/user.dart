class User {
  final String id;
  final String username;
  final String email;
  final String phoneNumber;
  final String imageUrl;

  User(this.id, this.username, this.imageUrl, this.email, this.phoneNumber);

  factory User.fromJson(Map<String, dynamic> data) => User(
        data["id"],
        data["username"],
        data["imageUrl"],
        data["email"],
        data["phoneNumber"],
      );
}
