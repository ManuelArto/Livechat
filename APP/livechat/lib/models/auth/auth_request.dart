class AuthRequest {
  String? username;
  String? password;
  String? email;
  String? imageFile;
  bool isLogin = false;

  bool get userPickedImage => !isLogin && imageFile != null;

  Map<String, dynamic> toMap() {
    return {
      "username": username,
      "password": password,
      if (!isLogin)
        "email": email,
        "imageFile": imageFile,
    };
  }

}
